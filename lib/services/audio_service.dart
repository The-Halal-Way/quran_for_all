import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart' as audio_session;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/ayah_model.dart';

class AudioService {
  AudioService({required http.Client httpClient}) : _httpClient = httpClient {
    _playerStateSubscription = _player.onPlayerStateChanged.listen(
      _onPlayerStateChanged,
    );
    unawaited(_configureAudioSession());
  }

  /// Configures the platform audio session so that:
  ///   - iOS: uses the `playback` category (allows background audio).
  ///   - Android: requests media audio focus for music playback.
  Future<void> _configureAudioSession() async {
    try {
      final session = await audio_session.AudioSession.instance;
      await session.configure(
        const audio_session.AudioSessionConfiguration(
          avAudioSessionCategory:
              audio_session.AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              audio_session.AVAudioSessionCategoryOptions.allowBluetooth,
          avAudioSessionMode: audio_session.AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy:
              audio_session.AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions:
              audio_session.AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: audio_session.AndroidAudioAttributes(
            contentType: audio_session.AndroidAudioContentType.music,
            flags: audio_session.AndroidAudioFlags.none,
            usage: audio_session.AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType:
              audio_session.AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ),
      );
    } catch (e) {
      // Non-fatal: log and continue; playback still works without session config.
      debugPrint('AudioService: failed to configure audio session - $e');
    }
  }

  final http.Client _httpClient;
  final AudioPlayer _player = AudioPlayer();
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isPausedController =
      StreamController<bool>.broadcast();
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _isPlaying = false;
  bool _isPaused = false;
  bool _stopRequested = false;

  /// True while [playSurah] is actively iterating through ayahs.
  /// Suppresses intermediate [_setIsPlaying(false)] calls that fire between
  /// ayahs (when PlayerState transitions to completed), which would otherwise
  /// cause the mini-player to flicker off and on during full-surah playback.
  bool _surahPlaybackActive = false;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<bool> get isPausedStream => _isPausedController.stream;
  Stream<Duration> get positionStream => _player.onPositionChanged;
  Stream<Duration> get durationStream => _player.onDurationChanged;

  Future<void> playAyah(AyahModel ayah) async {
    _stopRequested = false;

    final localPath = await _getOrDownloadAyahAudio(ayah);

    // Guard: stop() may have been called while the download was in flight.
    if (_stopRequested) return;

    _setIsPlaying(true);

    await _player.play(DeviceFileSource(localPath));
  }

  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0}) async {
    _stopRequested = false;
    _surahPlaybackActive = true;

    try {
      for (var i = startIndex; i < ayahs.length; i++) {
        if (_stopRequested) {
          break;
        }

        await playAyah(ayahs[i]);
        await _waitForCompleteOrStop();
      }
    } finally {
      _surahPlaybackActive = false;
      _setIsPlaying(false);
    }
  }

  Future<void> stop() async {
    _stopRequested = true;
    await _player.stop();
    _setIsPlaying(false);
  }

  Future<void> pause() async {
    if (!_isPlaying) return;
    await _player.pause();
  }

  Future<void> resume() async {
    if (!_isPaused) return;
    await _player.resume();
  }

  Future<String> _getOrDownloadAyahAudio(AyahModel ayah) async {
    final cacheDir = await _audioCacheDirectory();
    final audioFile = File(join(cacheDir.path, '${ayah.id}.mp3'));

    if (await audioFile.exists()) {
      return audioFile.path;
    }

    // Validate URL scheme before making a network request (OWASP A10 – SSRF).
    final uri = Uri.tryParse(ayah.audioUrl);
    if (uri == null ||
        !uri.hasScheme ||
        !{'http', 'https'}.contains(uri.scheme)) {
      throw Exception('Invalid audio URL for ayah ${ayah.id}');
    }

    final response = await _httpClient
        .get(uri)
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw Exception('Failed to load ayah audio (${ayah.id})');
    }

    await audioFile.writeAsBytes(response.bodyBytes, flush: true);
    return audioFile.path;
  }

  Future<Directory> _audioCacheDirectory() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final directory = Directory(join(supportDirectory.path, 'quran_audio'));

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<void> _waitForCompleteOrStop() async {
    final completer = Completer<void>();

    late StreamSubscription<void> completeSubscription;
    late StreamSubscription<PlayerState> stateSubscription;

    completeSubscription = _player.onPlayerComplete.listen((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    stateSubscription = _player.onPlayerStateChanged.listen((state) {
      if (_stopRequested &&
          state != PlayerState.playing &&
          !completer.isCompleted) {
        completer.complete();
      }
    });

    await completer.future;

    await completeSubscription.cancel();
    await stateSubscription.cancel();
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (state == PlayerState.playing) {
      _setIsPlaying(true);
      _setIsPaused(false);
      return;
    }

    if (state == PlayerState.paused) {
      _setIsPaused(true);
      return;
    }

    // During full-surah playback the player briefly transitions to
    // PlayerState.completed between ayahs. Suppress the false emission so the
    // mini-player doesn't flicker off and on between ayahs. playSurah's
    // finally block is responsible for emitting false when the loop ends.
    if (_surahPlaybackActive) return;

    _setIsPaused(false);
    _setIsPlaying(false);
  }

  void _setIsPlaying(bool value) {
    if (_isPlaying == value) return;
    _isPlaying = value;
    if (!_isPlayingController.isClosed) {
      _isPlayingController.add(value);
    }
  }

  void _setIsPaused(bool value) {
    if (_isPaused == value) return;
    _isPaused = value;
    if (!_isPausedController.isClosed) {
      _isPausedController.add(value);
    }
  }

  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    await _player.dispose();
    await _isPlayingController.close();
    await _isPausedController.close();
  }
}

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
      debugPrint('AudioService: failed to configure audio session – $e');
    }
  }

  final http.Client _httpClient;
  final AudioPlayer _player = AudioPlayer();
  final StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool _isPlaying = false;
  bool _stopRequested = false;

  bool get isPlaying => _isPlaying;
  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  Future<void> playAyah(AyahModel ayah) async {
    _stopRequested = false;

    final localPath = await _getOrDownloadAyahAudio(ayah);
    _setIsPlaying(true);

    await _player.play(DeviceFileSource(localPath));
  }

  Future<void> playSurah(List<AyahModel> ayahs, {int startIndex = 0}) async {
    _stopRequested = false;

    for (var i = startIndex; i < ayahs.length; i++) {
      if (_stopRequested) {
        break;
      }

      await playAyah(ayahs[i]);
      await _waitForCompleteOrStop();
    }

    _setIsPlaying(false);
  }

  Future<void> stop() async {
    _stopRequested = true;
    await _player.stop();
    _setIsPlaying(false);
  }

  Future<String> _getOrDownloadAyahAudio(AyahModel ayah) async {
    final cacheDir = await _audioCacheDirectory();
    final audioFile = File(join(cacheDir.path, '${ayah.id}.mp3'));

    if (await audioFile.exists()) {
      return audioFile.path;
    }

    final response = await _httpClient.get(Uri.parse(ayah.audioUrl));
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
      return;
    }

    _setIsPlaying(false);
  }

  void _setIsPlaying(bool value) {
    if (_isPlaying == value) {
      return;
    }

    _isPlaying = value;
    if (!_isPlayingController.isClosed) {
      _isPlayingController.add(value);
    }
  }

  Future<void> dispose() async {
    await _playerStateSubscription?.cancel();
    await _player.dispose();
    await _isPlayingController.close();
  }
}

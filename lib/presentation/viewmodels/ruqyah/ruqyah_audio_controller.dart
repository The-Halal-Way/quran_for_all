import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../../../services/ruqyah/ruqyah_audio_cache.dart';

/// A foreground passage player. Its native player is created on first play.
/// Completion advances the recording, never the personal recitation counter.
class RuqyahAudioController extends ChangeNotifier {
  RuqyahAudioController({
    RuqyahAudioCache? cache,
    this.beforePlay,
    AudioPlayer Function()? playerFactory,
    Future<void> Function()? configureSession,
  }) : cache = cache ?? RuqyahAudioCache(),
       _playerFactory = playerFactory ?? AudioPlayer.new,
       _configureSession = configureSession;
  final RuqyahAudioCache cache;
  final Future<void> Function()? beforePlay;
  final AudioPlayer Function() _playerFactory;
  final Future<void> Function()? _configureSession;
  AudioPlayer? _player;
  Future<AudioPlayer>? _creatingPlayer;
  AudioSession? _session;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  List<int> verses = [];
  int verseIndex = 0, _generation = 0;
  bool playing = false, paused = false, busy = false, failed = false;
  bool repeat = false, downloaded = false, downloading = false;
  double downloadProgress = 0;
  Duration position = Duration.zero, duration = Duration.zero;
  bool _disposed = false;
  bool _ended = false;

  Future<void> select(List<int> ids) async {
    final ticket = ++_generation;
    verses = List.of(ids);
    verseIndex = 0;
    playing = paused = busy = failed = downloaded = false;
    _ended = false;
    position = duration = Duration.zero;
    _notify();
    try {
      await _player?.stop();
    } catch (_) {
      /* A later play can retry. */
    }
    try {
      final saved = await cache.isDownloaded(ids);
      if (ticket == _generation && !_disposed) {
        downloaded = saved;
        _notify();
      }
    } catch (_) {
      /* Storage unavailable: streaming remains possible. */
    }
  }

  Future<AudioPlayer> _ensurePlayer() async {
    if (_player case final player?) return player;
    return _creatingPlayer ??= _createPlayer().catchError((Object error) {
      _creatingPlayer = null;
      throw error;
    });
  }

  Future<AudioPlayer> _createPlayer() async {
    if (_configureSession != null) {
      await _configureSession();
    } else {
      _session = await AudioSession.instance;
      await _session!.configure(const AudioSessionConfiguration.speech());
    }
    if (_disposed) throw StateError('Reader closed.');
    final player = _playerFactory();
    _player = player;
    _subscriptions.addAll([
      player.onPositionChanged.listen((value) {
        position = value;
        _notify();
      }),
      player.onDurationChanged.listen((value) {
        duration = value;
        _notify();
      }),
      player.onPlayerComplete.listen((_) => _complete()),
      player.onPlayerStateChanged.listen(
        (state) {
          if (state == PlayerState.paused && playing) {
            playing = false;
            paused = true;
            _notify();
          }
        },
        onError: (Object _) {
          playing = paused = busy = false;
          failed = true;
          _notify();
        },
      ),
      if (_session != null)
        _session!.interruptionEventStream.listen((event) {
          if (event.begin) pause();
        }),
      if (_session != null)
        _session!.becomingNoisyEventStream.listen((_) => pause()),
    ]);
    return player;
  }

  Future<void> toggle() async {
    if (_disposed || busy || verses.isEmpty) return;
    if (playing) return pause();
    if (paused) {
      final ticket = _generation;
      try {
        if (_disposed || ticket != _generation) return;
        await _player?.resume();
        if (_disposed || ticket != _generation) return;
        playing = true;
        paused = false;
        _notify();
      } catch (_) {
        failed = true;
        _notify();
      }
      return;
    }
    if (_ended) {
      verseIndex = 0;
      _ended = false;
    }
    await _playVerse();
  }

  Future<void> _playVerse() async {
    final ticket = ++_generation;
    busy = true;
    failed = false;
    paused = playing = false;
    position = duration = Duration.zero;
    _notify();
    try {
      await beforePlay?.call();
      if (_disposed || ticket != _generation) return;
      final player = await _ensurePlayer();
      if (_disposed || ticket != _generation) return;
      // AudioPlayer requests native audio focus itself. A second request from
      // audio_session can interrupt our own player on Android.
      final verse = verses[verseIndex];
      final local = await cache.localPath(verse);
      if (_disposed || ticket != _generation) return;
      playing = true;
      await player.play(
        local == null ? UrlSource(cache.url(verse)) : DeviceFileSource(local),
      );
      if (_disposed || ticket != _generation) return;
      playing = true;
    } catch (_) {
      if (ticket == _generation) {
        failed = true;
        playing = paused = false;
      }
    } finally {
      if (ticket == _generation) {
        busy = false;
        _notify();
      }
    }
  }

  void _complete() {
    if (_disposed || !playing) return;
    if (verseIndex + 1 < verses.length) {
      verseIndex++;
      _playVerse();
    } else if (repeat) {
      verseIndex = 0;
      _playVerse();
    } else {
      playing = paused = false;
      _ended = true;
      position = duration;
      _notify();
    }
  }

  Future<void> pause() async {
    if (busy) {
      await stop();
      return;
    }
    if (!playing || _disposed) return;
    try {
      await _player?.pause();
      playing = false;
      paused = true;
    } catch (_) {
      failed = true;
    }
    _notify();
  }

  Future<void> moveVerse(int offset) async {
    final next = verseIndex + offset;
    if (next < 0 || next >= verses.length || busy) return;
    verseIndex = next;
    _ended = false;
    await _playVerse();
  }

  Future<void> seek(double value) async {
    try {
      await _player?.seek(Duration(milliseconds: value.round()));
    } catch (_) {
      failed = true;
      _notify();
    }
  }

  void toggleRepeat() {
    repeat = !repeat;
    _notify();
  }

  Future<void> download() async {
    if (downloading || downloaded || verses.isEmpty) return;
    final selection = List<int>.of(verses);
    downloading = true;
    downloadProgress = 0;
    failed = false;
    _notify();
    try {
      await cache.download(selection, (value) {
        downloadProgress = value;
        _notify();
      });
      if (listEquals(selection, verses)) downloaded = true;
    } catch (_) {
      failed = true;
    }
    downloading = false;
    _notify();
  }

  Future<void> stop() async {
    ++_generation;
    playing = paused = busy = false;
    try {
      await _player?.stop();
    } catch (_) {
      /* The reader is still usable. */
    }
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_generation;
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _player?.dispose();
    cache.dispose();
    super.dispose();
  }
}

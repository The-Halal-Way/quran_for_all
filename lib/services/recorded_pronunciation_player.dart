import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

/// Creates a native player on the first tap and reuses it for short recordings.
class RecordedPronunciationPlayer {
  AudioPlayer? _player;
  Future<void> _commands = Future<void>.value();
  Completer<void>? _clipDone;
  int _request = 0;
  bool _disposed = false;

  bool _isCurrent(int request) => !_disposed && request == _request;

  // Native source/stop operations must finish in order when taps arrive quickly.
  Future<void> _enqueue(Future<void> Function() operation) {
    final next = _commands.then((_) => operation());
    _commands = next.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return next;
  }

  Future<void> play(
    List<String> assets, {
    required void Function() onStarted,
  }) async {
    if (_disposed) return;
    final request = ++_request;
    _finishClip();
    await _enqueue(() async {
      if (!_isCurrent(request)) return;
      if (_player case final player?) {
        await player.stop();
        return;
      }
      final player = _player = AudioPlayer();
      try {
        await player.setAudioContext(
          AudioContext(
            android: const AudioContextAndroid(
              contentType: AndroidContentType.speech,
              usageType: AndroidUsageType.media,
              audioFocus: AndroidAudioFocus.gainTransient,
            ),
            iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
          ),
        );
        await player.setReleaseMode(ReleaseMode.stop);
      } catch (_) {
        _player = null;
        await player.dispose();
        rethrow;
      }
    });

    for (final asset in assets) {
      if (!_isCurrent(request)) return;
      final done = Completer<void>();
      _clipDone = done;
      StreamSubscription<void>? completion;
      Object? playbackError;
      try {
        await _enqueue(() async {
          if (!_isCurrent(request)) return;
          final player = _player!;
          await player.setSource(AssetSource(asset));
          if (!_isCurrent(request)) return;
          completion = player.onPlayerComplete.listen(
            (_) {
              if (!done.isCompleted) done.complete();
            },
            onError: (Object error) {
              playbackError = error;
              if (!done.isCompleted) done.complete();
            },
          );
          await player.resume();
          if (_isCurrent(request)) onStarted();
        });
        if (!_isCurrent(request)) return;
        await done.future.timeout(const Duration(seconds: 15));
        if (_isCurrent(request) && playbackError != null) throw playbackError!;
      } finally {
        await completion?.cancel();
        if (identical(_clipDone, done)) _clipDone = null;
      }
    }
  }

  void _finishClip() {
    final done = _clipDone;
    _clipDone = null;
    if (done != null && !done.isCompleted) done.complete();
  }

  Future<void> stop() {
    ++_request;
    _finishClip();
    return _enqueue(() async => _player?.stop());
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    ++_request;
    _finishClip();
    await _enqueue(() async {
      final player = _player;
      _player = null;
      await player?.dispose();
    });
  }
}

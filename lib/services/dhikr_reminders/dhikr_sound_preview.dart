import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import '../../data/models/dhikr_reminders/dhikr_reminder_sound.dart';

/// Owns one lazily created player; rapid taps cannot overlap native commands.
class DhikrSoundPreview extends ChangeNotifier with WidgetsBindingObserver {
  DhikrSoundPreview({AudioPlayer Function()? createPlayer})
    : _createPlayer = createPlayer ?? AudioPlayer.new {
    WidgetsBinding.instance.addObserver(this);
  }
  final AudioPlayer Function() _createPlayer;
  AudioPlayer? _player;
  StreamSubscription<void>? _completion;
  StreamSubscription<PlayerState>? _state;
  Future<void> _commands = Future<void>.value();
  bool _configured = false, _disposed = false;
  int _request = 0;
  DhikrReminderSound? activeSound;
  bool loading = false, failed = false;

  bool _current(int request) => !_disposed && request == _request;

  Future<void> toggle(DhikrReminderSound sound) {
    if (_disposed) return Future<void>.value();
    if (activeSound == sound) return stop();
    final request = ++_request;
    activeSound = sound;
    loading = true;
    failed = false;
    notifyListeners();
    return _enqueue(() async {
      if (!_current(request)) return;
      try {
        final player = _player ??= _createPlayer();
        if (!_configured) {
          await player.setAudioContext(
            AudioContext(
              android: const AudioContextAndroid(
                contentType: AndroidContentType.music,
                usageType: AndroidUsageType.media,
                audioFocus: AndroidAudioFocus.gainTransient,
              ),
              iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
            ),
          );
          await player.setReleaseMode(ReleaseMode.stop);
          _completion = player.onPlayerComplete.listen((_) {
            if (!_disposed && !loading) _clear();
          }, onError: (Object _) => _fail());
          _state = player.onPlayerStateChanged.listen((state) {
            if (state == PlayerState.paused &&
                activeSound != null &&
                !loading) {
              unawaited(stop());
            }
          });
          _configured = true;
        }
        await player.stop();
        if (!_current(request)) return;
        await player.play(AssetSource(sound.assetPath));
        if (_current(request)) {
          loading = false;
          notifyListeners();
        }
      } catch (_) {
        if (_current(request)) _fail();
      }
    });
  }

  Future<void> stop({bool notify = true}) {
    if (_disposed) return Future<void>.value();
    ++_request;
    _clear(notify: notify);
    return _enqueue(() async {
      try {
        await _player?.stop();
      } catch (_) {
        _fail(notify: notify);
      }
    });
  }

  Future<void> _enqueue(Future<void> Function() command) {
    final next = _commands.then((_) => command());
    _commands = next.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return next;
  }

  void _clear({bool notify = true}) {
    activeSound = null;
    loading = false;
    if (!_disposed && notify) notifyListeners();
  }

  void _fail({bool notify = true}) {
    failed = true;
    _clear(notify: notify);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(stop());
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    ++_request;
    WidgetsBinding.instance.removeObserver(this);
    unawaited(
      _enqueue(() async {
        await _completion?.cancel();
        await _state?.cancel();
        await _player?.dispose();
      }).catchError((Object _) {}),
    );
    super.dispose();
  }
}

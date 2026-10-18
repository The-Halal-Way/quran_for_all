import 'dart:async';

import 'package:flutter/services.dart';

class TasbeehHaptics {
  const TasbeehHaptics._();

  static const _channel = MethodChannel('quran_for_all/tasbeeh_haptics');
  static const _targetDuration = Duration(milliseconds: 1500);
  static final _clock = Stopwatch()..start();
  static Duration _targetAlertUntil = Duration.zero;

  static bool get _targetAlertPlaying => _clock.elapsed < _targetAlertUntil;

  static void select() {
    // A light tap on the same motor can replace the sustained target alert.
    if (_targetAlertPlaying) return;
    unawaited(HapticFeedback.selectionClick());
  }

  static void count({required bool targetReached}) {
    if (!targetReached) {
      select();
      return;
    }

    if (_targetAlertPlaying) return;
    unawaited(_targetReached());
  }

  static Future<void> _targetReached() async {
    _targetAlertUntil = _clock.elapsed + _targetDuration;
    try {
      final started = await _channel.invokeMethod<bool>('targetReached', {
        'durationMs': _targetDuration.inMilliseconds,
      });
      _targetAlertUntil = started == true
          ? _clock.elapsed + _targetDuration
          : Duration.zero;
    } on MissingPluginException {
      // Desktop/web builds have no phone vibration motor implementation.
      _targetAlertUntil = Duration.zero;
    } on PlatformException {
      // Vibration availability must never prevent counting a dhikr.
      _targetAlertUntil = Duration.zero;
    }
  }
}

import 'dart:async';

import 'package:flutter/services.dart';

class TasbeehHaptics {
  const TasbeehHaptics._();

  static void select() {
    unawaited(HapticFeedback.selectionClick());
  }

  static void count({required bool targetReached}) {
    if (!targetReached) {
      unawaited(HapticFeedback.selectionClick());
      return;
    }

    // A three-pulse pattern is easy to recognize without looking at the
    // screen and remains distinct from the light feedback used for each tap.
    unawaited(HapticFeedback.heavyImpact());
    Future<void>.delayed(const Duration(milliseconds: 130), () {
      unawaited(HapticFeedback.mediumImpact());
    });
    Future<void>.delayed(const Duration(milliseconds: 280), () {
      unawaited(HapticFeedback.heavyImpact());
    });
  }
}

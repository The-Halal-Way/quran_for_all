import 'package:flutter/material.dart';
import '../../../../core/theme/my_colors.dart';

class PrayerMovementStyle {
  const PrayerMovementStyle._();

  static Color accentFor(int number) => switch (number % 4) {
    0 => MyColors.info,
    1 => MyColors.secondary,
    2 => MyColors.tertiary,
    _ => MyColors.primaryLight,
  };
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class PrayerMovementTinyNumber extends StatelessWidget {
  const PrayerMovementTinyNumber({
    super.key,
    required this.number,
    required this.accent,
  });

  final int number;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: text.prayerStatusChip.copyWith(color: accent, height: 1),
        ),
      ),
    );
  }
}

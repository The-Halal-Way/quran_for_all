import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class PrayerMovementNumberBadge extends StatelessWidget {
  const PrayerMovementNumberBadge({
    super.key,
    required this.number,
    required this.accent,
  });

  final int number;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: text.prayerStepIndex.copyWith(color: accent),
        ),
      ),
    );
  }
}

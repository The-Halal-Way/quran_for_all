import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class PrayerMovementHeroEyebrow extends StatelessWidget {
  const PrayerMovementHeroEyebrow({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: text.prayerHeroChip.copyWith(color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class SpecialPrayerHeroArabic extends StatelessWidget {
  const SpecialPrayerHeroArabic({
    super.key,
    required this.content,
    required this.accent,
  });

  final SpecialPrayerContent content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
            ),
            child: Icon(_iconFor(content.type), color: Colors.white, size: 27),
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              content.heroArabic,
              textAlign: TextAlign.center,
              style: AppTheme.amiri(
                context,
                fontSize: 36,
                fontWeight: AppTheme.weightBold,
                color: Colors.white,
                height: 1.2,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 64,
            height: 3,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => Icons.local_florist_rounded,
      SpecialPrayerType.salatulTasbeeh => Icons.brightness_5_rounded,
    };
  }
}

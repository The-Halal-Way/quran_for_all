import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_card_shell.dart';
import 'special_prayer_hero_arabic.dart';
import 'special_prayer_hero_pattern.dart';
import 'special_prayer_hero_text.dart';

class SpecialPrayerHero extends StatelessWidget {
  const SpecialPrayerHero({super.key, required this.content});

  final SpecialPrayerContent content;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accentFor(content.type);
    final companion = _companionFor(content.type);

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: Colors.white.withValues(alpha: isDark ? 0.13 : 0.26),
      shadowColor: accent,
      gradient: LinearGradient(
        colors: isDark
            ? [
                MyColors.primaryDark,
                accent.withValues(alpha: 0.42),
                companion.withValues(alpha: 0.34),
              ]
            : [
                accent.withValues(alpha: 0.92),
                companion.withValues(alpha: 0.82),
                MyColors.primaryLight.withValues(alpha: 0.82),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: SpecialPrayerHeroPattern(
                  color: Colors.white.withValues(alpha: isDark ? 0.10 : 0.20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textPanel = SpecialPrayerHeroText(
                    content: content,
                    accent: accent,
                  );
                  final arabicPanel = SpecialPrayerHeroArabic(
                    content: content,
                    accent: accent,
                  );

                  if (constraints.maxWidth < 680) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textPanel,
                        const SizedBox(height: AppSpacing.lg),
                        arabicPanel,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 7, child: textPanel),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(flex: 4, child: arabicPanel),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _accentFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => MyColors.tertiaryLight,
      SpecialPrayerType.salatulTasbeeh => MyColors.secondaryLight,
    };
  }

  Color _companionFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => MyColors.info,
      SpecialPrayerType.salatulTasbeeh => MyColors.tertiary,
    };
  }
}

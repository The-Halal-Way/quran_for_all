import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_guide_variant.dart';
import 'prayer_movement_hero_eyebrow.dart';
import 'prayer_movement_hero_stage.dart';
import 'prayer_movement_hero_stat.dart';

class PrayerMovementGuideHero extends StatelessWidget {
  const PrayerMovementGuideHero({
    super.key,
    required this.stepCount,
    required this.variant,
  });

  final int stepCount;
  final PrayerGuideVariant variant;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final heroCopy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            PrayerMovementHeroEyebrow(
              label: variant == PrayerGuideVariant.female
                  ? context.l10n.prayerMovementsFemaleGuideLabel
                  : context.l10n.prayerMovementsMaleGuideLabel,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.prayerMovementsHeroTitle,
              style: text.prayerHeroTitle.copyWith(
                color: Colors.white,
                height: 1.08,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.prayerMovementsHeroBody,
              style: text.prayerHeroSubtitle.copyWith(
                color: Colors.white.withValues(alpha: 0.84),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                PrayerMovementHeroStat(
                  icon: Icons.self_improvement_rounded,
                  label: context.l10n.prayerMovementsHeroStepsCount(stepCount),
                ),
                PrayerMovementHeroStat(
                  icon: Icons.record_voice_over_rounded,
                  label: context.l10n.prayerMovementsHeroArabicLabel,
                ),
                PrayerMovementHeroStat(
                  icon: Icons.menu_book_rounded,
                  label: context.l10n.prayerMovementsHeroHadithLabel,
                ),
              ],
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: const LinearGradient(
              colors: [
                MyColors.primaryDark,
                MyColors.primary,
                MyColors.secondaryDark,
                MyColors.tertiaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: AppShadows.card(tint: MyColors.secondary),
          ),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: isWide
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (isWide) Expanded(flex: 6, child: heroCopy) else heroCopy,
              if (isWide) const SizedBox(width: AppSpacing.xxl),
              if (!isWide) const SizedBox(height: AppSpacing.xl),
              if (isWide)
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PrayerMovementHeroStage(variant: variant),
                  ),
                )
              else
                Align(
                  alignment: Alignment.center,
                  child: PrayerMovementHeroStage(variant: variant),
                ),
            ],
          ),
        );
      },
    );
  }
}

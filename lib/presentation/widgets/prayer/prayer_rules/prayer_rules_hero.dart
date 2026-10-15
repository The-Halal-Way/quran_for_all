import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/my_images.dart';

class PrayerRulesHero extends StatelessWidget {
  const PrayerRulesHero({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            MyColors.primaryDark,
            MyColors.primary,
            MyColors.tertiaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: AppShadows.card(tint: MyColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.prayerRulesHeroLabel.toUpperCase(),
            style: text.labelMedium.copyWith(
              color: MyColors.secondaryLight,
              fontWeight: AppTheme.weightExtraBold,
              letterSpacing: 1.15,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.prayerRulesTitle,
            style: text.prayerHeroTitle.copyWith(
              color: Colors.white,
              height: 1.05,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.prayerRulesSubtitle,
            style: text.prayerHeroSubtitle.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.prayerRulesHeroBody,
            style: text.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.74),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.95),
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Image.asset(
                MyImages.wuduOverview,
                height: 190,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  height: 190,
                  child: Center(child: Text(context.l10n.prayerRulesTitle)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

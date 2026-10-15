import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/my_images.dart';

class WuduHero extends StatelessWidget {
  const WuduHero({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MyColors.tertiaryDark, MyColors.tertiary, MyColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: AppShadows.card(tint: MyColors.tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: MyColors.secondaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.secondary.withValues(alpha: 0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: MyColors.primaryDark,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  context.l10n.prayerWuduHeroLabel.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelMedium.copyWith(
                    color: MyColors.secondaryLight,
                    fontWeight: AppTheme.weightExtraBold,
                    letterSpacing: 1.15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.prayerWuduTitle,
            style: text.prayerHeroTitle.copyWith(
              color: Colors.white,
              height: 1.05,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.prayerWuduSubtitle,
            style: text.prayerHeroSubtitle.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.prayerWuduHeroBody,
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
                height: 242,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  height: 242,
                  child: Center(child: Text(context.l10n.prayerWuduTitle)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

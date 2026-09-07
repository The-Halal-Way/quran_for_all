import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'sunnah_dua_day_ribbon.dart';
import 'sunnah_dua_hero_artwork.dart';
import 'sunnah_dua_hero_back_button.dart';

class SunnahDuaHero extends StatelessWidget {
  const SunnahDuaHero({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 400;
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            gradient: const LinearGradient(
              colors: [
                MyColors.primaryDark,
                MyColors.primary,
                MyColors.secondaryDark,
              ],
              stops: [0, 0.62, 1],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            border: Border.all(
              color: MyColors.secondaryLight.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primary.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onBack != null) ...[
                SunnahDuaHeroBackButton(onPressed: onBack!),
                const SizedBox(height: AppSpacing.sm),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.sunnahDuaHeroEyebrow,
                          style: text.labelSmall.copyWith(
                            color: MyColors.tertiaryLight,
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          context.l10n.sunnahDuaTitle,
                          style: text.headlineMedium.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.weightBlack,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ExcludeSemantics(
                    child: SunnahDuaHeroArtwork(
                      arabicTitle: context.l10n.sunnahDuaHeroArabic,
                      size: compact ? 92 : 132,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.sunnahDuaHeroDescription,
                style: text.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SunnahDuaDayRibbon(),
            ],
          ),
        );
      },
    );
  }
}

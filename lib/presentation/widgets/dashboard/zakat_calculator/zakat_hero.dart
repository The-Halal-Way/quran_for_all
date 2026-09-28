import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'zakat_ornament.dart';

class ZakatHero extends StatelessWidget {
  const ZakatHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryDark.withValues(alpha: 0.23),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryDark,
                MyColors.primary,
                MyColors.tertiaryDark,
              ],
              stops: [0, 0.56, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: ZakatOrnament()),
              PositionedDirectional(
                end: -28,
                bottom: -56,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        MyColors.secondaryLight.withValues(alpha: 0.15),
                        MyColors.secondaryLight.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.12,
                            ),
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          icon: const Icon(CupertinoIcons.chevron_back),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.secondaryLight.withValues(
                              alpha: 0.13,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: MyColors.secondaryLight.withValues(
                                alpha: 0.43,
                              ),
                            ),
                          ),
                          child: Text(
                            '2.5%',
                            style: AppTheme.sora(
                              context,
                              fontSize: 13,
                              fontWeight: AppTheme.weightExtraBold,
                              color: MyColors.secondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(
                      l10n.zakatHeroEyebrow,
                      style: text.labelSmall.copyWith(
                        color: MyColors.secondaryLight,
                        fontWeight: AppTheme.weightExtraBold,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.zakatHeroTitle,
                      style: text.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.weightBlack,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        color: MyColors.secondaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.zakatHeroBody,
                      style: text.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

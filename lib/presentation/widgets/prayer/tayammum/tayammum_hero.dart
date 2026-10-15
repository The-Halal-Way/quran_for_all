import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/my_images.dart';

class TayammumHero extends StatelessWidget {
  const TayammumHero({super.key});

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
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: AppShadows.card(tint: MyColors.secondary),
      ),
      child: Stack(
        children: [
          const Positioned(top: -66, right: -46, child: _HeroOrb(size: 180)),
          const Positioned(bottom: -82, left: -70, child: _HeroOrb(size: 190)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [MyColors.secondary, MyColors.secondaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.secondary.withValues(alpha: 0.32),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.back_hand_rounded,
                      color: MyColors.primaryDark,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      context.l10n.prayerTayammumHeroLabel.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelMedium.copyWith(
                        color: MyColors.secondaryLight,
                        fontWeight: AppTheme.weightExtraBold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                context.l10n.prayerTayammumTitle,
                style: text.prayerHeroTitle.copyWith(
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.prayerTayammumSubtitle,
                style: text.prayerHeroSubtitle.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.prayerTayammumHeroBody,
                style: text.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Container(
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.94),
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Image.asset(
                    MyImages.tayammumSteps,
                    height: 124,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 124,
                          child: Center(
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: MyColors.primary,
                              size: 42,
                            ),
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  const _HeroOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0),
          ],
        ),
      ),
    ),
  );
}

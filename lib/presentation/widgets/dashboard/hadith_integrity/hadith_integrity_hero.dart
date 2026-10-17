import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';

class HadithIntegrityHero extends StatelessWidget {
  const HadithIntegrityHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final text = AppTheme.text(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.heroStart, colors.heroMiddle, colors.heroEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: colors.violet.withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -38,
            top: -46,
            child: _Orb(size: 156, color: colors.cyan, opacity: 0.16),
          ),
          Positioned(
            left: -52,
            bottom: -66,
            child: _Orb(size: 180, color: colors.coral, opacity: 0.12),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Icon(
                          Icons.fact_check_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Text(
                          context.l10n.hadithIntegrityHeroKicker,
                          style: text.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontWeight: AppTheme.weightBold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  context.l10n.hadithIntegrityHeroTitle,
                  style: text.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightExtraBold,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.hadithIntegrityHeroDescription,
                  style: text.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color, required this.opacity});

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: opacity),
      shape: BoxShape.circle,
    ),
  );
}

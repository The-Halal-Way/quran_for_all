import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/app_theme_colors.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_celestial_pattern.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_dial.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/compass/compass_mode_badge.dart';

class CompassHeroCard extends StatelessWidget {
  const CompassHeroCard({
    super.key,
    required this.qiblaDegrees,
    required this.heading,
    required this.isLive,
    required this.facingMecca,
  });

  final double qiblaDegrees;
  final double heading;
  final bool isLive;
  final bool facingMecca;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final l10n = context.l10n;
    final colors = dark
        ? [MyColors.primaryDark, MyColors.primary, MyColors.primaryLight]
        : [
            AppThemeColors.light.heroStart,
            AppThemeColors.light.heroMiddle,
            AppThemeColors.light.heroEnd,
          ];

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: colors[1].withValues(alpha: dark ? 0.15 : 0.25),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: CompassCelestialPattern()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final eyebrow = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFFF1D394),
                          size: 17,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            l10n.compassHeroEyebrow,
                            style: text.labelSmall.copyWith(
                              color: const Color(0xFFF1D394),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    );
                    if (constraints.maxWidth < 300) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          eyebrow,
                          const SizedBox(height: AppSpacing.sm),
                          CompassModeBadge(isLive: isLive),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: eyebrow),
                        CompassModeBadge(isLive: isLive),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.compassHeroTitle,
                  textAlign: TextAlign.center,
                  style: text.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.compassHeroSubtitle,
                  textAlign: TextAlign.center,
                  style: text.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.68),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = math.min(constraints.maxWidth, 320.0);
                    return Center(
                      child: SizedBox.square(
                        dimension: size,
                        child: CompassDial(
                          heading: heading,
                          qiblaDegrees: qiblaDegrees,
                          facingMecca: facingMecca,
                          isLive: isLive,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${qiblaDegrees.toStringAsFixed(0)}°',
                  style: text.compassHeading.copyWith(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                Text(
                  l10n.compassBearingFromNorth,
                  style: text.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
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

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_for_all/core/theme/my_images.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/my_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';

class LearnHeaderCard extends StatelessWidget {
  const LearnHeaderCard({
    super.key,
    required this.overallProgress,
    required this.completedLessons,
    required this.totalLessons,
    required this.completedModules,
    required this.totalModules,
    required this.streakDays,
  });

  final double overallProgress;
  final int completedLessons;
  final int totalLessons;
  final int completedModules;
  final int totalModules;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.text(context);
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
    final headingSize = responsive.pick(mobile: 30, tablet: 26, desktop: 31);
    final metricGap = responsive.pick(mobile: 10, tablet: 8, desktop: 10);
    final progressHeight = responsive.pick(
      mobile: 10,
      tablet: 8.5,
      desktop: 10,
    );
    const padding = EdgeInsets.all(AppSpacing.xl - 2);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppGradients.heroBanner,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: MyColors.primary.withValues(alpha: 0.06),
            blurRadius: 56,
            offset: const Offset(0, 28),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.4,
                child: Lottie.asset(
                  MyImages.readingQuranAnimated,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                l10n.learnHeaderTitle,
                style: textTheme.headlineMedium.copyWith(
                  color: Colors.white,
                  fontSize: AppTheme.scaledFontSize(context, headingSize),
                  height: 1.12,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // subtitle
              Text(
                l10n.learnHeaderSubtitle,
                style: textTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: AppSpacing.xl - 2),
              // modules and streak box
              Row(
                spacing: metricGap,
                children: [
                  // modules progress
                  Expanded(
                    child: _MetricPill(
                      icon: Icons.workspace_premium_rounded,
                      label: l10n.learnHeaderModulesLabel,
                      value: '$completedModules/$totalModules',
                    ),
                  ),
                  // streak progress
                  Expanded(
                    child: _MetricPill(
                      icon: Icons.local_fire_department_rounded,
                      label: l10n.learnHeaderStreakLabel,
                      value: l10n.learnHeaderStreakDays(streakDays),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg - 2),
              // progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  minHeight: progressHeight,
                  value: overallProgress,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  color: MyColors.secondaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              // progress text title
              Text(
                l10n.learnHeaderLessonProgress(completedLessons, totalLessons),
                style: textTheme.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.text(context).bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(context).labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightBold,
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

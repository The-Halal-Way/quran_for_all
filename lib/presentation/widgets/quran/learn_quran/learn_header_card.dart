import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../common/app_gradient_banner.dart';

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
    return AppGradientBanner(
      gradient: AppGradients.heroBanner,
      borderRadius: AppRadius.xl,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.26),
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.learnHeaderTitle,
                      style: textTheme.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.learnHeaderSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: overallProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.24),
              color: MyColors.secondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.learnHeaderLessonProgress(completedLessons, totalLessons),
                style: textTheme.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              _MetricPill(
                icon: Icons.workspace_premium_rounded,
                label: l10n.learnHeaderModulesLabel,
                value: '$completedModules/$totalModules',
              ),
              _MetricPill(
                icon: Icons.local_fire_department_rounded,
                label: l10n.learnHeaderStreakLabel,
                value: l10n.learnHeaderStreakDays(streakDays),
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
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              '$label $value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.text(context).labelSmall.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.weightBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

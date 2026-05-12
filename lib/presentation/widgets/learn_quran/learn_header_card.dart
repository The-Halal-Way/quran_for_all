import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl - 2),
      decoration: BoxDecoration(
        gradient: AppGradients.heroBanner,
        borderRadius: BorderRadius.circular(AppRadius.xxl - 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 56,
            offset: const Offset(0, 28),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.learnHeaderTitle,
            style: textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontSize: 30.sp.clamp(24.0, 31.0),
              height: 1.12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.learnHeaderSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.xl - 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              minHeight: 10.h.clamp(8.0, 10.0),
              value: overallProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              color: AppColors.secondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          Text(
            l10n.learnHeaderLessonProgress(completedLessons, totalLessons),
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg - 2),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              SizedBox(
                width: 240,
                child: _MetricPill(
                  icon: Icons.workspace_premium_rounded,
                  label: l10n.learnHeaderModulesLabel,
                  value: '$completedModules/$totalModules',
                ),
              ),
              SizedBox(
                width: 240,
                child: _MetricPill(
                  icon: Icons.local_fire_department_rounded,
                  label: l10n.learnHeaderStreakLabel,
                  value: l10n.learnHeaderStreakDays(streakDays),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2, vertical: AppSpacing.sm + 2),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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

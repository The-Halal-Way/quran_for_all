import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../views/dashboard/daily_tracker/daily_tracker_full_view.dart';
import '../common/daily_tracker_progress_ring.dart';
import 'dashboard_navigation.dart';

class DashboardTrackerPreview extends StatelessWidget {
  const DashboardTrackerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final (completed, total, loading) = context.select(
      (DailyTrackerViewModel vm) =>
          (vm.completedTasks, vm.totalTasks, vm.isLoading),
    );
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? MyColors.tertiaryLight : MyColors.tertiaryDark;
    return Material(
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: accent.withValues(alpha: 0.25)),
      ),
      child: InkWell(
        onTap: () => pushDashboardPage(context, const DailyTrackerFullView()),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              if (loading && total == 0)
                const SizedBox.square(
                  dimension: 64,
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                DailyTrackerProgressRing(
                  completed: completed,
                  total: total,
                  size: 64,
                ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.dashboardTrackerPrompt,
                      style: text.labelSmall.copyWith(
                        color: accent,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.dailyTrackerSectionTitle,
                      style: text.titleSmall.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.dailyTrackerProgressLabel(completed, total),
                      style: text.bodySmall.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Tooltip(
                message: context.l10n.dashboardTrackerOpen,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: accent,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

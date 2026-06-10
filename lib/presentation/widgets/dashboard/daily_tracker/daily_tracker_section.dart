import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../views/dashboard/daily_tracker/daily_tracker_full_view.dart';

/// Compact dashboard card showing today's Daily Tracker progress. Tapping
/// it opens the full checklist.
class DailyTrackerSection extends StatelessWidget {
  const DailyTrackerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyTrackerViewModel>();
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? MyColors.darkCardFill : MyColors.cardFill;
    final textMain = isDark
        ? MyColors.darkTextPrimary
        : MyColors.textPrimary;
    final textHint = isDark
        ? MyColors.darkTextTertiary
        : MyColors.textTertiary;
    final divider = isDark ? MyColors.darkDivider : MyColors.divider;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DailyTrackerFullView()),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : divider.withValues(alpha: 0.8),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withValues(alpha: isDark ? 0.12 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: MyColors.tertiary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fact_check_rounded,
                    color: MyColors.tertiary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.dailyTrackerSectionTitle,
                        style: text.dashboardCardTitle.copyWith(
                          color: textMain,
                        ),
                      ),
                      Text(
                        context.l10n.dailyTrackerSectionSubtitle,
                        style: text.bodySmall.copyWith(color: textHint),
                      ),
                    ],
                  ),
                ),
                Text(
                  context.l10n.dailyTrackerProgressLabel(
                    vm.completedTasks,
                    vm.totalTasks,
                  ),
                  style: text.dashboardCardTitle.copyWith(
                    color: MyColors.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: vm.progress,
                minHeight: 6,
                backgroundColor: divider.withValues(alpha: 0.5),
                valueColor: const AlwaysStoppedAnimation(MyColors.tertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

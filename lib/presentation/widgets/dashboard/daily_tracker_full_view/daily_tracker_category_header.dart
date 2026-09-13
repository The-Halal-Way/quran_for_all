import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'daily_tracker_category_style.dart';

class DailyTrackerCategoryHeader extends StatelessWidget {
  const DailyTrackerCategoryHeader({
    super.key,
    required this.category,
    required this.completed,
    required this.total,
  });
  final TaskCategory category;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final accent = trackerCategoryColor(context, category);
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xxl,
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(category.icon, size: 19, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              trackerCategoryLabel(context, category),
              style: AppTheme.text(
                context,
              ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              context.l10n.dailyTrackerProgressLabel(completed, total),
              textAlign: TextAlign.end,
              style: AppTheme.text(context).labelSmall.copyWith(color: accent),
            ),
          ),
        ],
      ),
    );
  }
}

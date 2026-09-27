import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'daily_tracker_category_style.dart';

/// A section selector that also accommodates wrapped labels at large text sizes.
class DailyTrackerSectionPicker extends StatelessWidget {
  const DailyTrackerSectionPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final TaskCategory selected;
  final ValueChanged<TaskCategory> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<TaskCategory>(
    tooltip: context.l10n.dailyTrackerTaskSectionLabel,
    initialValue: selected,
    onOpened: () => FocusManager.instance.primaryFocus?.unfocus(),
    onSelected: onSelected,
    itemBuilder: (context) => [
      for (final category in TaskCategory.values)
        PopupMenuItem(
          value: category,
          child: Row(
            children: [
              Icon(
                category.icon,
                size: 20,
                color: trackerCategoryColor(context, category),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(trackerCategoryLabel(context, category))),
              if (category == selected) ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.check_rounded, size: 18),
              ],
            ],
          ),
        ),
    ],
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: context.l10n.dailyTrackerTaskSectionLabel,
      ),
      child: Row(
        children: [
          Icon(
            selected.icon,
            size: 22,
            color: trackerCategoryColor(context, selected),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              trackerCategoryLabel(context, selected),
              style: AppTheme.text(context).bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.expand_more_rounded, size: 22),
        ],
      ),
    ),
  );
}

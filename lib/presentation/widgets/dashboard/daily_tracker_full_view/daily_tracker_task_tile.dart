import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/daily_task_model.dart';
import 'daily_tracker_category_style.dart';
import 'daily_tracker_checkmark.dart';
import 'daily_tracker_task_badge.dart';

class DailyTrackerTaskTile extends StatelessWidget {
  const DailyTrackerTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
  });
  final DailyTask task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    final accent = trackerCategoryColor(context, task.category);
    final title = trackerTaskTitle(context, task);
    final subtitle = task.category == TaskCategory.custom ? task.titleBn : '';
    final semanticLabel = [
      title,
      if (subtitle.isNotEmpty) subtitle,
      if (task.isOptional) context.l10n.dailyTrackerOptionalBadge,
      if (task.isFridayOnly) context.l10n.dailyTrackerFridayBadge,
    ].join('. ');
    final done = task.isCompletedToday;
    return Material(
      color: Color.lerp(colors.surface, accent, done ? 0.07 : 0.015),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: done
              ? accent.withValues(alpha: 0.36)
              : colors.outline.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              checked: done,
              button: true,
              label: semanticLabel,
              onTap: onToggle,
              excludeSemantics: true,
              child: InkWell(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      DailyTrackerCheckmark(checked: done, accent: accent),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: text.bodyMedium.copyWith(
                                fontWeight: AppTheme.weightSemiBold,
                                color: done
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface,
                                decoration: done
                                    ? TextDecoration.lineThrough
                                    : null,
                                height: 1.4,
                              ),
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                subtitle,
                                style: text.bodySmall.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                            if (task.isOptional || task.isFridayOnly) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  if (task.isOptional)
                                    DailyTrackerTaskBadge(
                                      label: context
                                          .l10n
                                          .dailyTrackerOptionalBadge,
                                      accent: accent,
                                    ),
                                  if (task.isFridayOnly)
                                    DailyTrackerTaskBadge(
                                      label:
                                          context.l10n.dailyTrackerFridayBadge,
                                      accent: accent,
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              tooltip: context.l10n.dailyTrackerDeleteTaskTooltip,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: colors.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}

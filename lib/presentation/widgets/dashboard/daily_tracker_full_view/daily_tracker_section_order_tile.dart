import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'daily_tracker_category_style.dart';

enum TrackerSectionMove { top, up, down }

class DailyTrackerSectionOrderTile extends StatelessWidget {
  const DailyTrackerSectionOrderTile({
    super.key,
    required this.category,
    required this.index,
    required this.sectionCount,
    required this.taskCount,
    required this.onMove,
  });

  final TaskCategory category;
  final int index;
  final int sectionCount;
  final int taskCount;
  final ValueChanged<TrackerSectionMove> onMove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = trackerCategoryColor(context, category);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            children: [
              Icon(category.icon, color: accent, size: 22),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trackerCategoryLabel(context, category),
                      style: AppTheme.text(
                        context,
                      ).bodyMedium.copyWith(fontWeight: AppTheme.weightBold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.dailyTrackerSectionTaskCount(taskCount),
                      style: AppTheme.text(
                        context,
                      ).bodySmall.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<TrackerSectionMove>(
                tooltip: l10n.dailyTrackerSectionOptionsTooltip,
                onSelected: onMove,
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: TrackerSectionMove.top,
                    enabled: index > 0,
                    child: Text(l10n.dailyTrackerMoveSectionTopAction),
                  ),
                  PopupMenuItem(
                    value: TrackerSectionMove.up,
                    enabled: index > 0,
                    child: Text(l10n.dailyTrackerMoveSectionUpAction),
                  ),
                  PopupMenuItem(
                    value: TrackerSectionMove.down,
                    enabled: index < sectionCount - 1,
                    child: Text(l10n.dailyTrackerMoveSectionDownAction),
                  ),
                ],
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Tooltip(
                message: l10n.dailyTrackerReorderSectionTooltip,
                child: ReorderableDragStartListener(
                  index: index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: SizedBox(
                      width: 44,
                      height: 48,
                      child: Icon(Icons.drag_handle_rounded, color: accent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

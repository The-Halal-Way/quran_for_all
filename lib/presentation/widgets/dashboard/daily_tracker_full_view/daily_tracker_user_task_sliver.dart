import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/daily_task_model.dart';
import 'daily_tracker_task_tile.dart';

/// User tasks remain editable and reorderable in every section.
class DailyTrackerUserTaskSliver extends StatelessWidget {
  const DailyTrackerUserTaskSliver({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onMove,
    required this.onReorder,
  });

  final List<DailyTask> tasks;
  final ValueChanged<DailyTask> onToggle;
  final ValueChanged<DailyTask> onDelete;
  final ValueChanged<DailyTask> onMove;
  final ReorderCallback onReorder;

  @override
  Widget build(BuildContext context) => SliverReorderableList(
    itemCount: tasks.length,
    onReorder: onReorder,
    itemBuilder: (context, index) {
      final task = tasks[index];
      return Padding(
        key: ValueKey(task.id),
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: DailyTrackerTaskTile(
          task: task,
          onToggle: () => onToggle(task),
          onDelete: () => onDelete(task),
          onMove: () => onMove(task),
          reorderIndex: index,
        ),
      );
    },
  );
}

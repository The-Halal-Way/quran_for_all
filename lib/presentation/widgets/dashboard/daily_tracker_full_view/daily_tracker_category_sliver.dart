import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/daily_task_model.dart';
import 'daily_tracker_category_header.dart';
import 'daily_tracker_task_tile.dart';

class DailyTrackerCategorySliver extends StatelessWidget {
  const DailyTrackerCategorySliver({
    super.key,
    required this.category,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    this.onReorder,
  });
  final TaskCategory category;
  final List<DailyTask> tasks;
  final ValueChanged<DailyTask> onToggle;
  final ValueChanged<DailyTask> onDelete;
  final ReorderCallback? onReorder;

  @override
  Widget build(BuildContext context) => SliverMainAxisGroup(
    slivers: [
      SliverToBoxAdapter(
        child: DailyTrackerCategoryHeader(
          category: category,
          completed: tasks.where((task) => task.isCompletedToday).length,
          total: tasks.length,
        ),
      ),
      if (onReorder case final reorder?)
        SliverReorderableList(
          itemCount: tasks.length,
          onReorder: reorder,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              key: ValueKey(task.id),
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: DailyTrackerTaskTile(
                task: task,
                onToggle: () => onToggle(task),
                onDelete: () => onDelete(task),
                reorderIndex: index,
              ),
            );
          },
        )
      else
        SliverList.separated(
          itemCount: tasks.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return DailyTrackerTaskTile(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => onToggle(task),
            );
          },
        ),
    ],
  );
}

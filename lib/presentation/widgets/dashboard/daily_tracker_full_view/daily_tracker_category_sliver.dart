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
  });
  final TaskCategory category;
  final List<DailyTask> tasks;
  final ValueChanged<DailyTask> onToggle;
  final ValueChanged<DailyTask> onDelete;

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
      SliverList.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return DailyTrackerTaskTile(
            key: ValueKey(task.id),
            task: task,
            onToggle: () => onToggle(task),
            onDelete: category == TaskCategory.custom
                ? () => onDelete(task)
                : null,
          );
        },
      ),
    ],
  );
}

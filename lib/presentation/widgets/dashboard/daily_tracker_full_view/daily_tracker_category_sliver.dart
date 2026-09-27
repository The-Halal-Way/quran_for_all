import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/daily_task_model.dart';
import 'daily_tracker_category_header.dart';
import 'daily_tracker_task_tile.dart';
import 'daily_tracker_user_task_sliver.dart';

class DailyTrackerCategorySliver extends StatelessWidget {
  const DailyTrackerCategorySliver({
    super.key,
    required this.category,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onMove,
    required this.onReorder,
  });
  final TaskCategory category;
  final List<DailyTask> tasks;
  final ValueChanged<DailyTask> onToggle;
  final ValueChanged<DailyTask> onDelete;
  final ValueChanged<DailyTask> onMove;
  final ReorderCallback onReorder;

  @override
  Widget build(BuildContext context) {
    final builtInTasks = tasks.where((task) => !task.isUserCreated).toList();
    final userTasks = tasks.where((task) => task.isUserCreated).toList();
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: DailyTrackerCategoryHeader(
            category: category,
            completed: tasks.where((task) => task.isCompletedToday).length,
            total: tasks.length,
          ),
        ),
        if (builtInTasks.isNotEmpty)
          SliverList.separated(
            itemCount: builtInTasks.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final task = builtInTasks[index];
              return DailyTrackerTaskTile(
                key: ValueKey(task.id),
                task: task,
                onToggle: () => onToggle(task),
              );
            },
          ),
        if (builtInTasks.isNotEmpty && userTasks.isNotEmpty)
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        if (userTasks.isNotEmpty)
          DailyTrackerUserTaskSliver(
            tasks: userTasks,
            onToggle: onToggle,
            onDelete: onDelete,
            onMove: onMove,
            onReorder: onReorder,
          ),
      ],
    );
  }
}

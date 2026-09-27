import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/daily_task_model.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import 'add_custom_task_sheet.dart';
import 'daily_tracker_category_style.dart';
import 'daily_tracker_move_task_dialog.dart';
import 'daily_tracker_section_actions.dart';

Future<void> addTrackerTask(BuildContext context) async {
  final vm = context.read<DailyTrackerViewModel>();
  final result = await showAddCustomTaskSheet(context);
  if (result == null || !context.mounted) return;
  try {
    await vm.addCustomTask(
      title: result.title,
      subtitle: result.subtitle,
      isOptional: result.isOptional,
      category: result.category,
    );
  } catch (_) {
    if (context.mounted) showTrackerSaveError(context);
  }
}

Future<void> deleteTrackerTask(BuildContext context, DailyTask task) async {
  final vm = context.read<DailyTrackerViewModel>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(context.l10n.dailyTrackerDeleteTaskConfirmTitle),
      content: Text(
        context.l10n.dailyTrackerDeleteTaskConfirmMessage(
          trackerTaskTitle(context, task),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(
            MaterialLocalizations.of(dialogContext).cancelButtonLabel,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          child: Text(context.l10n.dailyTrackerDeleteAction),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  try {
    await vm.deleteCustomTask(task.id);
  } catch (_) {
    if (context.mounted) showTrackerSaveError(context);
  }
}

Future<void> moveTrackerTask(BuildContext context, DailyTask task) async {
  final vm = context.read<DailyTrackerViewModel>();
  final category = await showTrackerMoveTaskDialog(context, task);
  if (category == null || category == task.category || !context.mounted) return;
  try {
    await vm.moveCustomTask(task.id, category);
  } catch (_) {
    if (context.mounted) showTrackerSaveError(context);
  }
}

Future<void> reorderTrackerTasks(
  BuildContext context,
  int oldIndex,
  int newIndex,
  TaskCategory category,
) async {
  try {
    await context.read<DailyTrackerViewModel>().reorderCustomTask(
      oldIndex,
      newIndex,
      category: category,
    );
  } catch (_) {
    if (context.mounted) showTrackerSaveError(context);
  }
}

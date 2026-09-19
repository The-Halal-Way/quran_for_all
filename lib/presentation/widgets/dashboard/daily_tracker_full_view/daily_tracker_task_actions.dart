import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/daily_task_model.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import 'add_custom_task_sheet.dart';
import 'daily_tracker_category_style.dart';

Future<void> addTrackerTask(BuildContext context) async {
  final vm = context.read<DailyTrackerViewModel>();
  final result = await showAddCustomTaskSheet(context);
  if (result == null || !context.mounted) return;
  await vm.addCustomTask(
    title: result.title,
    subtitle: result.subtitle,
    isOptional: result.isOptional,
  );
}

Future<void> deleteTrackerTask(BuildContext context, DailyTask task) async {
  final vm = context.read<DailyTrackerViewModel>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(context.l10n.dailyTrackerDeleteTaskConfirmTitle),
      content: Text(
        context.l10n.dailyTrackerDeleteTaskConfirmMessage(
          trackerTaskTitle(context, task),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(
            MaterialLocalizations.of(dialogContext).cancelButtonLabel,
          ),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(dialogContext, true),
          isDestructiveAction: true,
          child: Text(context.l10n.dailyTrackerDeleteAction),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) await vm.deleteCustomTask(task.id);
}

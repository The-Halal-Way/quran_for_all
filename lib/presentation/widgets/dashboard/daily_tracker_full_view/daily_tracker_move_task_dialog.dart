import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/daily_task_model.dart';
import 'daily_tracker_category_style.dart';
import 'daily_tracker_section_picker.dart';

Future<TaskCategory?> showTrackerMoveTaskDialog(
  BuildContext context,
  DailyTask task,
) => showDialog<TaskCategory>(
  context: context,
  builder: (_) => DailyTrackerMoveTaskDialog(task: task),
);

class DailyTrackerMoveTaskDialog extends StatefulWidget {
  const DailyTrackerMoveTaskDialog({super.key, required this.task});

  final DailyTask task;

  @override
  State<DailyTrackerMoveTaskDialog> createState() =>
      _DailyTrackerMoveTaskDialogState();
}

class _DailyTrackerMoveTaskDialogState
    extends State<DailyTrackerMoveTaskDialog> {
  late TaskCategory _category = widget.task.category;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.dailyTrackerMoveTaskTitle),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(trackerTaskTitle(context, widget.task)),
        const SizedBox(height: AppSpacing.lg),
        DailyTrackerSectionPicker(
          selected: _category,
          onSelected: (category) => setState(() => _category = category),
        ),
      ],
    ),
    scrollable: true,
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _category),
        child: Text(context.l10n.dailyTrackerMoveTaskConfirmAction),
      ),
    ],
  );
}

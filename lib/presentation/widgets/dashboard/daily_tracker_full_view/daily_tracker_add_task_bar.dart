import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import 'daily_tracker_task_actions.dart';

/// A reserved bottom area keeps the add action from covering the last task.
class DailyTrackerAddTaskBar extends StatelessWidget {
  const DailyTrackerAddTaskBar({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    child: Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => addTrackerTask(context),
            icon: const Icon(CupertinoIcons.add),
            label: Text(context.l10n.dailyTrackerAddTaskTooltip),
            style: FilledButton.styleFrom(
              backgroundColor: MyColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

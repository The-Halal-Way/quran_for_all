import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

enum TrackerTaskAction { move, delete }

class DailyTrackerTaskMenu extends StatelessWidget {
  const DailyTrackerTaskMenu({
    super.key,
    required this.onMove,
    required this.onDelete,
  });

  final VoidCallback onMove;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => PopupMenuButton<TrackerTaskAction>(
    tooltip: context.l10n.dailyTrackerTaskOptionsTooltip,
    icon: const Icon(Icons.more_horiz_rounded, size: 22),
    onSelected: (action) {
      switch (action) {
        case TrackerTaskAction.move:
          onMove();
        case TrackerTaskAction.delete:
          onDelete();
      }
    },
    itemBuilder: (_) => [
      PopupMenuItem(
        value: TrackerTaskAction.move,
        child: Text(context.l10n.dailyTrackerMoveTaskAction),
      ),
      PopupMenuItem(
        value: TrackerTaskAction.delete,
        child: Text(
          context.l10n.dailyTrackerDeleteAction,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ],
  );
}

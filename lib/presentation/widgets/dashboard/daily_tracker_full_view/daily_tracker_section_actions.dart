import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import 'daily_tracker_section_order_sheet.dart';

Future<void> organizeTrackerSections(BuildContext context) async {
  final vm = context.read<DailyTrackerViewModel>();
  final order = await showTrackerSectionOrderSheet(
    context,
    order: vm.sectionOrder,
    taskCounts: vm.groupedTasks.map(
      (category, tasks) => MapEntry(category, tasks.length),
    ),
  );
  if (order == null || !context.mounted) return;
  try {
    await vm.setSectionOrder(order);
  } catch (_) {
    if (context.mounted) showTrackerSaveError(context);
  }
}

void showTrackerSaveError(BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.dailyTrackerSaveChangesError)),
    );

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'daily_tracker_section_order_tile.dart';
import 'daily_tracker_section_order_header.dart';
import 'daily_tracker_section_order_footer.dart';

Future<List<TaskCategory>?> showTrackerSectionOrderSheet(
  BuildContext context, {
  required List<TaskCategory> order,
  required Map<TaskCategory, int> taskCounts,
}) => showModalBottomSheet<List<TaskCategory>>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  constraints: const BoxConstraints(maxWidth: 640),
  builder: (_) => FractionallySizedBox(
    heightFactor: 0.88,
    child: DailyTrackerSectionOrderSheet(order: order, taskCounts: taskCounts),
  ),
);

class DailyTrackerSectionOrderSheet extends StatefulWidget {
  const DailyTrackerSectionOrderSheet({
    super.key,
    required this.order,
    required this.taskCounts,
  });

  final List<TaskCategory> order;
  final Map<TaskCategory, int> taskCounts;

  @override
  State<DailyTrackerSectionOrderSheet> createState() =>
      _DailyTrackerSectionOrderSheetState();
}

class _DailyTrackerSectionOrderSheetState
    extends State<DailyTrackerSectionOrderSheet> {
  late final List<TaskCategory> _order = List.of(widget.order);

  void _move(int index, int target) => setState(() {
    final category = _order.removeAt(index);
    _order.insert(target.clamp(0, _order.length), category);
  });

  void _reorder(int oldIndex, int newIndex) =>
      _move(oldIndex, oldIndex < newIndex ? newIndex - 1 : newIndex);

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DailyTrackerSectionOrderHeader(
                    onReset: listEquals(_order, TaskCategory.values)
                        ? null
                        : () => setState(() {
                            _order
                              ..clear()
                              ..addAll(TaskCategory.values);
                          }),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  sliver: SliverReorderableList(
                    itemCount: _order.length,
                    onReorder: _reorder,
                    itemBuilder: (context, index) =>
                        DailyTrackerSectionOrderTile(
                          key: ValueKey(_order[index]),
                          category: _order[index],
                          index: index,
                          sectionCount: _order.length,
                          taskCount: widget.taskCounts[_order[index]] ?? 0,
                          onMove: (move) => _move(index, switch (move) {
                            TrackerSectionMove.top => 0,
                            TrackerSectionMove.up => index - 1,
                            TrackerSectionMove.down => index + 1,
                          }),
                        ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    context.l10n.dailyTrackerEmptySectionsHint,
                    style: AppTheme.text(context).bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DailyTrackerSectionOrderFooter(
            onCancel: () => Navigator.pop(context),
            onSave: () => Navigator.pop(context, List<TaskCategory>.of(_order)),
          ),
        ],
      ),
    ),
  );
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../common/app_page_scrollbar.dart';
import 'daily_tracker_category_sliver.dart';
import 'daily_tracker_hero.dart';
import 'daily_tracker_task_actions.dart';
import 'daily_tracker_friday_banner.dart';

class DailyTrackerChecklist extends StatelessWidget {
  const DailyTrackerChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = context.select(
      (DailyTrackerViewModel vm) => vm.groupedTasks,
    );
    final loading = context.select((DailyTrackerViewModel vm) => vm.isLoading);
    final vm = context.read<DailyTrackerViewModel>();
    if (loading && grouped.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = math.max(
          AppResponsive.of(context).padding,
          (constraints.maxWidth - 800) / 2,
        );
        return AppPageScrollbar(
          builder: (context, controller) => RefreshIndicator(
            onRefresh: vm.loadTasks,
            child: CustomScrollView(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    padding,
                    AppSpacing.sm,
                    padding,
                    AppSpacing.xxl,
                  ),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: DailyTrackerHero(
                          completed: vm.completedTasks,
                          total: vm.totalTasks,
                        ),
                      ),
                      if (vm.isFriday)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: AppSpacing.lg),
                            child: DailyTrackerFridayBanner(),
                          ),
                        ),
                      if (grouped.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Text(
                              context.l10n.dailyTrackerEmptyMessage,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      for (final entry in grouped.entries)
                        DailyTrackerCategorySliver(
                          key: ValueKey(entry.key),
                          category: entry.key,
                          tasks: entry.value,
                          onToggle: (task) => vm.toggleTask(task.id),
                          onDelete: (task) => deleteTrackerTask(context, task),
                          onReorder: entry.key == TaskCategory.custom
                              ? vm.reorderCustomTask
                              : null,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

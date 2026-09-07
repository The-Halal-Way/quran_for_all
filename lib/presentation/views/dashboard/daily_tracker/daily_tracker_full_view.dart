import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/task_category.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/daily_task_model.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/dashboard/daily_tracker/add_custom_task_sheet.dart';
import '../../../widgets/dashboard/daily_tracker/category_header_widget.dart';
import '../../../widgets/dashboard/daily_tracker/completion_celebration_widget.dart';
import '../../../widgets/dashboard/daily_tracker/friday_banner_widget.dart';
import '../../../widgets/dashboard/daily_tracker/task_tile_widget.dart';

/// Full scrollable Daily Tracker checklist, grouped by category, with the
/// Friday banner and completion celebration overlay.
class DailyTrackerFullView extends StatelessWidget {
  const DailyTrackerFullView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyTrackerViewModel>();
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? MyColors.darkCardFill : MyColors.cardFill;
    final textMain = isDark
        ? MyColors.darkTextPrimary
        : MyColors.textPrimary;
    final textHint = isDark
        ? MyColors.darkTextTertiary
        : MyColors.textTertiary;
    final divider = isDark ? MyColors.darkDivider : MyColors.divider;
    final grouped = vm.groupedTasks;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.dailyTrackerFullViewTitle)),
      body: Stack(
        children: [
          if (vm.isLoading)
            const Center(
              child: CircularProgressIndicator(color: MyColors.secondary),
            )
          else
            AppPageScrollbar(
              builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  responsive.padding,
                  AppSpacing.lg,
                  responsive.padding,
                  AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vm.isFriday) const FridayBannerWidget(),
                    for (final category in grouped.keys) ...[
                      CategoryHeaderWidget(
                        category: category,
                        textMain: textMain,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final task in grouped[category]!)
                        TaskTileWidget(
                          task: task,
                          onToggle: (_) => vm.toggleTask(task.id),
                          cardBg: cardBg,
                          textMain: textMain,
                          textHint: textHint,
                          divider: divider,
                          onDelete: task.category == TaskCategory.custom
                              ? () => _confirmDeleteTask(context, vm, task)
                              : null,
                        ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ),
          if (vm.showCelebration)
            CompletionCelebrationWidget(onDismiss: vm.dismissCelebration),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyColors.secondary,
        foregroundColor: Colors.white,
        onPressed: () => _addCustomTask(context, vm),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.dailyTrackerAddTaskTooltip),
      ),
    );
  }

  Future<void> _addCustomTask(
    BuildContext context,
    DailyTrackerViewModel vm,
  ) async {
    final result = await showAddCustomTaskSheet(context);
    if (result == null) {
      return;
    }
    await vm.addCustomTask(
      title: result.title,
      subtitle: result.subtitle,
      isOptional: result.isOptional,
    );
  }

  Future<void> _confirmDeleteTask(
    BuildContext context,
    DailyTrackerViewModel vm,
    DailyTask task,
  ) async {
    final text = AppTheme.text(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.dailyTrackerDeleteTaskConfirmTitle),
        content: Text(
          context.l10n.dailyTrackerDeleteTaskConfirmMessage(task.titleEn),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              context.l10n.dailyTrackerDeleteAction,
              style: text.bodyMedium.copyWith(color: MyColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await vm.deleteCustomTask(task.id);
    }
  }
}

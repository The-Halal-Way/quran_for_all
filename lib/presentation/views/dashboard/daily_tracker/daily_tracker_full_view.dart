import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/daily_tracker_full_view/daily_tracker_add_task_bar.dart';
import '../../../widgets/dashboard/daily_tracker_full_view/daily_tracker_celebration.dart';
import '../../../widgets/dashboard/daily_tracker_full_view/daily_tracker_checklist.dart';

class DailyTrackerFullView extends StatelessWidget {
  const DailyTrackerFullView({super.key});

  @override
  Widget build(BuildContext context) {
    final celebration = context.select(
      (DailyTrackerViewModel vm) => vm.showCelebration,
    );
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(context.l10n.dailyTrackerFullViewTitle)),
          body: const AppPremiumPageBackground(child: DailyTrackerChecklist()),
          bottomNavigationBar: const DailyTrackerAddTaskBar(),
        ),
        if (celebration)
          Positioned.fill(
            child: DailyTrackerCelebration(
              onDismiss: context
                  .read<DailyTrackerViewModel>()
                  .dismissCelebration,
            ),
          ),
      ],
    );
  }
}

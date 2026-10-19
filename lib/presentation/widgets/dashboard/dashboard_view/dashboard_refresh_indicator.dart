import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';

class DashboardRefreshIndicator extends StatelessWidget {
  const DashboardRefreshIndicator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    color: Theme.of(context).brightness == Brightness.dark
        ? MyColors.secondary
        : AppThemeColors.light.brand,
    onRefresh: () => _refresh(context),
    child: child,
  );

  Future<void> _refresh(BuildContext context) async {
    final prayer = context.read<DashboardPrayerTimesViewModel>();
    final tracker = context.read<DailyTrackerViewModel>();
    final hadith = context.read<DailyHadithViewModel>();
    final islamicDays = context.read<IslamicDaysViewModel>();

    try {
      await Future.wait<void>([
        prayer.loadPrayerTimes(forceRefresh: true),
        if (!tracker.isLoading) tracker.loadTasks(),
        if (hadith.pack != null && !hadith.isLoading)
          hadith.refreshAvailability(reschedule: true),
        if (islamicDays.ready && !islamicDays.isLoading)
          islamicDays.refresh(force: true),
      ]);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.dashboardRefreshError)),
      );
    }
  }
}

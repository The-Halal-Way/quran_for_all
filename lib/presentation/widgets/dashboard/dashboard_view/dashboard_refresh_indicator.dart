import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import '../../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';

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
    final settings = context.read<SettingsViewModel>().settings;
    final locale = context.l10n.localeName;

    try {
      await Future.wait<void>([
        prayer.loadPrayerTimes(forceRefresh: true),
        if (!tracker.isLoading) tracker.loadTasks(),
        if (!hadith.isLoading)
          hadith.pack == null || hadith.error != null
              ? hadith.initialize(locale)
              : hadith.refreshAvailability(reschedule: true),
        islamicDays.ready && !islamicDays.isLoading && islamicDays.error == null
            ? islamicDays.refresh(force: true)
            : islamicDays.initialize(locale, settings.hijriDateAdjustment),
      ]);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.dashboardRefreshError)),
      );
    }
  }
}

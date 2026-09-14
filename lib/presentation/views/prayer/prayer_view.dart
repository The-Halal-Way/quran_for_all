import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../viewmodels/prayer/prayer_viewmodel.dart';
import '../../widgets/prayer/prayer_view/prayer_view_body.dart';

class PrayerView extends StatelessWidget {
  const PrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<
      DashboardPrayerTimesViewModel,
      PrayerViewModel
    >(
      create: (_) => PrayerViewModel(),
      update: (_, times, viewModel) => viewModel!
        ..sync(
          prayerTimes: times.prayerTimes,
          prayerTimeRanges: times.prayerTimeRanges,
          currentPrayerKey: times.currentPrayer,
        ),
      child: const PrayerViewBody(),
    );
  }
}

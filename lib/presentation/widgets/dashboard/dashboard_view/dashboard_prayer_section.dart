import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../../viewmodels/prayer/prayer_viewmodel.dart';
import '../../../views/prayer/forbidden_times/forbidden_times_view.dart';
import 'dashboard_prayer_card.dart';
import 'dashboard_prayer_error.dart';
import 'dashboard_section_title.dart';

class DashboardPrayerSection extends StatelessWidget {
  const DashboardPrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardPrayerTimesViewModel>();
    final (title, message) = dashboardPrayerError(context.l10n, vm.errorType);
    final times = vm.prayerTimes ?? const <String, String>{};
    final forbiddenTimes = PrayerViewModel.forbiddenTimesFor(
      context.l10n,
      times,
    );
    return Column(
      children: [
        DashboardSectionTitle(
          title: context.l10n.dashboardSectionPrayerTimes,
          icon: Icons.access_time_rounded,
          accent: MyColors.secondary,
        ),
        const SizedBox(height: AppSpacing.md),
        DashboardPrayerCard(
          times: times,
          ranges: vm.prayerTimeRanges ?? const {},
          forbiddenTimes: forbiddenTimes,
          current: vm.currentPrayer,
          loading: vm.isLoading,
          errorTitle: vm.error.isEmpty ? null : title,
          errorMessage: vm.error.isEmpty ? null : message,
          onRetry: () => vm.loadPrayerTimes(forceRefresh: true),
          onForbiddenTimesTap: () => Navigator.of(context).push(
            AppPageRoute<void>(
              builder: (_) => ForbiddenTimesView(items: forbiddenTimes),
            ),
          ),
        ),
      ],
    );
  }
}

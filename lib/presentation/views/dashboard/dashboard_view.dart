import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/my_colors.dart';
import '../../../core/utils/app_responsive.dart';
import '../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../widgets/common/app_icon_grid_section.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_continue_section.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_hadith_section.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_prayer_section.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_shortcut_catalog.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_tracker_preview.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: MyColors.secondary,
            onRefresh: () => context
                .read<DashboardPrayerTimesViewModel>()
                .loadPrayerTimes(forceRefresh: true),
            child: AppPageScrollbar(
              builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  responsive.padding,
                  AppSpacing.lg,
                  responsive.padding,
                  AppSpacing.xxxl,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 940),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DashboardHeader(),
                        const SizedBox(height: AppSpacing.lg),
                        const DashboardContinueSection(),
                        const SizedBox(height: AppSpacing.lg),
                        const DashboardTrackerPreview(),
                        const SizedBox(height: AppSpacing.xxl),
                        const DashboardPrayerSection(),
                        const SizedBox(height: AppSpacing.xxl),
                        AppIconGridSection(
                          title: context.l10n.dashboardSectionExplore,
                          items: dashboardActions(context),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        const DashboardHadithSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

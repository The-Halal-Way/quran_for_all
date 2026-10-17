import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../common/app_icon_grid_section.dart';
import '../books/dashboard_books_section.dart';
import '../hadith_integrity/dashboard_hadith_integrity_section.dart';
import '../mercy/dashboard_mercy_section.dart';
import '../when_you_have_a_need/dashboard_need_section.dart';
import 'dashboard_hadith_section.dart';
import 'dashboard_date_context.dart';
import 'dashboard_prayer_section.dart';
import 'dashboard_shortcut_catalog.dart';
import 'dashboard_tracker_preview.dart';

/// Keeps the day's prayer and worship context ahead of the wider library.
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = AppResponsive.of(context).padding;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        padding,
        AppSpacing.lg,
        padding,
        AppSpacing.xxxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 940),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardDateContext(),
              const SizedBox(height: AppSpacing.lg),
              const DashboardPrayerSection(),
              const SizedBox(height: AppSpacing.md),
              const DashboardTrackerPreview(),
              const SizedBox(height: AppSpacing.lg),
              AppIconGridSection(
                title: context.l10n.dashboardSectionExplore,
                items: dashboardActions(context),
              ),
              const SizedBox(height: AppSpacing.md),
              const DashboardBooksSection(),
              const SizedBox(height: AppSpacing.md),
              const DashboardMercySection(),
              const SizedBox(height: AppSpacing.lg),
              const DashboardNeedSection(),
              const SizedBox(height: AppSpacing.lg),
              const DashboardHadithSection(),
              const SizedBox(height: AppSpacing.lg),
              const DashboardHadithIntegritySection(),
            ],
          ),
        ),
      ),
    );
  }
}

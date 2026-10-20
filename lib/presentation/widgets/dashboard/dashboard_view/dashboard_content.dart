import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../common/app_icon_grid_section.dart';
import '../books/dashboard_books_section.dart';
import '../hadith_integrity/dashboard_hadith_integrity_section.dart';
import '../kids_books/dashboard_kids_books_section.dart';
import '../mercy/dashboard_mercy_section.dart';
import '../when_you_have_a_need/dashboard_need_section.dart';
import 'dashboard_hadith_section.dart';
import 'dashboard_feed_section.dart';
import 'dashboard_date_context.dart';
import 'dashboard_prayer_section.dart';
import 'dashboard_shortcut_catalog.dart';
import 'dashboard_tracker_preview.dart';

/// Builds sections lazily and retains them for smooth return scrolling.
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, this.controller});

  final ScrollController? controller;

  static const _gaps = [
    AppSpacing.lg,
    AppSpacing.md,
    AppSpacing.lg,
    AppSpacing.md,
    AppSpacing.md,
    AppSpacing.md,
    AppSpacing.lg,
    AppSpacing.lg,
    AppSpacing.lg,
    0.0,
  ];

  @override
  Widget build(BuildContext context) {
    final padding = AppResponsive.of(context).padding;
    return ListView.builder(
      key: const PageStorageKey('dashboard-feed'),
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        padding,
        AppSpacing.lg,
        padding,
        AppSpacing.xxxl,
      ),
      itemCount: _gaps.length,
      itemBuilder: (context, index) => DashboardFeedSection(
        key: ValueKey('dashboard-section-$index'),
        gap: _gaps[index],
        child: switch (index) {
          0 => const DashboardDateContext(),
          1 => const DashboardPrayerSection(),
          2 => const DashboardTrackerPreview(),
          3 => AppIconGridSection(
            title: context.l10n.dashboardSectionExplore,
            items: dashboardActions(context),
          ),
          4 => const DashboardBooksSection(),
          5 => const DashboardKidsBooksSection(),
          6 => const DashboardMercySection(),
          7 => const DashboardNeedSection(),
          8 => const DashboardHadithSection(),
          _ => const DashboardHadithIntegritySection(),
        },
      ),
    );
  }
}

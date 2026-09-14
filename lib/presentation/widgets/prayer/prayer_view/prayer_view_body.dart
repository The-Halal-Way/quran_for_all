import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import '../../../viewmodels/prayer/prayer_viewmodel.dart';
import '../../common/app_page_scrollbar.dart';
import '../../common/app_premium_page_background.dart';
import 'prayer_focus_hero.dart';
import 'prayer_guidance_launcher.dart';
import 'prayer_rakat_guide_card.dart';
import 'prayer_reference_section.dart';
import 'prayer_section_heading.dart';
import 'prayer_sehri_window_card.dart';
import 'prayer_times_status.dart';
import 'prayer_timeline_grid.dart';

class PrayerViewBody extends StatelessWidget {
  const PrayerViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PrayerViewModel>();
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
    final content = model.focusContent(l10n);
    final sehriRange = model.prayerTimeRanges['Sehri'];
    final sehriEnd = model.prayerTimes['Sehri'];

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
                  AppSpacing.huge,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.maxReadingContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //const PrayerPageHeader(),
                        //const SizedBox(height: AppSpacing.xl),
                        const PrayerTimesStatus(),
                        PrayerFocusHero(
                          content: content,
                          time: model.focusTime(l10n),
                          hasTimes: model.hasTimes,
                        ),
                        if (sehriRange != null && sehriEnd != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          PrayerSehriWindowCard(
                            timeRange: sehriRange,
                            lastTime: sehriEnd,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xxxl),
                        PrayerSectionHeading(
                          title: l10n.prayerViewTimelineTitle,
                          icon: Icons.schedule_rounded,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrayerTimelineGrid(items: model.timeline(l10n)),
                        const SizedBox(height: AppSpacing.lg),
                        PrayerRakatGuideCard(
                          items: model.rakatPlans(l10n),
                          focusPrayer: model.focusPrayer,
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        const PrayerReferenceSection(),
                        const SizedBox(height: AppSpacing.xxxl),
                        PrayerSectionHeading(
                          title: l10n.prayerViewNowTitle,
                          icon: Icons.auto_awesome_rounded,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        PrayerGuidanceLauncher(content: content),
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

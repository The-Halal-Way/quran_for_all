import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_page_route.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/prayer_viewmodel.dart';
import 'package:quran_for_all/presentation/views/prayer/janaza_prayer/janaza_prayer_view.dart';
import 'package:quran_for_all/presentation/views/prayer/salatul_tasbeeh/salatul_tasbeeh_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/common/app_premium_page_background.dart';
import 'package:quran_for_all/presentation/widgets/common/app_premium_section_title.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_guidance_sections.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_rakat_guide_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_focus_hero.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_guidance_launcher.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_reference_carousel.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_sehri_window_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_timeline_carousel.dart';
import 'package:quran_for_all/presentation/views/prayer/forbidden_times/forbidden_times_view.dart';
import 'package:quran_for_all/presentation/views/prayer/how_to_pray/how_to_pray_view.dart';
import 'package:quran_for_all/presentation/views/prayer/nafal_prayers/nafal_prayers_view.dart';

// MARK: Prayer - Root View
class PrayerView extends StatefulWidget {
  const PrayerView({super.key});
  @override
  State<PrayerView> createState() => _PrayerViewState();
}

// MARK: Prayer - Initial Prayer Times Load
class _PrayerViewState extends State<PrayerView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerViewModel(),
      child: _PrayerViewBody(),
    );
  }
}

// MARK: Prayer - Main Scroll Body
class _PrayerViewBody extends StatelessWidget {
  const _PrayerViewBody();
  Future<void> _refresh(BuildContext context) {
    return context.read<DashboardPrayerTimesViewModel>().loadPrayerTimes(
      forceRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayerTimesVm = context.watch<DashboardPrayerTimesViewModel>();
    final viewModel = context.read<PrayerViewModel>();
    viewModel.sync(
      prayerTimes: prayerTimesVm.prayerTimes,
      prayerTimeRanges: prayerTimesVm.prayerTimeRanges,
      currentPrayerKey: prayerTimesVm.currentPrayer,
      notify: false,
    );

    final l10n = context.l10n;
    final content = viewModel.focusContent(l10n);
    final timeline = viewModel.timeline(l10n);
    final rakatPlans = viewModel.rakatPlans(l10n);
    final forbiddenTimes = viewModel.forbiddenTimes(l10n);
    final nafalPrayers = viewModel.nafalPrayers(l10n);
    final responsive = AppResponsive.of(context);
    return Scaffold(
      body: SafeArea(
        child: AppPremiumPageBackground(
          child: Stack(
            children: [
              RefreshIndicator(
                color: MyColors.secondary,
                onRefresh: () => _refresh(context),
                child: AppPageScrollbar(
                  builder: (context, controller) => CustomScrollView(
                    controller: controller,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: responsive.maxReadingContentWidth,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                responsive.padding,
                                AppSpacing.md,
                                responsive.padding,
                                AppSpacing.huge,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // MARK: Prayer - Loading State
                                  if (prayerTimesVm.isLoading &&
                                      !prayerTimesVm.hasData) ...[
                                    const PrayerStateCard.loading(),
                                    const SizedBox(height: AppSpacing.lg),
                                  ],
                                  // MARK: Prayer - Error State
                                  if (prayerTimesVm.error.isNotEmpty &&
                                      !prayerTimesVm.isLoading) ...[
                                    PrayerStateCard.error(
                                      title: _errorTitle(
                                        context,
                                        prayerTimesVm.errorType,
                                      ),
                                      body: _errorBody(
                                        context,
                                        prayerTimesVm.errorType,
                                      ),
                                      onRetry: () =>
                                          unawaited(_refresh(context)),
                                    ),
                                    const SizedBox(height: AppSpacing.lg),
                                  ],
                                  // MARK: Prayer - Focus Hero
                                  PrayerFocusHero(
                                    content: content,
                                    time: viewModel.focusTime(l10n),
                                    hasTimes: prayerTimesVm.hasData,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  // MARK: Prayer - Sehri Window
                                  if (viewModel.prayerTimeRanges['Sehri'] !=
                                          null &&
                                      viewModel.prayerTimes['Sehri'] != null)
                                    PrayerSehriWindowCard(
                                      timeRange:
                                          viewModel.prayerTimeRanges['Sehri']!,
                                      lastTime: viewModel.prayerTimes['Sehri']!,
                                    ),
                                  const SizedBox(height: AppSpacing.xxl),
                                  AppPremiumSectionTitle(
                                    title: l10n.prayerViewTimelineTitle,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  PrayerTimelineCarousel(items: timeline),
                                  const SizedBox(height: AppSpacing.xxl),
                                  // MARK: Prayer - Rakat Guide
                                  PrayerRakatGuideCard(
                                    items: rakatPlans,
                                    focusPrayer: viewModel.focusPrayer,
                                  ),
                                  const SizedBox(height: AppSpacing.xxl),
                                  // MARK: Prayer - Reference Navigation
                                  AppPremiumSectionTitle(
                                    title: l10n.prayerReferenceTitle,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  // Keep deeper explanations as navigation tiles
                                  // so the Prayer tab remains scan-first.
                                  PrayerReferenceCarousel(
                                    onMovementGuideTap: () =>
                                        Navigator.of(context).push(
                                          AppPageRoute<void>(
                                            builder: (_) =>
                                                const HowToPrayView(),
                                          ),
                                        ),
                                    onForbiddenTimesTap: () =>
                                        Navigator.of(context).push(
                                          AppPageRoute<void>(
                                            builder: (_) => ForbiddenTimesView(
                                              items: forbiddenTimes,
                                            ),
                                          ),
                                        ),
                                    onNafalPrayersTap: () =>
                                        Navigator.of(context).push(
                                          AppPageRoute<void>(
                                            builder: (_) => NafalPrayersView(
                                              items: nafalPrayers,
                                            ),
                                          ),
                                        ),
                                    onJanazaPrayerTap: () =>
                                        Navigator.of(context).push(
                                          AppPageRoute<void>(
                                            builder: (_) =>
                                                const JanazaPrayerView(),
                                          ),
                                        ),
                                    onSalatulTasbeehTap: () =>
                                        Navigator.of(context).push(
                                          AppPageRoute<void>(
                                            builder: (_) =>
                                                const SalatulTasbeehView(),
                                          ),
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.xxl),
                                  AppPremiumSectionTitle(
                                    title: l10n.prayerViewNowTitle,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  PrayerGuidanceLauncher(content: content),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: Prayer - Error Copy
  String _errorTitle(BuildContext context, PrayerTimesErrorType type) {
    final l10n = context.l10n;
    return switch (type) {
      PrayerTimesErrorType.permissionDenied =>
        l10n.prayerTimesPermissionDeniedTitle,
      PrayerTimesErrorType.permissionDeniedForever =>
        l10n.prayerTimesPermissionDeniedForeverTitle,
      PrayerTimesErrorType.locationDisabled =>
        l10n.prayerTimesLocationDisabledTitle,
      PrayerTimesErrorType.unavailable => l10n.prayerTimesNetworkErrorTitle,
      PrayerTimesErrorType.none => l10n.prayerTimesNetworkErrorTitle,
    };
  }

  // MARK: Prayer - Error Body Copy
  String _errorBody(BuildContext context, PrayerTimesErrorType type) {
    final l10n = context.l10n;
    return switch (type) {
      PrayerTimesErrorType.permissionDenied =>
        l10n.prayerTimesPermissionDeniedBody,
      PrayerTimesErrorType.permissionDeniedForever =>
        l10n.prayerTimesPermissionDeniedForeverBody,
      PrayerTimesErrorType.locationDisabled =>
        l10n.prayerTimesLocationDisabledBody,
      PrayerTimesErrorType.unavailable => l10n.prayerTimesNetworkErrorBody,
      PrayerTimesErrorType.none => l10n.prayerTimesNetworkErrorBody,
    };
  }
}

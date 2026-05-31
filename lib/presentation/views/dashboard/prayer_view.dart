import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_page_route.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/prayer_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer/janaza_prayer_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer/salatul_tasbeeh_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_focus_hero.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_guidance_sections.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_reference_actions.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_rakat_guide_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_timeline_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer/forbidden_times_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer/how_to_pray_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer/nafal_prayers_view.dart';

// MARK: Prayer - Root View
class PrayerView extends StatefulWidget {
  const PrayerView({super.key});
  @override
  State<PrayerView> createState() => _PrayerViewState();
}

// MARK: Prayer - Initial Prayer Times Load
class _PrayerViewState extends State<PrayerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<DashboardPrayerTimesViewModel>();
      if (!vm.hasData && !vm.isLoading) {
        unawaited(vm.loadPrayerTimes());
      }
    });
  }

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
      nextPrayerKey: prayerTimesVm.nextPrayer,
      notify: false,
    );

    final l10n = context.l10n;
    final content = viewModel.focusContent(l10n);
    final timeline = viewModel.timeline(l10n);
    final rakatPlans = viewModel.rakatPlans(l10n);
    final forbiddenTimes = viewModel.forbiddenTimes(l10n);
    final nafalPrayers = viewModel.nafalPrayers(l10n);
    final accent = PrayerVisuals.accentFor(content.prayer);
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // MARK: Prayer - Page Background
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppGradients.darkPageBg
                      : AppGradients.pageBg,
                ),
              ),
            ),
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
                                    onRetry: () => unawaited(_refresh(context)),
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
                                // MARK: Prayer - Daily Timeline
                                PrayerTimelineCard(items: timeline),
                                const SizedBox(height: AppSpacing.md),
                                // MARK: Prayer - Rakat Guide
                                PrayerRakatGuideCard(
                                  items: rakatPlans,
                                  focusPrayer: viewModel.focusPrayer,
                                ),
                                // MARK: Prayer - Reference Navigation
                                PrayerSectionHeader(
                                  title: l10n.prayerReferenceTitle,
                                  subtitle: l10n.prayerReferenceSubtitle,
                                  icon: Icons.library_books_rounded,
                                  accent: MyColors.tertiary,
                                ),
                                // Keep deeper explanations as navigation tiles
                                // so the Prayer tab remains scan-first.
                                PrayerReferenceActions(
                                  onMovementGuideTap: () =>
                                      Navigator.of(context).push(
                                        AppPageRoute<void>(
                                          builder: (_) => const HowToPrayView(),
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
                                // MARK: Prayer - Current Guidance
                                PrayerSectionHeader(
                                  title: l10n.prayerViewNowTitle,
                                  subtitle: l10n.prayerViewNowSubtitle,
                                  icon: Icons.route_rounded,
                                  accent: MyColors.tertiary,
                                ),
                                PrayerNowCard(content: content),
                                // MARK: Prayer - Suggestions
                                PrayerSectionHeader(
                                  title: l10n.prayerViewSuggestionsTitle,
                                  subtitle: l10n.prayerViewSuggestionsSubtitle,
                                  icon: Icons.auto_awesome_rounded,
                                  accent: MyColors.secondary,
                                ),
                                PrayerSuggestionsSection(
                                  items: content.suggestions,
                                  accent: MyColors.secondary,
                                ),
                                // MARK: Prayer - Best Practices
                                PrayerSectionHeader(
                                  title: l10n.prayerViewBestPracticesTitle,
                                  subtitle:
                                      l10n.prayerViewBestPracticesSubtitle,
                                  icon: Icons.verified_rounded,
                                  accent: accent,
                                ),
                                BestPracticesSection(
                                  items: content.bestPractices,
                                  accent: accent,
                                ),
                                // MARK: Prayer - Fiqh Note
                                const PrayerFiqhNote(),
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

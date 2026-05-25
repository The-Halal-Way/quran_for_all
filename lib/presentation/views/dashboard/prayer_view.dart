import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/prayer_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_details_app_bar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_focus_hero.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_guidance_sections.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_timeline_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';

class PrayerView extends StatefulWidget {
  const PrayerView({super.key});
  @override
  State<PrayerView> createState() => _PrayerViewState();
}

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
      child: const _PrayerViewBody(),
    );
  }
}

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
    final howToPray = viewModel.howToPraySteps(l10n);
    final accent = PrayerVisuals.accentFor(content.prayer);
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
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
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                PrayerDetailsAppBar(
                  isDark: isDark,
                  onRefresh: () => unawaited(_refresh(context)),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive.maxReadingContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          responsive.padding,
                          AppSpacing.lg,
                          responsive.padding,
                          AppSpacing.huge,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (prayerTimesVm.isLoading &&
                                !prayerTimesVm.hasData) ...[
                              const PrayerStateCard.loading(),
                              const SizedBox(height: AppSpacing.lg),
                            ],
                            if (prayerTimesVm.error.isNotEmpty &&
                                !prayerTimesVm.isLoading) ...[
                              PrayerStateCard.error(
                                title: l10n.prayerViewPermissionHelpTitle,
                                body: l10n.prayerViewPermissionHelpBody,
                                onRetry: () => unawaited(_refresh(context)),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                            ],
                            PrayerFocusHero(
                              content: content,
                              time: viewModel.focusTime(l10n),
                              hasTimes: prayerTimesVm.hasData,
                            ),
                            PrayerSectionHeader(
                              title: l10n.prayerViewTimelineTitle,
                              subtitle: l10n.prayerViewTimelineSubtitle,
                              icon: Icons.view_timeline_rounded,
                              accent: accent,
                            ),
                            PrayerTimelineCard(items: timeline),
                            PrayerSectionHeader(
                              title: l10n.prayerViewNowTitle,
                              subtitle: l10n.prayerViewNowSubtitle,
                              icon: Icons.route_rounded,
                              accent: MyColors.tertiary,
                            ),
                            PrayerNowCard(content: content),
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
                            PrayerSectionHeader(
                              title: l10n.prayerViewHowTitle,
                              subtitle: l10n.prayerViewHowSubtitle,
                              icon: Icons.self_improvement_rounded,
                              accent: MyColors.primaryLight,
                            ),
                            HowToPraySection(steps: howToPray),
                            PrayerSectionHeader(
                              title: l10n.prayerViewBestPracticesTitle,
                              subtitle: l10n.prayerViewBestPracticesSubtitle,
                              icon: Icons.verified_rounded,
                              accent: accent,
                            ),
                            BestPracticesSection(
                              items: content.bestPractices,
                              accent: accent,
                            ),
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
        ],
      ),
    );
  }
}

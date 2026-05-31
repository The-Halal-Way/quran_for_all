import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/utils/app_page_route.dart';
import 'package:quran_for_all/data/models/dashboard/dashboard_action_item.dart';
import 'package:quran_for_all/data/models/learn_quran_content.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/dashboard_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/learn_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/compass/compass_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/daily_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/duah_ninty_nine_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_an_nawawi_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_forty_short_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/powerful_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/tasbeeh_view.dart';
import 'package:quran_for_all/presentation/views/learn_quran/learning_module_detail_view.dart';
import 'package:quran_for_all/presentation/views/read_quran/read_quran_view.dart';
import 'package:quran_for_all/presentation/views/read_quran/surah_details_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';

part '../../widgets/dashboard/dashboard/dashboard_view_sections.dart';
part '../../widgets/dashboard/dashboard/action_tile.dart';
part '../../widgets/dashboard/dashboard/bg_painter.dart';
part '../../widgets/dashboard/dashboard/continue_card.dart';
part '../../widgets/dashboard/dashboard/hadith_nav_card.dart';
part '../../widgets/dashboard/dashboard/prayer_row.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  static const double _dashboardTabletMaxWidth = 880;
  static const double _dashboardDesktopMaxWidth = 940;
  final DashboardViewModel _dashboardViewModel = DashboardViewModel();
  bool _isPrayerCardExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerVm = context.read<DashboardPrayerTimesViewModel>();
      if (!prayerVm.hasData && !prayerVm.isLoading) {
        unawaited(prayerVm.loadPrayerTimes());
      }
    });
  }

  Map<String, String>? get _prayerTimes =>
      context.watch<DashboardPrayerTimesViewModel>().prayerTimes;
  Map<String, String>? get _prayerTimeRanges =>
      context.watch<DashboardPrayerTimesViewModel>().prayerTimeRanges;
  String get _prayerError =>
      context.watch<DashboardPrayerTimesViewModel>().error;
  PrayerTimesErrorType get _prayerErrorType =>
      context.watch<DashboardPrayerTimesViewModel>().errorType;
  bool get _loadingPrayerTimes =>
      context.watch<DashboardPrayerTimesViewModel>().isLoading;
  String? get _nextPrayer =>
      context.watch<DashboardPrayerTimesViewModel>().nextPrayer;

  Future<void> _loadPrayerTimes() => context
      .read<DashboardPrayerTimesViewModel>()
      .loadPrayerTimes(forceRefresh: true);

  Future<void> _refreshDashboard() async {
    await _loadPrayerTimes();
  }

  void _togglePrayerCardExpanded() {
    setState(() {
      _isPrayerCardExpanded = !_isPrayerCardExpanded;
    });
  }

  String _prayerErrorTitle(PrayerTimesErrorType type) {
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

  String _prayerErrorBody(PrayerTimesErrorType type) {
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

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  DashboardPalette get _palette => _dashboardViewModel.palette(isDark: _isDark);

  Color get _cardBg => _palette.cardBg;
  Color get _textMain => _palette.textMain;
  Color get _textSub => _palette.textSub;
  Color get _textHint => _palette.textHint;
  Color get _divider => _palette.divider;

  void _push(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Future<void> _openSurah(
    BuildContext context,
    SurahModel surah, {
    int? initialAyahNumber,
  }) async {
    unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));
    await Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SurahDetailsView(
          surah: surah,
          initialAyahNumber: initialAyahNumber,
        ),
      ),
    );
    if (!context.mounted) {
      return;
    }
    await context.read<ReadQuranViewModel>().load(showLoading: false);
  }

  void _openNextLesson(BuildContext context, LearnQuranViewModel viewModel) {
    final lesson = viewModel.nextLesson;
    if (lesson == null) {
      if (viewModel.modules.isNotEmpty) {
        _openModule(context, viewModel.modules.first);
      }
      return;
    }
    final module = viewModel.moduleForLesson(lesson.id);
    if (module == null) {
      return;
    }
    _openModule(context, module);
  }

  void _openModule(BuildContext context, LearnQuranModule module) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => LearningModuleDetailView(module: module),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Subtle background tiling
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: BgPainter(isDark: _isDark)),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              color: MyColors.secondary,
              onRefresh: _refreshDashboard,
              child: AppPageScrollbar(
                builder: (context, controller) => SingleChildScrollView(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    responsive.padding,
                    20,
                    responsive.padding,
                    32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive.isDesktop
                            ? _dashboardDesktopMaxWidth
                            : responsive.isTablet
                            ? _dashboardTabletMaxWidth
                            : responsive.maxReadingContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Greeting & profile
                          _buildGreetingHeader(),
                          const SizedBox(height: 20),
                          // quran reading & learning continue cards
                          _buildContinueCards(),
                          const SizedBox(height: 24),
                          // title for prayer times section
                          _buildSectionLabel(
                            context.l10n.dashboardSectionPrayerTimes,
                            Icons.access_time_rounded,
                            MyColors.secondary,
                          ),
                          const SizedBox(height: 10),
                          // prayer times card
                          _buildPrayerCard(),
                          const SizedBox(height: 24),
                          // title for duah section
                          _buildSectionLabel(
                            context.l10n.dashboardSectionDua,
                            Icons.auto_awesome_rounded,
                            MyColors.tertiary,
                          ),
                          const SizedBox(height: 10),
                          // action row for duah section
                          _buildSmallActionRow(
                            items: [
                              // daily duah
                              DashboardActionItem(
                                icon: Icons.wb_twilight_rounded,
                                label: context.l10n.dashboardActionDailyDua,
                                sublabel:
                                    context.l10n.dashboardActionDailyDuaSub,
                                color: MyColors.tertiary,
                                onTap: () => _push(const DailyDuahView()),
                              ),
                              // powerful duah
                              DashboardActionItem(
                                icon: Icons.bolt_rounded,
                                label: context.l10n.dashboardActionPowerfulDua,
                                sublabel:
                                    context.l10n.dashboardActionPowerfulDuaSub,
                                color: MyColors.secondary,
                                onTap: () => _push(const PowerfulDuahView()),
                              ),
                              // 99 names
                              DashboardActionItem(
                                icon: Icons.diamond_rounded,
                                label:
                                    context.l10n.dashboardActionNintyNineNames,
                                sublabel: context
                                    .l10n
                                    .dashboardActionNintyNineNamesSub,
                                color: MyColors.primaryLight,
                                onTap: () => _push(const DuahNintyNineView()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // title for other tools section
                          _buildSectionLabel(
                            context.l10n.dashboardSectionOthers,
                            Icons.widgets_rounded,
                            MyColors.secondary,
                          ),
                          const SizedBox(height: 10),
                          // action row for other tools section
                          _buildSmallActionRow(
                            items: [
                              // qibla compass
                              DashboardActionItem(
                                icon: Icons.explore_rounded,
                                label: context.l10n.dashboardActionQiblaCompass,
                                sublabel:
                                    context.l10n.dashboardActionQiblaCompassSub,
                                color: MyColors.primaryLight,
                                onTap: () => _push(const CompassView()),
                              ),
                              // tasbeeh counter
                              DashboardActionItem(
                                icon: Icons.touch_app_rounded,
                                label: context.l10n.dashboardActionTasbeeh,
                                sublabel:
                                    context.l10n.dashboardActionTasbeehSub,
                                color: MyColors.tertiary,
                                onTap: () => _push(const TasbeehView()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // title for hadith section
                          _buildSectionLabel(
                            context.l10n.dashboardSectionHadith,
                            Icons.menu_book_rounded,
                            MyColors.primaryLight,
                          ),
                          const SizedBox(height: 10),
                          // hadith cards
                          _buildHadithCards(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

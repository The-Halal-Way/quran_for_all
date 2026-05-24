import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/utils/app_page_route.dart';
import 'package:quran_for_all/data/models/learn_quran_content.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/learn_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/views/compass/compass_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/daily_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_an_nawawi_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_forty_short_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/powerful_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer_view.dart';
import 'package:quran_for_all/presentation/views/learn_quran/learning_module_detail_view.dart';
import 'package:quran_for_all/presentation/views/read_quran/read_quran_view.dart';
import 'package:quran_for_all/presentation/views/read_quran/surah_details_view.dart';
import 'package:intl/intl.dart';

part '../../widgets/dashobard/dashboard/dashboard_view_models.dart';
part '../../widgets/dashobard/dashboard/dashboard_view_sections.dart';
part '../../widgets/dashobard/dashboard/dashboard_view_widgets.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
  String get _prayerError =>
      context.watch<DashboardPrayerTimesViewModel>().error;
  bool get _loadingPrayerTimes =>
      context.watch<DashboardPrayerTimesViewModel>().isLoading;
  String? get _nextPrayer =>
      context.watch<DashboardPrayerTimesViewModel>().nextPrayer;

  Future<void> _loadPrayerTimes() =>
      context.read<DashboardPrayerTimesViewModel>().loadPrayerTimes(
        forceRefresh: true,
      );

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _cardBg => _isDark ? MyColors.darkCard : MyColors.cardFill;
  Color get _textMain =>
      _isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
  Color get _textSub =>
      _isDark ? MyColors.darkTextSecondary : MyColors.textSecondary;
  Color get _textHint =>
      _isDark ? MyColors.darkTextTertiary : MyColors.textTertiary;
  Color get _divider => _isDark ? MyColors.darkDivider : MyColors.divider;

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
              child: CustomPaint(painter: _BgPainter(isDark: _isDark)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                20,
                responsive.padding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: responsive.maxReadingContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreetingHeader(),
                      const SizedBox(height: 20),
                      _buildContinueCards(),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        'Prayer Times',
                        Icons.access_time_rounded,
                        MyColors.secondary,
                      ),
                      const SizedBox(height: 10),
                      _buildPrayerCard(),
                      const SizedBox(height: 10),
                      _buildSmallActionRow(
                        items: [
                          _ActionItem(
                            icon: Icons.access_time_filled_rounded,
                            label: 'Full Prayer View',
                            color: MyColors.secondary,
                            onTap: () => _push(const PrayerView()),
                          ),
                          _ActionItem(
                            icon: Icons.explore_rounded,
                            label: 'Qibla Compass',
                            color: MyColors.primaryLight,
                            onTap: () => _push(const CompassView()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        "Du'ā'",
                        Icons.auto_awesome_rounded,
                        MyColors.tertiary,
                      ),
                      const SizedBox(height: 10),
                      _buildSmallActionRow(
                        items: [
                          _ActionItem(
                            icon: Icons.wb_twilight_rounded,
                            label: 'Daily Du\'ā\'',
                            sublabel: 'Morning & evening',
                            color: MyColors.tertiary,
                            onTap: () => _push(const DailyDuahView()),
                          ),
                          _ActionItem(
                            icon: Icons.bolt_rounded,
                            label: 'Powerful Du\'ā\'',
                            sublabel: 'Curated supplications',
                            color: MyColors.secondary,
                            onTap: () => _push(const PowerfulDuahView()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        'Hadith',
                        Icons.menu_book_rounded,
                        MyColors.primaryLight,
                      ),
                      const SizedBox(height: 10),
                      _buildHadithCards(),
                    ],
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

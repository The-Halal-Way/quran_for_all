import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/hijri_calendar_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hijri_calendar/hijri_calendar_widgets.dart';

class HijriCalendarView extends StatelessWidget {
  const HijriCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final adjustment = context
        .read<SettingsViewModel>()
        .settings
        .hijriDateAdjustment;

    return ChangeNotifierProvider<HijriCalendarViewModel>(
      create: (_) => HijriCalendarViewModel(dateAdjustment: adjustment),
      child: const _HijriCalendarBody(),
    );
  }
}

class _HijriCalendarBody extends StatelessWidget {
  const _HijriCalendarBody();

  static const double _maxContentWidth = 860;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vm = context.watch<HijriCalendarViewModel>();
    final settingsVm = context.watch<SettingsViewModel>();
    final settingsAdjustment = settingsVm.settings.hijriDateAdjustment;
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (vm.dateAdjustment != settingsAdjustment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.read<HijriCalendarViewModel>().setDateAdjustment(
            settingsAdjustment,
          );
        }
      });
    }

    final weekdayLabels = [
      l10n.hijriWeekdaySun,
      l10n.hijriWeekdayMon,
      l10n.hijriWeekdayTue,
      l10n.hijriWeekdayWed,
      l10n.hijriWeekdayThu,
      l10n.hijriWeekdayFri,
      l10n.hijriWeekdaySat,
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
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
            AppPageScrollbar(
              builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  responsive.padding,
                  AppSpacing.md,
                  responsive.padding,
                  AppSpacing.huge,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HijriCalendarAppBar(
                          title: l10n.hijriCalendarTitle,
                          subtitle: l10n.hijriCalendarSubtitle,
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        HijriCalendarHero(
                          title: vm.formatHijriDate(l10n, vm.today),
                          gregorianDate: vm.formatGregorianDate(
                            l10n,
                            vm.today.gregorianDate,
                          ),
                          adjustmentLabel: vm.adjustmentLabel(
                            l10n,
                            settingsAdjustment,
                          ),
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        HijriCalendarDateFinderCard(
                          selectedDate: vm.selectedDate,
                          dateAdjustment: settingsAdjustment,
                          firstGregorianDate: vm.firstGregorianDate,
                          lastGregorianDate: vm.lastGregorianDate,
                          minHijriYear: vm.minHijriYear,
                          maxHijriYear: vm.maxHijriYear,
                          daysInMonth: vm.daysInMonth,
                          monthName: (month) => vm.monthName(l10n, month),
                          formatNumber: (value) => vm.formatNumber(l10n, value),
                          onGregorianDateSelected: vm.selectGregorianDate,
                          onHijriDateSelected: vm.selectHijriDate,
                          onAdjustmentChanged:
                              settingsVm.setHijriDateAdjustment,
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        HijriCalendarMonthHeader(
                          monthTitle: vm.formatMonthTitle(
                            l10n,
                            vm.visibleMonth,
                          ),
                          gregorianRange: vm.formatGregorianRange(
                            l10n,
                            vm.visibleMonth,
                          ),
                          onPrevious: vm.previousMonth,
                          onNext: vm.nextMonth,
                          onToday: vm.goToToday,
                          canGoPrevious:
                              vm.visibleMonth.year > vm.minHijriYear ||
                              vm.visibleMonth.month > 1,
                          canGoNext:
                              vm.visibleMonth.year < vm.maxHijriYear ||
                              vm.visibleMonth.month < 12,
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        HijriCalendarMonthGrid(
                          month: vm.visibleMonth,
                          weekdayLabels: weekdayLabels,
                          formatNumber: (value) => vm.formatNumber(l10n, value),
                          formatGregorianDay: (date) =>
                              DateFormat('d', l10n.localeName).format(date),
                          isToday: vm.isToday,
                          isSelected: vm.isSelected,
                          onDateSelected: vm.selectDate,
                          isDark: isDark,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        HijriCalendarSelectedDateCard(
                          hijriDate: vm.formatHijriDate(l10n, vm.selectedDate),
                          gregorianDate: vm.formatGregorianDate(
                            l10n,
                            vm.selectedDate.gregorianDate,
                          ),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.secondary,
        foregroundColor: Colors.white,
        onPressed: vm.goToToday,
        tooltip: l10n.hijriCalendarTodayAction,
        child: const Icon(Icons.today_rounded),
      ),
    );
  }
}

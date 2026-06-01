import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:quran_for_all/data/models/hijri/hijri_calendar_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/services/hijri_calendar_service.dart';

class HijriCalendarViewModel extends ChangeNotifier {
  HijriCalendarViewModel({
    HijriCalendarService service = const HijriCalendarService(),
    int dateAdjustment = 0,
  }) : _service = service,
       _dateAdjustment = dateAdjustment.clamp(-1, 1).toInt() {
    _today = _service.fromGregorian(
      DateTime.now(),
      adjustmentDays: _dateAdjustment,
    );
    _selectedDate = _today;
    _visibleMonth = _service.monthFor(
      _today.year,
      _today.month,
      adjustmentDays: _dateAdjustment,
    );
  }

  final HijriCalendarService _service;

  late HijriDateInfo _today;
  late HijriDateInfo _selectedDate;
  late HijriCalendarMonth _visibleMonth;
  int _dateAdjustment;

  HijriDateInfo get today => _today;
  HijriDateInfo get selectedDate => _selectedDate;
  HijriCalendarMonth get visibleMonth => _visibleMonth;
  int get dateAdjustment => _dateAdjustment;

  DateTime get firstGregorianDate => HijriCalendarService
      .minSupportedGregorianDate
      .subtract(Duration(days: _dateAdjustment));
  DateTime get lastGregorianDate => HijriCalendarService
      .maxSupportedGregorianDate
      .subtract(Duration(days: _dateAdjustment));
  int get minHijriYear => HijriCalendarService.minSupportedHijriYear;
  int get maxHijriYear => HijriCalendarService.maxSupportedHijriYear;

  void setDateAdjustment(int value) {
    final normalized = value.clamp(-1, 1).toInt();
    if (_dateAdjustment == normalized) {
      return;
    }

    final selectedGregorian = _selectedDate.gregorianDate;
    _dateAdjustment = normalized;
    _today = _service.fromGregorian(
      DateTime.now(),
      adjustmentDays: _dateAdjustment,
    );
    _selectedDate = _service.fromGregorian(
      selectedGregorian,
      adjustmentDays: _dateAdjustment,
    );
    _visibleMonth = _service.monthFor(
      _selectedDate.year,
      _selectedDate.month,
      adjustmentDays: _dateAdjustment,
    );
    notifyListeners();
  }

  void goToToday() {
    _today = _service.fromGregorian(
      DateTime.now(),
      adjustmentDays: _dateAdjustment,
    );
    _selectedDate = _today;
    _visibleMonth = _service.monthFor(
      _today.year,
      _today.month,
      adjustmentDays: _dateAdjustment,
    );
    notifyListeners();
  }

  void previousMonth() {
    final targetMonth = _visibleMonth.month == 1 ? 12 : _visibleMonth.month - 1;
    final targetYear = _visibleMonth.month == 1
        ? _visibleMonth.year - 1
        : _visibleMonth.year;
    if (targetYear < minHijriYear) {
      return;
    }
    _showMonth(targetYear, targetMonth);
  }

  void nextMonth() {
    final targetMonth = _visibleMonth.month == 12 ? 1 : _visibleMonth.month + 1;
    final targetYear = _visibleMonth.month == 12
        ? _visibleMonth.year + 1
        : _visibleMonth.year;
    if (targetYear > maxHijriYear) {
      return;
    }
    _showMonth(targetYear, targetMonth);
  }

  void selectDate(HijriDateInfo date) {
    _selectedDate = date;
    if (_visibleMonth.year != date.year || _visibleMonth.month != date.month) {
      _visibleMonth = _service.monthFor(
        date.year,
        date.month,
        adjustmentDays: _dateAdjustment,
      );
    }
    notifyListeners();
  }

  void selectGregorianDate(DateTime date) {
    final hijriDate = _service.fromGregorian(
      date,
      adjustmentDays: _dateAdjustment,
    );
    selectDate(hijriDate);
  }

  bool selectHijriDate(int year, int month, int day) {
    if (!_service.isValidHijriDate(year, month, day)) {
      return false;
    }

    selectDate(
      HijriDateInfo(
        year: year,
        month: month,
        day: day,
        gregorianDate: _service.toGregorian(
          year,
          month,
          day,
          adjustmentDays: _dateAdjustment,
        ),
      ),
    );
    return true;
  }

  int daysInMonth(int year, int month) => _service.daysInMonth(year, month);

  bool isToday(HijriDateInfo date) => date.isSameHijriDate(_today);

  bool isSelected(HijriDateInfo date) => date.isSameHijriDate(_selectedDate);

  String monthName(AppLocalizations l10n, int month) {
    return switch (month) {
      1 => l10n.hijriMonthMuharram,
      2 => l10n.hijriMonthSafar,
      3 => l10n.hijriMonthRabiAlAwwal,
      4 => l10n.hijriMonthRabiAlThani,
      5 => l10n.hijriMonthJumadaAlAwwal,
      6 => l10n.hijriMonthJumadaAlThani,
      7 => l10n.hijriMonthRajab,
      8 => l10n.hijriMonthShaban,
      9 => l10n.hijriMonthRamadan,
      10 => l10n.hijriMonthShawwal,
      11 => l10n.hijriMonthDhulQadah,
      12 => l10n.hijriMonthDhulHijjah,
      _ => '',
    };
  }

  String formatHijriDate(AppLocalizations l10n, HijriDateInfo date) {
    return l10n.hijriDateFull(
      formatNumber(l10n, date.day),
      monthName(l10n, date.month),
      formatNumber(l10n, date.year),
    );
  }

  String formatMonthTitle(AppLocalizations l10n, HijriCalendarMonth month) {
    return '${monthName(l10n, month.month)} ${formatNumber(l10n, month.year)}';
  }

  String formatGregorianDate(AppLocalizations l10n, DateTime date) {
    return DateFormat('EEE, d MMM yyyy', l10n.localeName).format(date);
  }

  String formatGregorianRange(AppLocalizations l10n, HijriCalendarMonth month) {
    final format = DateFormat('d MMM', l10n.localeName);
    final yearFormat = DateFormat('d MMM yyyy', l10n.localeName);
    final sameYear =
        month.firstDay.gregorianDate.year == month.lastDay.gregorianDate.year;
    final start = sameYear
        ? format.format(month.firstDay.gregorianDate)
        : yearFormat.format(month.firstDay.gregorianDate);
    return '$start - ${yearFormat.format(month.lastDay.gregorianDate)}';
  }

  String formatNumber(AppLocalizations l10n, int value) {
    final raw = value.toString();
    if (!l10n.localeName.startsWith('bn')) {
      return raw;
    }

    const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return raw.split('').map((char) {
      final digit = int.tryParse(char);
      return digit == null ? char : digits[digit];
    }).join();
  }

  String adjustmentLabel(AppLocalizations l10n, int value) {
    return switch (value) {
      -1 => l10n.hijriAdjustmentMinusLabel,
      1 => l10n.hijriAdjustmentPlusLabel,
      _ => l10n.hijriAdjustmentCalculatedLabel,
    };
  }

  void _showMonth(int year, int month) {
    _visibleMonth = _service.monthFor(
      year,
      month,
      adjustmentDays: _dateAdjustment,
    );
    notifyListeners();
  }
}

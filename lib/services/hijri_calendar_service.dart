import 'package:hijri/hijri_calendar.dart';
import 'package:quran_for_all/data/models/hijri/hijri_calendar_models.dart';

class HijriCalendarService {
  const HijriCalendarService();

  static const int minSupportedHijriYear = 1356;
  static const int maxSupportedHijriYear = 1500;

  static final DateTime minSupportedGregorianDate = DateTime(1937, 3, 14);
  static final DateTime maxSupportedGregorianDate = DateTime(2077, 11, 16);

  HijriDateInfo fromGregorian(DateTime date, {int adjustmentDays = 0}) {
    final adjustedDate = _dateOnly(date).add(Duration(days: adjustmentDays));
    final hijri = HijriCalendar.fromDate(adjustedDate);

    return HijriDateInfo(
      year: hijri.hYear,
      month: hijri.hMonth,
      day: hijri.hDay,
      gregorianDate: _dateOnly(date),
    );
  }

  DateTime toGregorian(int year, int month, int day, {int adjustmentDays = 0}) {
    final gregorian = HijriCalendar()
        .hijriToGregorian(year, month, day)
        .subtract(Duration(days: adjustmentDays));
    return _dateOnly(gregorian);
  }

  HijriCalendarMonth monthFor(int year, int month, {int adjustmentDays = 0}) {
    final safeYear = year
        .clamp(minSupportedHijriYear, maxSupportedHijriYear)
        .toInt();
    final safeMonth = month.clamp(1, 12).toInt();
    final totalDays = daysInMonth(safeYear, safeMonth);
    final days = List<HijriDateInfo>.generate(totalDays, (index) {
      final day = index + 1;
      return HijriDateInfo(
        year: safeYear,
        month: safeMonth,
        day: day,
        gregorianDate: toGregorian(
          safeYear,
          safeMonth,
          day,
          adjustmentDays: adjustmentDays,
        ),
      );
    });

    return HijriCalendarMonth(
      year: safeYear,
      month: safeMonth,
      days: days,
      leadingEmptyDays: days.first.gregorianDate.weekday % 7,
    );
  }

  int daysInMonth(int year, int month) {
    return HijriCalendar().getDaysInMonth(year, month);
  }

  bool isValidHijriDate(int year, int month, int day) {
    if (year < minSupportedHijriYear || year > maxSupportedHijriYear) {
      return false;
    }
    if (month < 1 || month > 12) {
      return false;
    }
    return day >= 1 && day <= daysInMonth(year, month);
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

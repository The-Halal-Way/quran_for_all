class HijriDateInfo {
  const HijriDateInfo({
    required this.year,
    required this.month,
    required this.day,
    required this.gregorianDate,
  });

  final int year;
  final int month;
  final int day;
  final DateTime gregorianDate;

  bool isSameHijriDate(HijriDateInfo other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameGregorianDate(DateTime other) {
    return gregorianDate.year == other.year &&
        gregorianDate.month == other.month &&
        gregorianDate.day == other.day;
  }
}

class HijriCalendarMonth {
  const HijriCalendarMonth({
    required this.year,
    required this.month,
    required this.days,
    required this.leadingEmptyDays,
  });

  final int year;
  final int month;
  final List<HijriDateInfo> days;
  final int leadingEmptyDays;

  HijriDateInfo get firstDay => days.first;
  HijriDateInfo get lastDay => days.last;
}

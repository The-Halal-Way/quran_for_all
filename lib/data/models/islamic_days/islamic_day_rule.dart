import '../hijri/hijri_calendar_models.dart';

enum IslamicDayReminderType { weekly, hijriMonthly, hijriAnnual, hijriPeriod }

/// Islamic recurrences are expressed in Hijri fields, never Gregorian dates.
class IslamicDayRule {
  const IslamicDayRule({
    required this.type,
    this.weekdays = const [],
    this.hijriMonth,
    this.hijriDays = const [],
    this.firstDay,
    this.lastDay,
  });

  final IslamicDayReminderType type;
  final List<int> weekdays;
  final int? hijriMonth;
  final List<int> hijriDays;
  final int? firstDay;
  final int? lastDay;

  bool matches(DateTime localDate, HijriDateInfo hijri) {
    if (type == IslamicDayReminderType.weekly) {
      return weekdays.contains(localDate.weekday);
    }
    if (hijriMonth != null && hijri.month != hijriMonth) return false;
    if (hijriDays.isNotEmpty) return hijriDays.contains(hijri.day);
    return hijri.day >= (firstDay ?? 1) && hijri.day <= (lastDay ?? 30);
  }

  factory IslamicDayRule.fromJson(Map<String, dynamic> json) {
    final type = IslamicDayReminderType.values.byName(json['type'] as String);
    final weekdays = List<int>.from(json['weekdays'] as List? ?? const []);
    final days = List<int>.from(json['hijriDays'] as List? ?? const []);
    final month = json['hijriMonth'] as int?;
    final first = json['firstDay'] as int?;
    final last = json['lastDay'] as int?;
    if (weekdays.any((day) => day < 1 || day > 7) ||
        days.any((day) => day < 1 || day > 30) ||
        (month != null && (month < 1 || month > 12)) ||
        (type == IslamicDayReminderType.weekly && weekdays.isEmpty) ||
        (type == IslamicDayReminderType.hijriAnnual && month == null) ||
        (first != null && (first < 1 || first > 30)) ||
        (last != null && (last < (first ?? 1) || last > 30))) {
      throw const FormatException('Invalid Islamic day recurrence');
    }
    return IslamicDayRule(
      type: type,
      weekdays: List.unmodifiable(weekdays),
      hijriMonth: month,
      hijriDays: List.unmodifiable(days),
      firstDay: first,
      lastDay: last,
    );
  }
}

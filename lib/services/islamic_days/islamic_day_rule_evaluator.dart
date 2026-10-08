import '../../data/models/islamic_days/islamic_day.dart';
import '../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../hijri_calendar_service.dart';

class IslamicDayRuleEvaluator {
  const IslamicDayRuleEvaluator({this.calendar = const HijriCalendarService()});

  final HijriCalendarService calendar;

  List<IslamicDayOccurrence> forDate(
    List<IslamicDay> catalog,
    DateTime date, {
    int adjustment = 0,
    bool isOnHajj = false,
  }) {
    final local = DateTime(date.year, date.month, date.day);
    final hijri = calendar.fromGregorian(local, adjustmentDays: adjustment);
    final matching = catalog
        .where((event) => event.rule.matches(local, hijri))
        .toList();
    // Eligibility is evaluated across the complete catalog before filters or
    // display priority. A user preference cannot bypass a fasting restriction.
    final status =
        matching.any((event) => event.fasting == IslamicDayFasting.prohibited)
        ? IslamicDayFasting.prohibited
        : matching.any((event) => event.fasting == IslamicDayFasting.obligatory)
        ? IslamicDayFasting.obligatory
        : IslamicDayFasting.none;
    matching.sort((a, b) {
      final prohibition = (b.fasting == IslamicDayFasting.prohibited ? 1 : 0)
          .compareTo(a.fasting == IslamicDayFasting.prohibited ? 1 : 0);
      if (prohibition != 0) return prohibition;
      final priority = b.priority.compareTo(a.priority);
      return priority == 0 ? a.id.compareTo(b.id) : priority;
    });
    return List.unmodifiable(
      matching.map(
        (event) => IslamicDayOccurrence(
          event: event,
          date: local,
          hijri: hijri,
          dayFasting: status,
          pilgrimRestriction:
              isOnHajj && matching.any((entry) => entry.nonPilgrimOnly),
        ),
      ),
    );
  }

  /// Includes annual occasions even when the nearest one is many months away.
  List<IslamicDayOccurrence> nextOccurrences(
    List<IslamicDay> catalog,
    DateTime from, {
    int adjustment = 0,
    bool isOnHajj = false,
    bool includeToday = false,
  }) {
    final remaining = catalog.map((event) => event.id).toSet();
    final result = <IslamicDayOccurrence>[];
    for (
      var offset = includeToday ? 0 : 1;
      offset <= 400 && remaining.isNotEmpty;
      offset++
    ) {
      // Calendar arithmetic, rather than 24-hour durations, handles DST changes.
      final date = DateTime(from.year, from.month, from.day + offset);
      for (final occurrence in forDate(
        catalog,
        date,
        adjustment: adjustment,
        isOnHajj: isOnHajj,
      )) {
        if (remaining.remove(occurrence.event.id)) result.add(occurrence);
      }
    }
    return List.unmodifiable(result);
  }
}

import '../hijri/hijri_calendar_models.dart';
import 'islamic_day.dart';

String islamicDayDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class IslamicDayOccurrence {
  const IslamicDayOccurrence({
    required this.event,
    required this.date,
    required this.hijri,
    required this.dayFasting,
    required this.pilgrimRestriction,
  });

  final IslamicDay event;
  final DateTime date;
  final HijriDateInfo hijri;
  final IslamicDayFasting dayFasting;
  final bool pilgrimRestriction;

  String get key => '${event.id}@${islamicDayDateKey(date)}';

  bool get fastingSuppressed =>
      dayFasting == IslamicDayFasting.prohibited ||
      pilgrimRestriction ||
      (dayFasting == IslamicDayFasting.obligatory &&
          event.fasting == IslamicDayFasting.recommended);

  List<IslamicDayAction> get availableActions => List.unmodifiable(
    event.actions.where((action) => !action.fasting || !fastingSuppressed),
  );

  String actionKey(IslamicDayAction action) => '$key/${action.id}';
}

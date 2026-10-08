import '../../data/models/islamic_days/islamic_day.dart';
import '../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../data/models/islamic_days/islamic_days_preferences.dart';
import 'islamic_day_rule_evaluator.dart';

class IslamicDayNotificationPlan {
  const IslamicDayNotificationPlan({
    required this.when,
    required this.target,
    required this.title,
    required this.body,
    required this.preparation,
  });

  final DateTime when;
  final IslamicDayOccurrence target;
  final String title;
  final String body;
  final bool preparation;

  // A separate ID namespace keeps these alerts independent of Daily Hadith.
  int get id {
    var hash = 0x811c9dc5;
    for (final unit in '${target.key}:$preparation'.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    return 0x50000000 | (hash & 0x0fffffff);
  }
}

List<IslamicDayNotificationPlan> planIslamicDayNotifications({
  required List<IslamicDay> catalog,
  required IslamicDaysPreferences preferences,
  required IslamicDayRuleEvaluator evaluator,
  required DateTime now,
  required String locale,
  required int adjustment,
}) {
  if (!preferences.notificationsEnabled) return const [];
  final bn = locale.startsWith('bn');
  final plans = <IslamicDayNotificationPlan>[];
  for (var offset = 0; offset <= 60; offset++) {
    final date = DateTime(now.year, now.month, now.day + offset);
    final occurrences = evaluator.forDate(
      catalog,
      date,
      adjustment: adjustment,
      isOnHajj: preferences.isOnHajj,
    );
    final eligible = occurrences
        .where(
          (occurrence) =>
              occurrence.event.fasting == IslamicDayFasting.prohibited ||
              preferences.categories.contains(occurrence.event.category),
        )
        .where(
          (occurrence) =>
              !(occurrence.event.category == IslamicDayCategory.fasting &&
                  occurrence.fastingSuppressed),
        )
        .toList();
    if (eligible.isEmpty) continue;
    final target = eligible.first;
    final names = eligible
        .map((entry) => entry.event.title.resolve(locale))
        .join(' · ');
    final prohibited = target.dayFasting == IslamicDayFasting.prohibited;
    final when = DateTime(
      date.year,
      date.month,
      date.day,
      preferences.hour,
      preferences.minute,
    );
    if (when.isAfter(now)) {
      plans.add(
        IslamicDayNotificationPlan(
          when: when,
          target: target,
          title: bn ? 'ইসলামি দিন · আজ' : 'Islamic Days · Today',
          body: prohibited
              ? (bn
                    ? '$names। আজ সাধারণ রোজা রাখবেন না।'
                    : '$names. Do not observe an ordinary fast today.')
              : names,
          preparation: false,
        ),
      );
    }
    final fast = eligible.where(
      (entry) =>
          !entry.fastingSuppressed &&
          {
            IslamicDayFasting.recommended,
            IslamicDayFasting.obligatory,
          }.contains(entry.event.fasting),
    );
    if (preferences.preparationEnabled && !prohibited && fast.isNotEmpty) {
      final evening = DateTime(
        date.year,
        date.month,
        date.day - 1,
        preferences.preparationHour,
        preferences.preparationMinute,
      );
      if (evening.isAfter(now)) {
        plans.add(
          IslamicDayNotificationPlan(
            when: evening,
            target: fast.first,
            title: bn
                ? 'আগামীকালের রোজার প্রস্তুতি'
                : 'Prepare for tomorrow’s fast',
            body: fast.first.event.title.resolve(locale),
            preparation: true,
          ),
        );
      }
    }
  }
  plans.sort((a, b) => a.when.compareTo(b.when));
  // Daily Hadith reserves 32 pending notifications; 24 leaves room under iOS's
  // per-app limit. The rolling window is replenished on resume and date change.
  return List.unmodifiable(plans.take(24));
}

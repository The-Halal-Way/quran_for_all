import '../data/models/daily_reminders/daily_reminder_pack.dart';

class DailyReminderOccurrence {
  const DailyReminderOccurrence({
    required this.notificationId,
    required this.occurrenceId,
    required this.contentId,
    required this.when,
    required this.title,
    required this.body,
  });

  final int notificationId;
  final String occurrenceId;
  final String contentId;
  final DateTime when;
  final String title;
  final String body;
}

List<DailyReminderOccurrence> planDailyReminderOccurrences({
  required DailyReminderPack pack,
  required DailyReminderPreferences preferences,
  required String locale,
  required DateTime now,
  int limit = 32,
}) {
  if (!preferences.notificationsEnabled) return const [];
  final planned = <DailyReminderOccurrence>[];
  final usedIds = <int>{};
  for (final entry in pack.schedule) {
    if (!entry.sendNotification || planned.length >= limit) break;
    final item = pack.itemById(entry.contentId);
    if (item == null ||
        !preferences.enabledKinds.contains(item.kind) ||
        !item.isProductionEligible(locale)) {
      continue;
    }
    final when = entry.localDate.toLocalDateTime(
      hour: preferences.hour,
      minute: preferences.minute,
    );
    if (!when.isAfter(now)) continue;
    final resolved = item.resolveEdition(locale, approvedOnly: true)!;
    final occurrenceId = '${pack.packId}:${pack.revision}:${entry.id}';
    final notificationId = dailyReminderNotificationId(occurrenceId);
    if (!usedIds.add(notificationId)) {
      throw StateError('Daily reminder notification ID collision');
    }
    planned.add(
      DailyReminderOccurrence(
        notificationId: notificationId,
        occurrenceId: occurrenceId,
        contentId: item.id,
        when: when,
        title: resolved.edition.notification.title,
        body: resolved.edition.notification.body,
      ),
    );
  }
  return List.unmodifiable(planned);
}

/// Stable FNV-1a based ID in a namespace reserved for Daily Reminders.
int dailyReminderNotificationId(String occurrenceId) {
  var hash = 0x811c9dc5;
  for (final byte in occurrenceId.codeUnits) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0x7fffffff;
  }
  return 700000000 + (hash % 200000000);
}

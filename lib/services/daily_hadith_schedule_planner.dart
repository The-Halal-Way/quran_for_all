import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

class DailyHadithOccurrence {
  const DailyHadithOccurrence({
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

List<DailyHadithOccurrence> planDailyHadithOccurrences({
  required DailyHadithPack pack,
  required DailyHadithPreferences preferences,
  required String locale,
  required DateTime now,
  int limit = 32,
}) {
  if (!preferences.notificationsEnabled) return const [];
  final planned = <DailyHadithOccurrence>[];
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
    final notificationId = dailyHadithNotificationId(occurrenceId);
    if (!usedIds.add(notificationId)) {
      throw StateError('Daily Hadith notification ID collision');
    }
    planned.add(
      DailyHadithOccurrence(
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

/// Stable FNV-1a based ID in this feature's namespace, retained across renames.
int dailyHadithNotificationId(String occurrenceId) {
  var hash = 0x811c9dc5;
  for (final byte in occurrenceId.codeUnits) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0x7fffffff;
  }
  return 700000000 + (hash % 200000000);
}

import '../../data/models/daily_reminders/daily_reminder_pack.dart';

abstract class DailyReminderRepository {
  Future<DailyReminderPack> loadPack({bool forceRefresh = false});
  Future<DailyReminderUserState> loadUserState();
  Future<void> saveUserState(DailyReminderUserState state);
  Future<DailyReminderPreferences> loadPreferences();
  Future<void> savePreferences(DailyReminderPreferences preferences);
  Future<Set<int>> loadScheduledOccurrenceIds();
  Future<void> saveScheduledOccurrenceIds(Set<int> ids);
}

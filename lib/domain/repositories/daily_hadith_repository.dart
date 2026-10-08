import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

abstract class DailyHadithRepository {
  Future<DailyHadithPack> loadPack({bool forceRefresh = false});
  Future<DailyHadithUserState> loadUserState();
  Future<void> saveUserState(DailyHadithUserState state);
  Future<DailyHadithPreferences> loadPreferences();
  Future<void> savePreferences(DailyHadithPreferences preferences);
  Future<Set<int>> loadScheduledOccurrenceIds();
  Future<void> saveScheduledOccurrenceIds(Set<int> ids);
}

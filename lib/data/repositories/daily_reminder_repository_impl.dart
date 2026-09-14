import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/daily_reminder_repository.dart';
import '../datasources/local/daily_reminder_pack_loader.dart';
import '../models/daily_reminders/daily_reminder_pack.dart';

class DailyReminderRepositoryImpl implements DailyReminderRepository {
  DailyReminderRepositoryImpl({DailyReminderPackLoader? packLoader})
    : _packLoader = packLoader ?? DailyReminderPackLoader();

  static const _stateKey = 'daily_reminders_user_state_v2';
  static const _preferencesKey = 'daily_reminders_preferences_v2';
  static const _occurrencesKey = 'daily_reminders_occurrences_v2';
  final DailyReminderPackLoader _packLoader;

  @override
  Future<DailyReminderPack> loadPack({bool forceRefresh = false}) =>
      _packLoader.load(forceRefresh: forceRefresh);

  @override
  Future<DailyReminderUserState> loadUserState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stateKey);
    if (raw == null || raw.isEmpty) return const DailyReminderUserState();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final readRaw = (map['readAt'] as Map?)?.cast<String, dynamic>() ?? {};
      return DailyReminderUserState(
        readAtByContentId: readRaw.map(
          (id, value) => MapEntry(id, DateTime.parse(value as String)),
        ),
        savedContentIds: Set<String>.from(map['saved'] as List? ?? const []),
        releasedContentIds: Set<String>.from(
          map['released'] as List? ?? const [],
        ),
        highWaterDate: map['highWaterDate'] == null
            ? null
            : LocalCalendarDate.parse(map['highWaterDate'] as String),
      );
    } catch (_) {
      return const DailyReminderUserState();
    }
  }

  @override
  Future<void> saveUserState(DailyReminderUserState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _stateKey,
      jsonEncode({
        'readAt': state.readAtByContentId.map(
          (id, date) => MapEntry(id, date.toIso8601String()),
        ),
        'saved': state.savedContentIds.toList()..sort(),
        'released': state.releasedContentIds.toList()..sort(),
        'highWaterDate': state.highWaterDate?.toString(),
      }),
    );
  }

  @override
  Future<DailyReminderPreferences> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_preferencesKey);
    if (raw == null || raw.isEmpty) return const DailyReminderPreferences();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return DailyReminderPreferences(
        notificationsEnabled: map['enabled'] as bool? ?? false,
        hour: map['hour'] as int? ?? 8,
        minute: map['minute'] as int? ?? 0,
        enabledKinds: Set<String>.from(
          map['enabledKinds'] as List? ??
              const [
                'quranReflection',
                'hadithReflection',
                'sunnah',
                'akhirahReflection',
              ],
        ),
      );
    } catch (_) {
      return const DailyReminderPreferences();
    }
  }

  @override
  Future<void> savePreferences(DailyReminderPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _preferencesKey,
      jsonEncode({
        'enabled': preferences.notificationsEnabled,
        'hour': preferences.hour,
        'minute': preferences.minute,
        'enabledKinds': preferences.enabledKinds.toList()..sort(),
      }),
    );
  }

  @override
  Future<Set<int>> loadScheduledOccurrenceIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_occurrencesKey) ?? const [])
        .map(int.tryParse)
        .whereType<int>()
        .toSet();
  }

  @override
  Future<void> saveScheduledOccurrenceIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _occurrencesKey,
      ids.map((id) => id.toString()).toList()..sort(),
    );
  }
}

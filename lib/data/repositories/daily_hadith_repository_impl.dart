import 'dart:convert';

import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/daily_hadith_repository.dart';
import '../datasources/local/daily_hadith_pack_loader.dart';

class DailyHadithRepositoryImpl implements DailyHadithRepository {
  DailyHadithRepositoryImpl({DailyHadithPackLoader? packLoader})
    : _packLoader = packLoader ?? DailyHadithPackLoader();

  static const _stateKey = 'daily_hadith_user_state_v2';
  static const _preferencesKey = 'daily_hadith_preferences_v2';
  static const _occurrencesKey = 'daily_hadith_occurrences_v2';
  final DailyHadithPackLoader _packLoader;

  @override
  Future<DailyHadithPack> loadPack({bool forceRefresh = false}) =>
      _packLoader.load(forceRefresh: forceRefresh);

  @override
  Future<DailyHadithUserState> loadUserState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stateKey);
    if (raw == null || raw.isEmpty) return const DailyHadithUserState();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final readRaw = (map['readAt'] as Map?)?.cast<String, dynamic>() ?? {};
      return DailyHadithUserState(
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
      return const DailyHadithUserState();
    }
  }

  @override
  Future<void> saveUserState(DailyHadithUserState state) async {
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
  Future<DailyHadithPreferences> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_preferencesKey);
    if (raw == null || raw.isEmpty) return const DailyHadithPreferences();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return DailyHadithPreferences(
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
      return const DailyHadithPreferences();
    }
  }

  @override
  Future<void> savePreferences(DailyHadithPreferences preferences) async {
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

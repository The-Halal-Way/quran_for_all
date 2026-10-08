import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:quran_for_all/data/repositories/daily_hadith_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('loads reading history saved before the Daily Hadith rename', () async {
    final readAt = DateTime(2026, 9, 14, 9, 30);
    SharedPreferences.setMockInitialValues({
      'daily_reminders_user_state_v2': jsonEncode({
        'readAt': {'dr-0001': readAt.toIso8601String()},
        'saved': ['dr-0002'],
        'released': ['dr-0001', 'dr-0002'],
        'highWaterDate': '2026-09-14',
      }),
    });

    final state = await DailyHadithRepositoryImpl().loadUserState();

    expect(state.readAtByContentId, {'dr-0001': readAt});
    expect(state.savedContentIds, {'dr-0002'});
    expect(state.releasedContentIds, {'dr-0001', 'dr-0002'});
    expect(state.highWaterDate, const LocalCalendarDate(2026, 9, 14));
  });

  test('loads existing notification preferences and scheduled IDs', () async {
    SharedPreferences.setMockInitialValues({
      'daily_reminders_preferences_v2': jsonEncode({
        'enabled': true,
        'hour': 19,
        'minute': 45,
        'enabledKinds': ['hadithReflection', 'sunnah'],
      }),
      'daily_reminders_occurrences_v2': ['101', '202'],
    });
    final repository = DailyHadithRepositoryImpl();

    final preferences = await repository.loadPreferences();

    expect(preferences.notificationsEnabled, isTrue);
    expect(preferences.hour, 19);
    expect(preferences.minute, 45);
    expect(preferences.enabledKinds, {'hadithReflection', 'sunnah'});
    expect(await repository.loadScheduledOccurrenceIds(), {101, 202});
  });

  test('continues saving under the existing persistence keys', () async {
    final repository = DailyHadithRepositoryImpl();
    final readAt = DateTime(2026, 9, 15, 10);
    await repository.saveUserState(
      DailyHadithUserState(
        readAtByContentId: {'dr-0001': readAt},
        savedContentIds: const {'dr-0003'},
        releasedContentIds: const {'dr-0001', 'dr-0002', 'dr-0003'},
        highWaterDate: const LocalCalendarDate(2026, 9, 15),
      ),
    );
    await repository.savePreferences(
      const DailyHadithPreferences(
        notificationsEnabled: true,
        hour: 20,
        minute: 15,
        enabledKinds: {'hadithReflection'},
      ),
    );
    await repository.saveScheduledOccurrenceIds({303, 101});

    final storage = await SharedPreferences.getInstance();
    expect(storage.getKeys(), {
      'daily_reminders_user_state_v2',
      'daily_reminders_preferences_v2',
      'daily_reminders_occurrences_v2',
    });
    expect(jsonDecode(storage.getString('daily_reminders_user_state_v2')!), {
      'readAt': {'dr-0001': readAt.toIso8601String()},
      'saved': ['dr-0003'],
      'released': ['dr-0001', 'dr-0002', 'dr-0003'],
      'highWaterDate': '2026-09-15',
    });
    expect(jsonDecode(storage.getString('daily_reminders_preferences_v2')!), {
      'enabled': true,
      'hour': 20,
      'minute': 15,
      'enabledKinds': ['hadithReflection'],
    });
    expect(storage.getStringList('daily_reminders_occurrences_v2'), [
      '101',
      '303',
    ]);
  });

  test(
    'fresh installs keep empty history and notifications disabled',
    () async {
      final repository = DailyHadithRepositoryImpl();
      final state = await repository.loadUserState();
      final preferences = await repository.loadPreferences();

      expect(state.readAtByContentId, isEmpty);
      expect(state.savedContentIds, isEmpty);
      expect(state.releasedContentIds, isEmpty);
      expect(state.highWaterDate, isNull);
      expect(preferences.notificationsEnabled, isFalse);
      expect(preferences.hour, 8);
      expect(preferences.minute, 0);
      expect(
        preferences.enabledKinds,
        const DailyHadithPreferences().enabledKinds,
      );
      expect(await repository.loadScheduledOccurrenceIds(), isEmpty);
    },
  );
}

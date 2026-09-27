import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/prayer_times/prayer_home_widget_bridge.dart';
import 'package:quran_for_all/core/prayer_times/prayer_widget_calendar.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_preferences_store.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/repositories/settings_repository_impl.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('home_widget');
  String? savedSnapshot;
  final calls = <MethodCall>[];

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    SharedPreferences.setMockInitialValues({});
    savedSnapshot = null;
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'getWidgetData') return savedSnapshot;
          if (call.method == 'saveWidgetData') {
            savedSnapshot = (call.arguments as Map)['data'] as String;
          }
          return true;
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'old snapshots remain readable without the new date and fasting fields',
    () {
      final json =
          jsonDecode(_snapshot().toJsonString()) as Map<String, dynamic>;
      for (final day in json['days'] as List) {
        (day as Map).remove('hijriDateLabel');
        day.remove('sehriEndUtcMillis');
      }
      final legacy = PrayerWidgetSnapshot.fromJsonString(jsonEncode(json));

      expect(legacy.days.single.hijriDateLabel, isNull);
      expect(legacy.days.single.sehriEndUtcMillis, isNull);
      expect(
        legacy.days.single.fajrUtcMillis,
        _snapshot().days.single.fajrUtcMillis,
      );
    },
  );

  test(
    'English Hijri date adjustment crosses calendar boundaries without changing times',
    () {
      expect(
        PrayerWidgetCalendar.hijriDateLabel('2024-01-31', adjustmentDays: 1),
        PrayerWidgetCalendar.hijriDateLabel('2024-02-01'),
      );
      expect(
        PrayerWidgetCalendar.hijriDateLabel('2024-03-11'),
        '1 Ramadan 1445 AH',
      );
      final original = _snapshot();
      final decorated = PrayerWidgetCalendar.decorate(
        original,
        adjustmentDays: -1,
      );
      expect(
        decorated.days.single.hijriDateLabel,
        PrayerWidgetCalendar.hijriDateLabel('2024-03-10'),
      );
      expect(decorated.timeZoneId, 'Asia/Dhaka');
      expect(decorated.days.single.localDateKey, '2024-03-11');
      expect(
        decorated.days.single.sehriEndUtcMillis,
        original.days.single.sehriEndUtcMillis,
      );
      expect(
        decorated.days.single.maghribUtcMillis,
        original.days.single.maghribUtcMillis,
      );
    },
  );

  test(
    'snapshot storage exports adjusted dates and the actual Sehri cutoff to native widgets',
    () async {
      SharedPreferences.setMockInitialValues({'hijri_date_adjustment': 1});
      await PrayerTimesPreferencesStore().writeWidgetSnapshot(_snapshot());
      final stored = PrayerWidgetSnapshot.fromJsonString(savedSnapshot!);

      expect(
        stored.days.single.hijriDateLabel,
        PrayerWidgetCalendar.hijriDateLabel('2024-03-12'),
      );
      expect(
        stored.days.single.sehriEndUtcMillis,
        _snapshot().days.single.sehriEndUtcMillis,
      );
      expect(calls.last.method, 'updateWidget');
      expect(
        (calls.last.arguments as Map)['qualifiedAndroidName'],
        PrayerHomeWidgetBridge.qualifiedAndroidProviderName,
      );
      expect(
        (calls.last.arguments as Map)['ios'],
        PrayerHomeWidgetBridge.iOSWidgetName,
      );
    },
  );

  test(
    'changing Hijri adjustment refreshes the existing widget without a network fetch',
    () async {
      final store = PrayerTimesPreferencesStore();
      await store.writeWidgetSnapshot(_snapshot());
      final oldLabel = PrayerWidgetSnapshot.fromJsonString(
        savedSnapshot!,
      ).days.single.hijriDateLabel;
      calls.clear();

      await SettingsRepositoryImpl().saveSettings(
        AppSettings.defaults().copyWith(hijriDateAdjustment: -1),
      );
      final refreshed = PrayerWidgetSnapshot.fromJsonString(savedSnapshot!);
      expect(refreshed.days.single.hijriDateLabel, isNot(oldLabel));
      expect(
        refreshed.days.single.hijriDateLabel,
        PrayerWidgetCalendar.hijriDateLabel('2024-03-10'),
      );
      expect(
        refreshed.days.single.fajrUtcMillis,
        _snapshot().days.single.fajrUtcMillis,
      );
      expect(calls.map((call) => call.method), [
        'getWidgetData',
        'saveWidgetData',
        'updateWidget',
      ]);
    },
  );

  test(
    'invalid stored data does not prevent saving calendar settings',
    () async {
      savedSnapshot = 'invalid json';
      await SettingsRepositoryImpl().saveSettings(
        AppSettings.defaults().copyWith(hijriDateAdjustment: 1),
      );
      expect(
        (await SettingsRepositoryImpl().getSettings()).hijriDateAdjustment,
        1,
      );
    },
  );
}

PrayerWidgetSnapshot _snapshot() {
  final fajr = DateTime.utc(2024, 3, 10, 23, 30);
  return PrayerWidgetSnapshot(
    profileSignature: 'dhaka-profile',
    timeZoneId: 'Asia/Dhaka',
    locationLabel: 'Dhaka',
    generatedAtUtcMillis: fajr.millisecondsSinceEpoch,
    lastSuccessfulSyncAtUtcMillis: fajr.millisecondsSinceEpoch,
    days: [
      PrayerWidgetDaySnapshot(
        localDateKey: '2024-03-11',
        fajrUtcMillis: fajr.millisecondsSinceEpoch,
        sunriseUtcMillis: fajr
            .add(const Duration(hours: 1))
            .millisecondsSinceEpoch,
        dhuhrUtcMillis: fajr
            .add(const Duration(hours: 7))
            .millisecondsSinceEpoch,
        asrUtcMillis: fajr
            .add(const Duration(hours: 10))
            .millisecondsSinceEpoch,
        maghribUtcMillis: fajr
            .add(const Duration(hours: 13))
            .millisecondsSinceEpoch,
        ishaUtcMillis: fajr
            .add(const Duration(hours: 14))
            .millisecondsSinceEpoch,
        sehriEndUtcMillis: fajr
            .subtract(const Duration(minutes: 5))
            .millisecondsSinceEpoch,
      ),
    ],
  );
}

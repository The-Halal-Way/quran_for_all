import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/prayer_times/prayer_time_zone_helper.dart';
import 'package:quran_for_all/data/datasources/local/offline_prayer_calculator.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_local_data_source.dart';
import 'package:quran_for_all/data/datasources/local/prayer_times_preferences_store.dart';
import 'package:quran_for_all/data/repositories/prayer_times_repository_impl.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:quran_for_all/services/prayer_location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offline_prayer_calculator_test.dart' show profile;

class MemoryPrayerSource extends PrayerTimesLocalDataSource {
  final profiles = <String, PrayerProfile>{};
  final days = <String, PrayerDay>{};
  @override
  Future<void> upsertProfile(PrayerProfile p) async {
    profiles[p.signature] = p;
  }

  @override
  Future<PrayerProfile?> getProfile(String key) async => profiles[key];
  @override
  Future<void> upsertPrayerDays(List<PrayerDay> values) async {
    for (final d in values) {
      days['${d.profileSignature}/${d.localDateKey}'] = d;
    }
  }

  @override
  Future<PrayerDay?> getPrayerDay(String signature, String key) async =>
      days['$signature/$key'];
  @override
  Future<List<PrayerDay>> getPrayerDaysInRange(
    String signature,
    String start,
    String end,
  ) async =>
      days.values
          .where(
            (d) =>
                d.profileSignature == signature &&
                d.localDateKey.compareTo(start) >= 0 &&
                d.localDateKey.compareTo(end) <= 0,
          )
          .toList()
        ..sort((a, b) => a.localDateKey.compareTo(b.localDateKey));
  @override
  Future<void> upsertSyncState(PrayerSyncState state) async {}
  @override
  Future<void> deletePrayerDaysOutsideRange({
    required String profileSignature,
    required String keepFromDateKey,
    required String keepToDateKey,
  }) async {}
}

class Location extends PrayerLocationService {
  String zone = 'Asia/Dhaka';
  bool fallback = false;
  @override
  Future<({PrayerProfile profile, bool isFallback})> resolve({
    required PrayerCalculationConfig config,
    required PrayerProfile? savedProfile,
    required bool refresh,
    required bool requestPermission,
  }) async {
    final p = profile(zone: zone, config: config);
    return (
      profile: PrayerProfile(
        signature: '$zone|${config.signatureSeed()}',
        locationIdentity: p.locationIdentity,
        latitude: p.latitude,
        longitude: p.longitude,
        latitudeBucket: p.latitudeBucket,
        longitudeBucket: p.longitudeBucket,
        timeZoneId: zone,
        calculation: config,
        displayLocationLabel: p.displayLocationLabel,
        createdAtUtc: p.createdAtUtc,
        lastUsedAtUtc: p.lastUsedAtUtc,
      ),
      isFallback: fallback,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('home_widget');
  String? rawSnapshot;
  final calls = <MethodCall>[];
  late MemoryPrayerSource source;
  late PrayerTimesPreferencesStore preferences;
  late Location location;
  late PrayerTimesRepositoryImpl repository;
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    SharedPreferences.setMockInitialValues({'app_language': 'bn'});
    rawSnapshot = null;
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'saveWidgetData') {
            rawSnapshot = call.arguments['data'] as String;
          }
          if (call.method == 'getWidgetData') return rawSnapshot;
          return true;
        });
    source = MemoryPrayerSource();
    preferences = PrayerTimesPreferencesStore();
    location = Location();
    repository = PrayerTimesRepositoryImpl(
      localDataSource: source,
      preferencesStore: preferences,
      calculator: const OfflinePrayerCalculator(),
      locationService: location,
    );
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'first calculation produces today/tomorrow and publishes the same widget times',
    () async {
      final data = await repository.loadDashboardData();
      final tomorrow = data.tomorrow!;
      expect(
        tomorrow.localDateKey,
        PrayerTimeZoneHelper.dateKeyAfter(data.today.localDateKey, 1),
      );
      final snapshot = PrayerWidgetSnapshot.fromJsonString(rawSnapshot!);
      expect(snapshot.days, hasLength(2));
      expect(
        snapshot.days.first.ishaEndUtcMillis,
        tomorrow.fajrUtc.millisecondsSinceEpoch,
      );
      expect(snapshot.labels.localeIdentifier, 'bn_BD');
      expect(
        snapshot.days.first.fajrUtcMillis,
        data.today.fajrUtc.millisecondsSinceEpoch,
      );
      expect(
        snapshot.days.first.maghribUtcMillis,
        data.today.maghribUtc.millisecondsSinceEpoch,
      );
      expect(
        snapshot.days.first.sehriEndUtcMillis,
        data.today.fajrUtc
            .subtract(const Duration(minutes: 10))
            .millisecondsSinceEpoch,
      );
      expect(calls.last.method, 'updateWidget');
    },
  );

  test(
    'rolling widget schedule is complete, localized, and cannot shrink back to two days',
    () async {
      await repository.loadDashboardData();
      await repository.warmUpcomingPrayerDays();
      var snapshot = PrayerWidgetSnapshot.fromJsonString(rawSnapshot!);
      expect(snapshot.days, hasLength(30));
      expect(snapshot.days.map((d) => d.localDateKey).toSet(), hasLength(30));
      expect(snapshot.days.every((d) => d.ishaEndUtcMillis != null), isTrue);
      final last = snapshot.days.last;
      final nextFajr = await source.getPrayerDay(
        snapshot.profileSignature,
        PrayerTimeZoneHelper.dateKeyAfter(last.localDateKey, 1),
      );
      expect(last.ishaEndUtcMillis, nextFajr!.fajrUtc.millisecondsSinceEpoch);
      for (var index = 0; index < snapshot.days.length - 1; index++) {
        expect(
          snapshot.days[index].ishaEndUtcMillis,
          snapshot.days[index + 1].fajrUtcMillis,
        );
      }
      expect(
        snapshot.days.every((d) => d.hijriDateLabel?.isNotEmpty == true),
        isTrue,
      );
      final first = snapshot.days.first.localDateKey;
      expect(
        snapshot.days.last.localDateKey,
        PrayerTimeZoneHelper.dateKeyAfter(first, 29),
      );
      await repository.loadDashboardData();
      snapshot = PrayerWidgetSnapshot.fromJsonString(rawSnapshot!);
      expect(snapshot.days, hasLength(30));
    },
  );

  test(
    'settings change replaces app and widget with the selected schedule',
    () async {
      final initial = await repository.loadDashboardData();
      await repository.warmUpcomingPrayerDays();
      await preferences.saveCalculationConfig(
        initial.profile.calculation.copyWith(
          madhab: PrayerMadhab.hanafi,
          adjustments: const PrayerAdjustments(fajr: 7),
        ),
      );
      expect(rawSnapshot, '');
      expect(await repository.loadCachedDashboardData(), isNull);
      final next = await repository.loadDashboardData();
      await repository.warmUpcomingPrayerDays();
      expect(next.today.fajrUtc.difference(initial.today.fajrUtc).inMinutes, 7);
      expect(next.today.asrUtc.isAfter(initial.today.asrUtc), isTrue);
      final snapshot = PrayerWidgetSnapshot.fromJsonString(rawSnapshot!);
      expect(snapshot.profileSignature, next.profile.signature);
      expect(snapshot.days, hasLength(30));
      expect(
        snapshot.days.first.fajrUtcMillis,
        next.today.fajrUtc.millisecondsSinceEpoch,
      );
    },
  );

  test('saved coordinates remain usable with no fresh location fix', () async {
    await repository.loadDashboardData();
    location.fallback = true;
    final data = await repository.loadDashboardData(forceRefresh: true);
    expect(data.isFallbackProfile, isTrue);
    expect(data.today.solarTimes, isNotNull);
    expect(
      (await repository.loadCachedDashboardData())!.today.fajrUtc,
      data.today.fajrUtc,
    );
  });

  test(
    'timezone changes replace widget profile and its 30 local calendar days',
    () async {
      await repository.loadDashboardData();
      location.zone = 'Asia/Kuala_Lumpur';
      await repository.handleAppResumed();
      await repository.warmUpcomingPrayerDays();
      final snapshot = PrayerWidgetSnapshot.fromJsonString(rawSnapshot!);
      expect(snapshot.timeZoneId, 'Asia/Kuala_Lumpur');
      expect(snapshot.days, hasLength(30));
    },
  );
}

import 'package:timezone/timezone.dart' as tz;

import '../../core/prayer_times/prayer_time_zone_helper.dart';
import '../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../services/prayer_location_service.dart';
import '../datasources/local/offline_prayer_calculator.dart';
import '../datasources/local/prayer_times_local_data_source.dart';
import '../datasources/local/prayer_times_preferences_store.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  PrayerTimesRepositoryImpl({
    required PrayerTimesLocalDataSource localDataSource,
    required PrayerTimesPreferencesStore preferencesStore,
    required OfflinePrayerCalculator calculator,
    PrayerLocationService? locationService,
  }) : _local = localDataSource,
       _preferences = preferencesStore,
       _calculator = calculator,
       _location = locationService ?? PrayerLocationService();

  final PrayerTimesLocalDataSource _local;
  final PrayerTimesPreferencesStore _preferences;
  final OfflinePrayerCalculator _calculator;
  final PrayerLocationService _location;
  Future<void>? _windowTask;

  @override
  Future<PrayerDashboardData?> loadCachedDashboardData() async {
    final profile = await _savedProfile();
    if (profile == null ||
        profile.calculation.signatureSeed() !=
            (await _preferences.getCalculationConfig()).signatureSeed()) {
      return null;
    }
    return _compose(profile, isFallback: true);
  }

  @override
  Future<PrayerDashboardData> loadDashboardData({
    bool forceRefresh = false,
  }) async {
    final resolved = await _resolve(
      refresh: forceRefresh,
      requestPermission: true,
    );
    final profile = resolved.profile;
    final today = _today(profile.timeZoneId);
    await _ensureDays(profile, [
      today,
      PrayerTimeZoneHelper.dateKeyAfter(today, 1),
    ], force: forceRefresh);
    final data = await _compose(profile, isFallback: resolved.isFallback);
    if (data == null) {
      throw const PrayerTimesException(
        PrayerRepositoryErrorType.unavailable,
        'Prayer times are unavailable.',
      );
    }
    await _writeSnapshot(profile);
    return data;
  }

  @override
  Future<void> warmUpcomingPrayerDays({
    int dayCount = 30,
    bool forceRefresh = false,
  }) async {
    if (dayCount < 1 || dayCount > 366) {
      throw ArgumentError.value(dayCount, 'dayCount');
    }
    // Serialize windows, then re-resolve the profile. A new settings change
    // must not share an older profile's in-flight calculation.
    while (_windowTask != null) {
      try {
        await _windowTask;
      } catch (_) {
        /* The next profile can retry. */
      }
    }
    final task = _warm(dayCount, forceRefresh);
    _windowTask = task;
    try {
      await task;
    } finally {
      _windowTask = null;
    }
  }

  Future<void> _warm(int count, bool force) async {
    final resolved = await _resolve(refresh: false, requestPermission: false);
    final profile = resolved.profile;
    final start = _today(profile.timeZoneId);
    final keys = List.generate(
      count + 1, // Include next Fajr for the final displayed Isha interval.
      (index) => PrayerTimeZoneHelper.dateKeyAfter(start, index),
    );
    await _ensureDays(profile, keys, force: force);
    await _local.upsertSyncState(
      PrayerSyncState(
        profileSignature: profile.signature,
        windowStartDateKey: start,
        windowEndDateKey: keys[count - 1],
        missingDateKeys: const [],
        lastTodaySyncAtUtc: DateTime.now().toUtc(),
        lastFullWindowSyncAtUtc: DateTime.now().toUtc(),
      ),
    );
    await _writeSnapshot(profile);
    await _local.deletePrayerDaysOutsideRange(
      profileSignature: profile.signature,
      keepFromDateKey: PrayerTimeZoneHelper.dateKeyAfter(start, -2),
      keepToDateKey: PrayerTimeZoneHelper.dateKeyAfter(start, count + 2),
    );
  }

  Future<void> _ensureDays(
    PrayerProfile profile,
    List<String> keys, {
    required bool force,
  }) async {
    final existing = force
        ? <PrayerDay>[]
        : await _local.getPrayerDaysInRange(
            profile.signature,
            keys.first,
            keys.last,
          );
    final available = existing
        .where(
          (day) => day.sourceRevision == OfflinePrayerCalculator.sourceRevision,
        )
        .map((day) => day.localDateKey)
        .toSet();
    final missing = keys.where((key) => !available.contains(key)).toList();
    if (missing.isEmpty) return;
    await _local.upsertPrayerDays(
      await _calculator.calculateDays(profile: profile, dateKeys: missing),
    );
  }

  @override
  Future<void> handleAppResumed() async {
    await _resolve(refresh: true, requestPermission: false);
    await loadDashboardData();
  }

  Future<({PrayerProfile profile, bool isFallback})> _resolve({
    required bool refresh,
    required bool requestPermission,
  }) async {
    final config = await _preferences.getCalculationConfig();
    final resolved = await _location.resolve(
      config: config,
      savedProfile: await _savedProfile(),
      refresh: refresh,
      requestPermission: requestPermission,
    );
    if (config.signatureSeed() !=
        (await _preferences.getCalculationConfig()).signatureSeed()) {
      return _resolve(refresh: false, requestPermission: false);
    }
    await _local.upsertProfile(resolved.profile);
    await _preferences.setActiveProfileSignature(resolved.profile.signature);
    return resolved;
  }

  Future<PrayerProfile?> _savedProfile() async {
    final key = await _preferences.getActiveProfileSignature();
    return key == null ? null : _local.getProfile(key);
  }

  Future<PrayerDashboardData?> _compose(
    PrayerProfile profile, {
    required bool isFallback,
  }) async {
    final todayKey = _today(profile.timeZoneId);
    final today = await _local.getPrayerDay(profile.signature, todayKey);
    if (today == null ||
        today.sourceRevision != OfflinePrayerCalculator.sourceRevision) {
      return null;
    }
    return PrayerDashboardData(
      profile: profile,
      today: today,
      tomorrow: await _local.getPrayerDay(
        profile.signature,
        PrayerTimeZoneHelper.dateKeyAfter(todayKey, 1),
      ),
      generatedAtUtc: DateTime.now().toUtc(),
      lastSuccessfulSyncAtUtc: today.fetchedAtUtc,
      isFallbackProfile: isFallback,
    );
  }

  Future<void> _writeSnapshot(PrayerProfile profile) async {
    // Never publish a calculation superseded by a settings/location change.
    if (await _preferences.getActiveProfileSignature() != profile.signature ||
        (await _preferences.getCalculationConfig()).signatureSeed() !=
            profile.calculation.signatureSeed()) {
      return;
    }
    final start = _today(profile.timeZoneId);
    final days = await _local.getPrayerDaysInRange(
      profile.signature,
      start,
      PrayerTimeZoneHelper.dateKeyAfter(start, 30),
    );
    final byDate = {for (final day in days) day.localDateKey: day};
    await _preferences.writeWidgetSnapshot(
      PrayerWidgetSnapshot(
        profileSignature: profile.signature,
        timeZoneId: profile.timeZoneId,
        locationLabel: profile.displayLocationLabel,
        generatedAtUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
        lastSuccessfulSyncAtUtcMillis: DateTime.now()
            .toUtc()
            .millisecondsSinceEpoch,
        days: [
          for (final day in days.take(30))
            PrayerWidgetDaySnapshot(
              localDateKey: day.localDateKey,
              fajrUtcMillis: day.fajrUtc.millisecondsSinceEpoch,
              sunriseUtcMillis: day.sunriseUtc.millisecondsSinceEpoch,
              dhuhrUtcMillis: day.dhuhrUtc.millisecondsSinceEpoch,
              asrUtcMillis: day.asrUtc.millisecondsSinceEpoch,
              maghribUtcMillis: day.maghribUtc.millisecondsSinceEpoch,
              ishaUtcMillis: day.ishaUtc.millisecondsSinceEpoch,
              ishaEndUtcMillis:
                  byDate[PrayerTimeZoneHelper.dateKeyAfter(day.localDateKey, 1)]
                      ?.fajrUtc
                      .millisecondsSinceEpoch,
              sehriEndUtcMillis: day.fajrUtc
                  .subtract(
                    Duration(minutes: profile.calculation.sehriOffsetMinutes),
                  )
                  .millisecondsSinceEpoch,
            ),
        ],
      ),
    );
  }

  String _today(String zone) => PrayerTimeZoneHelper.dateKey(
    tz.TZDateTime.now(PrayerTimeZoneHelper.locationFor(zone)),
  );
}

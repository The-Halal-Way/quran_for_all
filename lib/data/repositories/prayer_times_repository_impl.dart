import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/prayer_times/prayer_time_zone_helper.dart';
import '../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../datasources/local/prayer_times_local_data_source.dart';
import '../datasources/local/prayer_times_preferences_store.dart';
import '../datasources/remote/prayer_times_api_service.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  PrayerTimesRepositoryImpl({
    required PrayerTimesLocalDataSource localDataSource,
    required PrayerTimesPreferencesStore preferencesStore,
    required PrayerTimesApiService apiService,
  }) : _localDataSource = localDataSource,
       _preferencesStore = preferencesStore,
       _apiService = apiService;

  final PrayerTimesLocalDataSource _localDataSource;
  final PrayerTimesPreferencesStore _preferencesStore;
  final PrayerTimesApiService _apiService;

  Future<void>? _windowWarmTask;

  @override
  Future<PrayerDashboardData?> loadCachedDashboardData() async {
    final profile = await _loadActiveProfile();
    if (profile == null) {
      return null;
    }

    return _composeDashboardData(
      profile: profile,
      todayKey: _todayKey(profile.timeZoneId),
      isFallbackProfile: true,
    );
  }

  @override
  Future<PrayerDashboardData> loadDashboardData({
    bool forceRefresh = false,
  }) async {
    final resolved = await _resolveProfile(
      forceLocationRefresh: forceRefresh,
      requestPermissionIfNeeded: true,
    );
    final todayKey = _todayKey(resolved.profile.timeZoneId);
    final cached = await _composeDashboardData(
      profile: resolved.profile,
      todayKey: todayKey,
      isFallbackProfile: resolved.isFallbackProfile,
    );

    if (cached != null && !forceRefresh) {
      return cached;
    }

    try {
      final freshToday = await _apiService.fetchDay(
        profile: resolved.profile,
        localDateKey: todayKey,
      );
      await _localDataSource.upsertPrayerDay(freshToday);
      await _saveTodaySyncSuccess(
        profile: resolved.profile,
        todayKey: todayKey,
      );
      await _writeWidgetSnapshot(resolved.profile);

      final refreshed = await _composeDashboardData(
        profile: resolved.profile,
        todayKey: todayKey,
        isFallbackProfile: resolved.isFallbackProfile,
      );
      if (refreshed != null) {
        return refreshed;
      }
    } on PrayerTimesException {
      if (cached != null) {
        return cached.copyWith(isFallbackProfile: true);
      }
      rethrow;
    }

    if (cached != null) {
      return cached.copyWith(isFallbackProfile: true);
    }

    throw const PrayerTimesException(
      PrayerRepositoryErrorType.unavailable,
      'Prayer times are unavailable right now.',
    );
  }

  @override
  Future<void> warmUpcomingPrayerDays({
    int dayCount = 30,
    bool forceRefresh = false,
  }) {
    return _windowWarmTask ??=
        _performWarmUpcomingPrayerDays(
          dayCount: dayCount,
          forceRefresh: forceRefresh,
        ).whenComplete(() {
          _windowWarmTask = null;
        });
  }

  @override
  Future<void> handleAppResumed() async {
    await _resolveProfile(
      forceLocationRefresh: true,
      requestPermissionIfNeeded: false,
    );
    await loadDashboardData(forceRefresh: false);
    await warmUpcomingPrayerDays();
  }

  Future<void> _performWarmUpcomingPrayerDays({
    required int dayCount,
    required bool forceRefresh,
  }) async {
    final resolved = await _resolveProfile(
      forceLocationRefresh: false,
      requestPermissionIfNeeded: false,
    );
    final profile = resolved.profile;
    final location = PrayerTimeZoneHelper.locationFor(profile.timeZoneId);
    final start = _todayAtMidnight(location);
    final requiredDateKeys = List<String>.generate(
      dayCount,
      (index) => _dateKey(start.add(Duration(days: index))),
    );
    final startKey = requiredDateKeys.first;
    final endKey = requiredDateKeys.last;
    final existingDays = await _localDataSource.getPrayerDaysInRange(
      profile.signature,
      startKey,
      endKey,
    );
    final existingKeys = existingDays.map((day) => day.localDateKey).toSet();
    final missingKeys = forceRefresh
        ? requiredDateKeys
        : requiredDateKeys.where((key) => !existingKeys.contains(key)).toList();

    if (missingKeys.isEmpty) {
      await _localDataSource.upsertSyncState(
        PrayerSyncState(
          profileSignature: profile.signature,
          windowStartDateKey: startKey,
          windowEndDateKey: endKey,
          missingDateKeys: const <String>[],
          lastFullWindowSyncAtUtc: DateTime.now().toUtc(),
          lastTodaySyncAtUtc: (await _localDataSource.getSyncState(
            profile.signature,
          ))?.lastTodaySyncAtUtc,
          consecutiveFailureCount: 0,
        ),
      );
      await _writeWidgetSnapshot(profile);
      await _purgeInactiveProfiles(profile.signature);
      return;
    }

    try {
      final monthBuckets = <String, List<String>>{};
      for (final key in requiredDateKeys) {
        final date = _parseDateKey(location, key);
        final bucket = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        monthBuckets.putIfAbsent(bucket, () => <String>[]).add(key);
      }
      for (final bucket in monthBuckets.entries) {
        final parts = bucket.key.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final remoteDays = await _apiService.fetchMonth(
          profile: profile,
          year: year,
          month: month,
        );

        final monthUpserts = remoteDays
            .where(
              (day) => forceRefresh || missingKeys.contains(day.localDateKey),
            )
            .toList();
        await _localDataSource.upsertPrayerDays(monthUpserts);
      }

      final remainingMissingKeys = await _computeMissingDateKeys(
        profile.signature,
        requiredDateKeys,
        startKey,
        endKey,
      );

      await _localDataSource.upsertSyncState(
        PrayerSyncState(
          profileSignature: profile.signature,
          windowStartDateKey: startKey,
          windowEndDateKey: endKey,
          missingDateKeys: remainingMissingKeys,
          lastTodaySyncAtUtc: (await _localDataSource.getSyncState(
            profile.signature,
          ))?.lastTodaySyncAtUtc,
          lastFullWindowSyncAtUtc: remainingMissingKeys.isEmpty
              ? DateTime.now().toUtc()
              : (await _localDataSource.getSyncState(
                  profile.signature,
                ))?.lastFullWindowSyncAtUtc,
          consecutiveFailureCount: 0,
        ),
      );
      await _trimRollingWindow(profile.signature, location, start);
      await _writeWidgetSnapshot(profile);
      await _purgeInactiveProfiles(profile.signature);
    } on PrayerTimesException catch (error) {
      final syncState = await _localDataSource.getSyncState(profile.signature);
      final remainingMissingKeys = await _computeMissingDateKeys(
        profile.signature,
        requiredDateKeys,
        startKey,
        endKey,
      );
      await _localDataSource.upsertSyncState(
        PrayerSyncState(
          profileSignature: profile.signature,
          windowStartDateKey: startKey,
          windowEndDateKey: endKey,
          missingDateKeys: remainingMissingKeys,
          lastTodaySyncAtUtc: syncState?.lastTodaySyncAtUtc,
          lastFullWindowSyncAtUtc: syncState?.lastFullWindowSyncAtUtc,
          retryAfterUtc: DateTime.now().toUtc().add(const Duration(hours: 2)),
          lastErrorCode: error.type.name,
          consecutiveFailureCount:
              (syncState?.consecutiveFailureCount ?? 0) + 1,
        ),
      );
      await _writeWidgetSnapshot(profile);
      rethrow;
    }
  }

  Future<_ResolvedProfile> _resolveProfile({
    required bool forceLocationRefresh,
    required bool requestPermissionIfNeeded,
  }) async {
    PrayerTimeZoneHelper.ensureInitialized();

    final config = await _preferencesStore.getCalculationConfig();
    final activeProfile = await _loadActiveProfile();
    final timeZoneId = await FlutterTimezone.getLocalTimezone();

    if (!forceLocationRefresh &&
        activeProfile != null &&
        _canReuseActiveProfile(
          activeProfile: activeProfile,
          timeZoneId: timeZoneId,
          config: config,
        )) {
      final updated = activeProfile.copyWith(
        lastUsedAtUtc: DateTime.now().toUtc(),
      );
      await _localDataSource.upsertProfile(updated);
      await _preferencesStore.setActiveProfileSignature(updated.signature);
      return _ResolvedProfile(profile: updated, isFallbackProfile: false);
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (activeProfile != null) {
        return _ResolvedProfile(
          profile: activeProfile,
          isFallbackProfile: true,
        );
      }

      throw const PrayerTimesException(
        PrayerRepositoryErrorType.locationDisabled,
        'Location services are disabled.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermissionIfNeeded) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (activeProfile != null) {
        return _ResolvedProfile(
          profile: activeProfile,
          isFallbackProfile: true,
        );
      }

      throw const PrayerTimesException(
        PrayerRepositoryErrorType.permissionDenied,
        'Location permission denied.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      if (activeProfile != null) {
        return _ResolvedProfile(
          profile: activeProfile,
          isFallbackProfile: true,
        );
      }

      throw const PrayerTimesException(
        PrayerRepositoryErrorType.permissionDeniedForever,
        'Location permission permanently denied.',
      );
    }

    Position? position;
    if (!forceLocationRefresh) {
      position = await Geolocator.getLastKnownPosition();
    }

    position ??= await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: forceLocationRefresh
            ? LocationAccuracy.high
            : LocationAccuracy.medium,
      ),
    );

    final profile = _buildProfile(
      latitude: position.latitude,
      longitude: position.longitude,
      timeZoneId: timeZoneId,
      calculation: config,
      existingProfile: activeProfile,
    );

    await _localDataSource.upsertProfile(profile);
    await _preferencesStore.setActiveProfileSignature(profile.signature);
    return _ResolvedProfile(profile: profile, isFallbackProfile: false);
  }

  PrayerProfile _buildProfile({
    required double latitude,
    required double longitude,
    required String timeZoneId,
    required PrayerCalculationConfig calculation,
    PrayerProfile? existingProfile,
  }) {
    final latitudeBucket = _bucketCoordinate(latitude);
    final longitudeBucket = _bucketCoordinate(longitude);
    final locationIdentity = 'gps:$latitudeBucket,$longitudeBucket';
    final signature = [
      locationIdentity,
      latitudeBucket.toStringAsFixed(2),
      longitudeBucket.toStringAsFixed(2),
      timeZoneId,
      calculation.signatureSeed(),
    ].join('|');
    final nowUtc = DateTime.now().toUtc();

    if (existingProfile != null && existingProfile.signature == signature) {
      return existingProfile.copyWith(lastUsedAtUtc: nowUtc);
    }

    return PrayerProfile(
      signature: signature,
      locationIdentity: locationIdentity,
      latitude: latitude,
      longitude: longitude,
      latitudeBucket: latitudeBucket,
      longitudeBucket: longitudeBucket,
      timeZoneId: timeZoneId,
      calculation: calculation,
      displayLocationLabel:
          '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
      createdAtUtc: nowUtc,
      lastUsedAtUtc: nowUtc,
    );
  }

  bool _canReuseActiveProfile({
    required PrayerProfile activeProfile,
    required String timeZoneId,
    required PrayerCalculationConfig config,
  }) {
    return activeProfile.timeZoneId == timeZoneId &&
        activeProfile.calculation.signatureSeed() == config.signatureSeed();
  }

  Future<PrayerProfile?> _loadActiveProfile() async {
    final activeSignature = await _preferencesStore.getActiveProfileSignature();
    if (activeSignature == null || activeSignature.isEmpty) {
      return null;
    }

    return _localDataSource.getProfile(activeSignature);
  }

  Future<PrayerDashboardData?> _composeDashboardData({
    required PrayerProfile profile,
    required String todayKey,
    required bool isFallbackProfile,
  }) async {
    final today = await _localDataSource.getPrayerDay(
      profile.signature,
      todayKey,
    );
    if (today == null) {
      return null;
    }

    final tomorrowKey = _dateKey(
      _parseDateKey(
        PrayerTimeZoneHelper.locationFor(profile.timeZoneId),
        todayKey,
      ).add(const Duration(days: 1)),
    );
    final tomorrow = await _localDataSource.getPrayerDay(
      profile.signature,
      tomorrowKey,
    );
    final syncState = await _localDataSource.getSyncState(profile.signature);

    return PrayerDashboardData(
      profile: profile,
      today: today,
      tomorrow: tomorrow,
      generatedAtUtc: DateTime.now().toUtc(),
      lastSuccessfulSyncAtUtc:
          syncState?.lastFullWindowSyncAtUtc ?? syncState?.lastTodaySyncAtUtc,
      isFallbackProfile: isFallbackProfile,
      isWindowComplete: syncState?.missingDateKeys.isEmpty ?? false,
    );
  }

  Future<void> _saveTodaySyncSuccess({
    required PrayerProfile profile,
    required String todayKey,
  }) async {
    final existing = await _localDataSource.getSyncState(profile.signature);
    final location = PrayerTimeZoneHelper.locationFor(profile.timeZoneId);
    final endKey = _dateKey(
      _todayAtMidnight(location).add(const Duration(days: 29)),
    );
    await _localDataSource.upsertSyncState(
      PrayerSyncState(
        profileSignature: profile.signature,
        windowStartDateKey: existing?.windowStartDateKey ?? todayKey,
        windowEndDateKey: existing?.windowEndDateKey ?? endKey,
        missingDateKeys: existing?.missingDateKeys ?? const <String>[],
        lastTodaySyncAtUtc: DateTime.now().toUtc(),
        lastFullWindowSyncAtUtc: existing?.lastFullWindowSyncAtUtc,
        consecutiveFailureCount: 0,
      ),
    );
  }

  Future<void> _writeWidgetSnapshot(PrayerProfile profile) async {
    final startKey = _todayKey(profile.timeZoneId);
    final endKey = _dateKey(
      _parseDateKey(
        PrayerTimeZoneHelper.locationFor(profile.timeZoneId),
        startKey,
      ).add(const Duration(days: 29)),
    );
    final days = await _localDataSource.getPrayerDaysInRange(
      profile.signature,
      startKey,
      endKey,
    );
    final syncState = await _localDataSource.getSyncState(profile.signature);
    final snapshot = PrayerWidgetSnapshot(
      profileSignature: profile.signature,
      timeZoneId: profile.timeZoneId,
      locationLabel: profile.displayLocationLabel,
      generatedAtUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
      lastSuccessfulSyncAtUtcMillis:
          (syncState?.lastFullWindowSyncAtUtc ?? syncState?.lastTodaySyncAtUtc)
              ?.millisecondsSinceEpoch,
      days: days
          .map(
            (day) => PrayerWidgetDaySnapshot(
              localDateKey: day.localDateKey,
              fajrUtcMillis: day.fajrUtc.millisecondsSinceEpoch,
              sunriseUtcMillis: day.sunriseUtc.millisecondsSinceEpoch,
              dhuhrUtcMillis: day.dhuhrUtc.millisecondsSinceEpoch,
              asrUtcMillis: day.asrUtc.millisecondsSinceEpoch,
              maghribUtcMillis: day.maghribUtc.millisecondsSinceEpoch,
              ishaUtcMillis: day.ishaUtc.millisecondsSinceEpoch,
            ),
          )
          .toList(),
    );
    await _preferencesStore.writeWidgetSnapshot(snapshot);
  }

  Future<List<String>> _computeMissingDateKeys(
    String profileSignature,
    List<String> requiredDateKeys,
    String startKey,
    String endKey,
  ) async {
    final availableDays = await _localDataSource.getPrayerDaysInRange(
      profileSignature,
      startKey,
      endKey,
    );
    final availableKeys = availableDays.map((day) => day.localDateKey).toSet();
    return requiredDateKeys
        .where((dateKey) => !availableKeys.contains(dateKey))
        .toList();
  }

  Future<void> _trimRollingWindow(
    String profileSignature,
    tz.Location location,
    tz.TZDateTime start,
  ) {
    final keepFrom = _dateKey(start.subtract(const Duration(days: 2)));
    final keepTo = _dateKey(start.add(const Duration(days: 32)));
    return _localDataSource.deletePrayerDaysOutsideRange(
      profileSignature: profileSignature,
      keepFromDateKey: keepFrom,
      keepToDateKey: keepTo,
    );
  }

  Future<void> _purgeInactiveProfiles(String activeSignature) async {
    final staleProfiles = await _localDataSource.getInactiveProfilesBefore(
      DateTime.now().toUtc().subtract(const Duration(days: 14)),
      activeSignature: activeSignature,
    );
    await _localDataSource.deleteProfiles(
      staleProfiles.map((profile) => profile.signature).toList(),
    );
  }

  double _bucketCoordinate(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  String _todayKey(String timeZoneId) {
    final location = PrayerTimeZoneHelper.locationFor(timeZoneId);
    return _dateKey(_todayAtMidnight(location));
  }

  tz.TZDateTime _todayAtMidnight(tz.Location location) {
    final now = tz.TZDateTime.now(location);
    return tz.TZDateTime(location, now.year, now.month, now.day);
  }

  tz.TZDateTime _parseDateKey(tz.Location location, String dateKey) {
    final parts = dateKey.split('-');
    return tz.TZDateTime(
      location,
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class _ResolvedProfile {
  const _ResolvedProfile({
    required this.profile,
    required this.isFallbackProfile,
  });

  final PrayerProfile profile;
  final bool isFallbackProfile;
}

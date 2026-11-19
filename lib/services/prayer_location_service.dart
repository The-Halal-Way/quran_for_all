import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';

import '../core/prayer_times/prayer_time_zone_helper.dart';
import '../domain/entities/prayer_times/prayer_times_models.dart';

/// Resolves coordinates independently of the offline calculation engine.
class PrayerLocationService {
  Future<({PrayerProfile profile, bool isFallback})> resolve({
    required PrayerCalculationConfig config,
    required PrayerProfile? savedProfile,
    required bool refresh,
    required bool requestPermission,
  }) async {
    final zone = await FlutterTimezone.getLocalTimezone();
    PrayerTimeZoneHelper.locationFor(zone);
    PrayerProfile from(double latitude, double longitude) {
      final lat = double.parse(latitude.toStringAsFixed(2));
      final lon = double.parse(longitude.toStringAsFixed(2));
      final identity = 'gps:$lat,$lon';
      final now = DateTime.now().toUtc();
      return PrayerProfile(
        signature: [
          'offline:1',
          identity,
          zone,
          config.signatureSeed(),
        ].join('|'),
        locationIdentity: identity,
        latitude: latitude,
        longitude: longitude,
        latitudeBucket: lat,
        longitudeBucket: lon,
        timeZoneId: zone,
        calculation: config,
        displayLocationLabel:
            '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
        createdAtUtc: savedProfile?.createdAtUtc ?? now,
        lastUsedAtUtc: now,
      );
    }

    ({PrayerProfile profile, bool isFallback}) saved() => (
      profile: from(savedProfile!.latitude, savedProfile.longitude),
      isFallback: true,
    );
    if (!refresh && savedProfile != null) return saved();
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (savedProfile != null) return saved();
      throw const PrayerTimesException(
        PrayerRepositoryErrorType.locationDisabled,
        'Location services are disabled.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (savedProfile != null) return saved();
      throw PrayerTimesException(
        permission == LocationPermission.deniedForever
            ? PrayerRepositoryErrorType.permissionDeniedForever
            : PrayerRepositoryErrorType.permissionDenied,
        'Location permission is required for the first calculation.',
      );
    }
    try {
      final last = await Geolocator.getLastKnownPosition();
      final recent =
          last != null &&
          DateTime.now().difference(last.timestamp).abs() <
              const Duration(minutes: 30);
      final position = !refresh && recent
          ? last
          : await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                // A fresh offline fix needs GPS; balanced/network-only fixes
                // can keep returning an old city without internet access.
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 8),
              ),
            ).timeout(const Duration(seconds: 10));
      return (
        profile: from(position.latitude, position.longitude),
        isFallback: false,
      );
    } catch (_) {
      if (savedProfile != null) return saved();
      throw const PrayerTimesException(
        PrayerRepositoryErrorType.unavailable,
        'A location fix is unavailable. Enable location and try again.',
      );
    }
  }
}

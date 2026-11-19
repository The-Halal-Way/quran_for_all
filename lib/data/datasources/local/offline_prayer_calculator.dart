import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:flutter/foundation.dart';

import '../../../core/prayer_times/offline_prayer_parameters.dart';
import '../../../domain/entities/prayer_times/prayer_solar_times.dart';
import '../../../domain/entities/prayer_times/prayer_times_models.dart';

/// Pure astronomical calculation; no network, plugins, or database access.
class OfflinePrayerCalculator {
  const OfflinePrayerCalculator();

  static const sourceRevision = 'adhan_dart:2.0.1:local1';

  Future<List<PrayerDay>> calculateDays({
    required PrayerProfile profile,
    required List<String> dateKeys,
  }) => compute(_calculateDays, (profile, dateKeys));

  PrayerDay calculateDay({
    required PrayerProfile profile,
    required String localDateKey,
  }) {
    if (!profile.latitude.isFinite ||
        !profile.longitude.isFinite ||
        profile.latitude.abs() > 90 ||
        profile.longitude.abs() > 180) {
      throw const PrayerTimesException(
        PrayerRepositoryErrorType.unavailable,
        'Invalid prayer location.',
      );
    }
    final parsed = DateTime.parse(localDateKey);
    // Noon keeps the package's calendar-day arithmetic clear of DST changes.
    final date = DateTime(parsed.year, parsed.month, parsed.day, 12);
    final coordinates = adhan.Coordinates(profile.latitude, profile.longitude);
    final params = OfflinePrayerParameters.forDate(profile.calculation, date);
    try {
      adhan.PrayerTimes calculate(adhan.CalculationParameters parameters) =>
          adhan.PrayerTimes(
            date: date,
            coordinates: coordinates,
            calculationParameters: parameters,
            precision: true,
          );

      adhan.PrayerTimes times;
      var estimatedTwilight = false;
      try {
        times = calculate(params);
      } on UnsupportedError {
        // 2.0.1 converts an unattainable twilight angle (NaN) to an int
        // before applying its high-latitude rule. Obtain the real solar
        // events with 0° twilight, then apply the selected night portions.
        // If the sun itself never rises/sets this also fails: report that
        // location unavailable rather than inventing local solar events.
        times = calculate(
          params.copyWith(
            method: adhan.CalculationMethod.other,
            fajrAngle: 0,
            ishaAngle: 0,
            ishaInterval: 0,
          ),
        );
        estimatedTwilight = true;
      }
      int offset(adhan.Prayer prayer) =>
          (params.adjustments[prayer] ?? 0) +
          (params.methodAdjustments[prayer] ?? 0);
      final solar = PrayerSolarTimes(
        sunriseUtc: times.sunrise
            .subtract(Duration(minutes: offset(adhan.Prayer.sunrise)))
            .toUtc(),
        noonUtc: times.dhuhr
            .subtract(Duration(minutes: offset(adhan.Prayer.dhuhr)))
            .toUtc(),
        sunsetUtc: times.sunset.toUtc(),
      );
      var fajr = times.fajr;
      var isha = times.isha;
      if (estimatedTwilight) {
        final solarParams = params.copyWith(
          method: adhan.CalculationMethod.other,
          fajrAngle: 0,
          ishaAngle: 0,
          ishaInterval: 0,
        );
        // Use real neighbouring solar events, not the package's fajrAfter
        // or ishaBefore, which are also subject to twilight adjustments.
        final tomorrow = adhan.PrayerTimes(
          date: DateTime(date.year, date.month, date.day + 1, 12),
          coordinates: coordinates,
          calculationParameters: solarParams,
          precision: true,
        );
        final yesterday = adhan.PrayerTimes(
          date: DateTime(date.year, date.month, date.day - 1, 12),
          coordinates: coordinates,
          calculationParameters: solarParams,
          precision: true,
        );
        final eveningNight = tomorrow.sunrise
            .subtract(Duration(minutes: offset(adhan.Prayer.sunrise)))
            .difference(solar.sunsetUtc)
            .inSeconds;
        final morningNight = solar.sunriseUtc
            .difference(yesterday.sunset)
            .inSeconds;
        final portions = params.nightPortions();
        fajr = solar.sunriseUtc
            .subtract(
              Duration(
                seconds: (morningNight * portions[adhan.Prayer.fajr]!).round(),
              ),
            )
            .add(Duration(minutes: offset(adhan.Prayer.fajr)));
        isha = solar.sunsetUtc
            .add(
              Duration(
                seconds: params.ishaInterval! > 0
                    ? params.ishaInterval! * 60
                    : (eveningNight * portions[adhan.Prayer.isha]!).round(),
              ),
            )
            .add(Duration(minutes: offset(adhan.Prayer.isha)));
      }
      DateTime rounded(DateTime value) {
        final utc = value.toUtc();
        final seconds = utc.second;
        final delta = params.rounding == adhan.Rounding.up
            ? (seconds == 0 ? 0 : 60 - seconds)
            : (seconds >= 30 ? 60 - seconds : -seconds);
        return utc.add(Duration(seconds: delta));
      }

      return PrayerDay(
        profileSignature: profile.signature,
        localDateKey: localDateKey,
        timeZoneId: profile.timeZoneId,
        fajrUtc: rounded(fajr),
        sunriseUtc: rounded(times.sunrise),
        dhuhrUtc: rounded(times.dhuhr),
        asrUtc: rounded(times.asr),
        maghribUtc: rounded(times.maghrib),
        ishaUtc: rounded(isha),
        solarTimes: solar,
        usesHighLatitudeFallback: estimatedTwilight,
        fetchedAtUtc: DateTime.now().toUtc(),
        sourceRevision: sourceRevision,
      );
    } on PrayerTimesException {
      rethrow;
    } catch (_) {
      throw const PrayerTimesException(
        PrayerRepositoryErrorType.unavailable,
        'Prayer times cannot be calculated for this location and date.',
      );
    }
  }
}

List<PrayerDay> _calculateDays((PrayerProfile, List<String>) request) => [
  for (final key in request.$2)
    const OfflinePrayerCalculator().calculateDay(
      profile: request.$1,
      localDateKey: key,
    ),
];

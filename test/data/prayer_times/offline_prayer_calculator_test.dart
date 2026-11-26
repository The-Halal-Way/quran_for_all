import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/prayer_times/offline_prayer_parameters.dart';
import 'package:quran_for_all/core/prayer_times/prayer_time_zone_helper.dart';
import 'package:quran_for_all/data/datasources/local/offline_prayer_calculator.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/models/prayer_forbidden_times.dart';
import 'package:timezone/timezone.dart' as tz;

PrayerProfile profile({
  double latitude = 23.81,
  double longitude = 90.41,
  String zone = 'Asia/Dhaka',
  PrayerCalculationConfig? config,
}) => PrayerProfile(
  signature: 'offline-test',
  locationIdentity: 'test',
  latitude: latitude,
  longitude: longitude,
  latitudeBucket: latitude,
  longitudeBucket: longitude,
  timeZoneId: zone,
  calculation: config ?? PrayerCalculationConfig.defaults(),
  displayLocationLabel: 'Test',
  createdAtUtc: DateTime.utc(2026),
  lastUsedAtUtc: DateTime.utc(2026),
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('bn');
  });
  const calculator = OfflinePrayerCalculator();
  PrayerDay day(PrayerProfile p, [String key = '2026-11-19']) =>
      calculator.calculateDay(profile: p, localDateKey: key);

  test('matches published upstream Karachi winter regression times', () {
    // adhan_dart test/locations_test.dart, Karachi 2024-01-15.
    final p = profile(
      latitude: 24.8607,
      longitude: 67.0011,
      zone: 'Asia/Karachi',
      config: PrayerCalculationConfig.defaults().copyWith(
        method: PrayerCalculationMethod.karachi,
        madhab: PrayerMadhab.shafi,
      ),
    );
    final result = day(p, '2024-01-15');
    final zone = PrayerTimeZoneHelper.locationFor(p.timeZoneId);
    String hm(DateTime t) {
      final local = tz.TZDateTime.from(t, zone);
      return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    }

    expect(
      [
        result.fajrUtc,
        result.sunriseUtc,
        result.dhuhrUtc,
        result.asrUtc,
        result.maghribUtc,
        result.ishaUtc,
      ].map(hm),
      ['05:58', '07:19', '12:42', '15:44', '18:04', '19:24'],
    );
  });

  test('every exposed calculation method works for Dhaka', () {
    for (final method in PrayerCalculationMethod.values) {
      final result = day(
        profile(
          config: PrayerCalculationConfig.defaults().copyWith(method: method),
        ),
      );
      final times = [
        result.fajrUtc,
        result.sunriseUtc,
        result.dhuhrUtc,
        result.asrUtc,
        result.maghribUtc,
        result.ishaUtc,
      ];
      for (var i = 1; i < times.length; i++) {
        expect(times[i].isAfter(times[i - 1]), isTrue, reason: method.name);
      }
      expect(times.every((t) => t.isUtc), isTrue);
      expect(result.usesHighLatitudeFallback, isFalse);
      expect(result.sourceRevision, OfflinePrayerCalculator.sourceRevision);
    }
  });

  test('Hanafi changes Asr and user offsets do not move solar events', () {
    final base = day(
      profile(
        config: PrayerCalculationConfig.defaults().copyWith(
          madhab: PrayerMadhab.shafi,
        ),
      ),
    );
    final adjusted = day(
      profile(
        config: PrayerCalculationConfig.defaults().copyWith(
          madhab: PrayerMadhab.hanafi,
          adjustments: const PrayerAdjustments(
            fajr: 4,
            sunrise: -3,
            dhuhr: 8,
            maghrib: 5,
            isha: -2,
          ),
        ),
      ),
    );
    expect(adjusted.asrUtc.isAfter(base.asrUtc), isTrue);
    expect(adjusted.fajrUtc.difference(base.fajrUtc).inMinutes, 4);
    expect(adjusted.sunriseUtc.difference(base.sunriseUtc).inMinutes, -3);
    expect(adjusted.dhuhrUtc.difference(base.dhuhrUtc).inMinutes, 8);
    expect(adjusted.maghribUtc.difference(base.maghribUtc).inMinutes, 5);
    expect(adjusted.ishaUtc.difference(base.ishaUtc).inMinutes, -2);
    expect(adjusted.solarTimes!.toJson(), base.solarTimes!.toJson());
    expect(
      PrayerDay.fromMap(adjusted.toMap()).solarTimes!.toJson(),
      base.solarTimes!.toJson(),
    );
  });

  test('Umm al Qura has 120 minute Ramadan Isha and 90 outside Ramadan', () {
    final p = profile(
      latitude: 21.4225,
      longitude: 39.8262,
      zone: 'Asia/Riyadh',
      config: PrayerCalculationConfig.defaults().copyWith(
        method: PrayerCalculationMethod.ummAlQura,
      ),
    );
    for (final entry in {'2024-03-20': 120, '2024-05-20': 90}.entries) {
      final d = day(p, entry.key);
      expect(d.ishaUtc.difference(d.maghribUtc).inMinutes, entry.value);
    }
  });

  test('Malaysia maps explicitly and Singapore keeps upward rounding', () {
    final defaults = PrayerCalculationConfig.defaults();
    final malaysia = OfflinePrayerParameters.forDate(
      defaults.copyWith(method: PrayerCalculationMethod.malaysia),
      DateTime(2026),
    );
    final singapore = OfflinePrayerParameters.forDate(
      defaults.copyWith(method: PrayerCalculationMethod.singapore),
      DateTime(2026),
    );
    expect(malaysia.fajrAngle, 20);
    expect(malaysia.ishaAngle, 18);
    expect(malaysia.rounding.name, 'nearest');
    expect(singapore.rounding.name, 'up');
  });

  test(
    'local day stays correct at UTC date boundaries and fractional offsets',
    () {
      for (final p in [
        profile(latitude: -36.85, longitude: 174.76, zone: 'Pacific/Auckland'),
        profile(latitude: 21.30, longitude: -157.85, zone: 'Pacific/Honolulu'),
        profile(latitude: 27.71, longitude: 85.32, zone: 'Asia/Kathmandu'),
      ]) {
        final d = day(p, '2026-01-01');
        final local = tz.TZDateTime.from(
          d.fajrUtc,
          PrayerTimeZoneHelper.locationFor(p.timeZoneId),
        );
        expect(PrayerTimeZoneHelper.dateKey(local), '2026-01-01');
      }
    },
  );

  test('calendar-day generation crosses DST, leap days and new year', () {
    expect(PrayerTimeZoneHelper.dateKeyAfter('2026-11-01', 1), '2026-11-02');
    expect(PrayerTimeZoneHelper.dateKeyAfter('2026-03-08', 1), '2026-03-09');
    expect(PrayerTimeZoneHelper.dateKeyAfter('2024-02-28', 1), '2024-02-29');
    expect(PrayerTimeZoneHelper.dateKeyAfter('2026-12-31', 1), '2027-01-01');
    final p = profile(
      latitude: 40.71,
      longitude: -74.01,
      zone: 'America/New_York',
    );
    final zone = PrayerTimeZoneHelper.locationFor(p.timeZoneId);
    final before = tz.TZDateTime.from(day(p, '2026-03-07').dhuhrUtc, zone);
    final after = tz.TZDateTime.from(day(p, '2026-03-08').dhuhrUtc, zone);
    expect(
      after.timeZoneOffset - before.timeZoneOffset,
      const Duration(hours: 1),
    );
    expect(after.hour, before.hour + 1);
  });

  test('unattainable summer twilight uses selected high latitude rule', () {
    final p = profile(
      latitude: 51.5074,
      longitude: -0.1278,
      zone: 'Europe/London',
    );
    final d = day(p, '2026-06-21');
    expect(d.usesHighLatitudeFallback, isTrue);
    expect(d.fajrUtc.isBefore(d.sunriseUtc), isTrue);
    expect(d.ishaUtc.isAfter(d.maghribUtc), isTrue);
    expect(d.ishaUtc.difference(d.maghribUtc).inHours, lessThan(5));
  });

  test(
    'polar day and invalid coordinates fail without invented solar times',
    () {
      for (final p in [
        profile(latitude: 89, longitude: 0),
        profile(latitude: 100),
        profile(longitude: double.nan),
      ]) {
        expect(
          () => day(p, '2026-06-21'),
          throwsA(isA<PrayerTimesException>()),
        );
      }
    },
  );

  test('forbidden windows use unadjusted events and show EN/BN ranges', () {
    final d = day(profile());
    for (final language in ['en', 'bn']) {
      final l10n = lookupAppLocalizations(Locale(language));
      final items = PrayerForbiddenTimes.items(
        l10n,
        solar: d.solarTimes,
        timeZoneId: d.timeZoneId,
      );
      expect(items, hasLength(3));
      for (final item in items) {
        expect(item.timeLabel, contains(' – '));
        expect(item.timeLabel, isNot(l10n.prayerForbiddenTimeFallback));
      }
      expect(
        l10n.prayerForbiddenWindowNote,
        contains(language == 'bn' ? '২০' : '20'),
      );
      expect(
        PrayerForbiddenTimes.items(l10n).first.timeLabel,
        l10n.prayerForbiddenTimeFallback,
      );
    }
  });

  test(
    '30 day calculation runs in an isolate with all dates preserved',
    () async {
      final keys = List.generate(
        30,
        (i) => PrayerTimeZoneHelper.dateKeyAfter('2026-11-19', i),
      );
      final results = await calculator.calculateDays(
        profile: profile(),
        dateKeys: keys,
      );
      expect(results.map((d) => d.localDateKey), keys);
      expect(results.every((d) => d.solarTimes != null), isTrue);
    },
  );
}

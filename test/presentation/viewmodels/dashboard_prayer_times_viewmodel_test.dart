import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/prayer_times/prayer_time_zone_helper.dart';
import 'package:quran_for_all/domain/entities/prayer_times/prayer_times_models.dart';
import 'package:quran_for_all/domain/repositories/prayer_times_repository.dart';
import 'package:quran_for_all/domain/usecases/prayer_times/load_prayer_times_usecase.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  testWidgets(
    'saved schedule displays first and launch location refreshes in the background',
    (tester) async {
      final repository = _Repository(
        _dashboardData(6).copyWith(isFallbackProfile: true),
      );
      final model = DashboardPrayerTimesViewModel(
        loadPrayerTimesUseCase: LoadPrayerTimesUseCase(repository),
      );
      try {
        await tester.pump();
        await model.loadPrayerTimes();
        await tester.pump();
        expect(model.hasData, isTrue);
        expect(model.isLoading, isFalse);
        expect(repository.resumeCount, 1);
      } finally {
        model.dispose();
      }
    },
  );
  for (final tomorrowFajrHour in <int?>[null, 6]) {
    testWidgets(
      tomorrowFajrHour == null
          ? 'Isha ends at the next local Fajr when tomorrow is unavailable'
          : 'Isha uses the actual next-day Fajr when available',
      (tester) async {
        final data = _dashboardData(tomorrowFajrHour);
        final model = DashboardPrayerTimesViewModel(
          loadPrayerTimesUseCase: LoadPrayerTimesUseCase(_Repository(data)),
        );
        await tester.pump();
        await model.loadPrayerTimes();

        expect(
          model.prayerTimeRanges?['Isha'],
          tomorrowFajrHour == null
              ? '08:00 PM - 05:00 AM'
              : '08:00 PM - 06:00 AM',
        );
        expect(model.currentPrayerEndsAtUtc, isNotNull);
        model.dispose();
      },
    );
  }
}

PrayerDashboardData _dashboardData(int? tomorrowFajrHour) {
  final location = PrayerTimeZoneHelper.locationFor('Asia/Dhaka');
  final now = tz.TZDateTime.now(location);
  final day = tz.TZDateTime(location, now.year, now.month, now.day);
  DateTime at(int dayOffset, int hour) => tz.TZDateTime(
    location,
    day.year,
    day.month,
    day.day + dayOffset,
    hour,
  ).toUtc();

  final profile = PrayerProfile(
    signature: 'test',
    locationIdentity: 'test',
    latitude: 23.8,
    longitude: 90.4,
    latitudeBucket: 23.8,
    longitudeBucket: 90.4,
    timeZoneId: 'Asia/Dhaka',
    calculation: PrayerCalculationConfig.defaults(),
    displayLocationLabel: 'Dhaka',
    createdAtUtc: now.toUtc(),
    lastUsedAtUtc: now.toUtc(),
  );
  PrayerDay prayerDay(int dayOffset, int fajrHour) => PrayerDay(
    profileSignature: profile.signature,
    localDateKey: '${day.year}-${day.month}-${day.day + dayOffset}',
    timeZoneId: profile.timeZoneId,
    fajrUtc: at(dayOffset, fajrHour),
    sunriseUtc: at(dayOffset, 6),
    dhuhrUtc: at(dayOffset, 12),
    asrUtc: at(dayOffset, 16),
    maghribUtc: at(dayOffset, 18),
    ishaUtc: at(dayOffset, 20),
    fetchedAtUtc: now.toUtc(),
    sourceRevision: 'test',
  );

  return PrayerDashboardData(
    profile: profile,
    today: prayerDay(0, 5),
    tomorrow: tomorrowFajrHour == null ? null : prayerDay(1, tomorrowFajrHour),
    generatedAtUtc: now.toUtc(),
  );
}

class _Repository implements PrayerTimesRepository {
  _Repository(this.data);

  final PrayerDashboardData data;
  int resumeCount = 0;

  @override
  Future<PrayerDashboardData?> loadCachedDashboardData() async => data;

  @override
  Future<PrayerDashboardData> loadDashboardData({
    bool forceRefresh = false,
  }) async => data;

  @override
  Future<void> handleAppResumed() async {
    resumeCount++;
  }

  @override
  Future<void> warmUpcomingPrayerDays({
    int dayCount = 30,
    bool forceRefresh = false,
  }) async {}
}

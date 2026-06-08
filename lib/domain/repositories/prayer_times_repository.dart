import '../entities/prayer_times/prayer_times_models.dart';

abstract class PrayerTimesRepository {
  Future<PrayerDashboardData?> loadCachedDashboardData();

  Future<PrayerDashboardData> loadDashboardData({bool forceRefresh = false});

  Future<void> warmUpcomingPrayerDays({
    int dayCount = 30,
    bool forceRefresh = false,
  });

  Future<void> handleAppResumed();
}

import '../../entities/prayer_times/prayer_times_models.dart';
import '../../repositories/prayer_times_repository.dart';

class LoadPrayerTimesUseCase {
  const LoadPrayerTimesUseCase(this._repository);

  final PrayerTimesRepository _repository;

  Future<PrayerDashboardData?> loadCached() {
    return _repository.loadCachedDashboardData();
  }

  Future<PrayerDashboardData> syncToday({bool forceRefresh = false}) {
    return _repository.loadDashboardData(forceRefresh: forceRefresh);
  }

  Future<PrayerDashboardData?> warmUpcoming({
    int dayCount = 30,
    bool forceRefresh = false,
  }) async {
    await _repository.warmUpcomingPrayerDays(
      dayCount: dayCount,
      forceRefresh: forceRefresh,
    );
    return _repository.loadCachedDashboardData();
  }

  Future<PrayerDashboardData?> refreshAfterResume() async {
    await _repository.handleAppResumed();
    return _repository.loadCachedDashboardData();
  }
}

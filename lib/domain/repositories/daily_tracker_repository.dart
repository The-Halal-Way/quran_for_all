import '../../data/models/daily_task_model.dart';

/// Persists Daily Tracker completion state across app sessions.
abstract class DailyTrackerRepository {
  /// Loads the persisted progress for every task, keyed by task id.
  Future<Map<String, DailyTaskProgress>> loadProgress();

  /// Persists the progress map for every task, keyed by task id.
  Future<void> saveProgress(Map<String, DailyTaskProgress> progress);
}

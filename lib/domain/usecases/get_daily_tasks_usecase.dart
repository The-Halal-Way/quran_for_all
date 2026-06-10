import '../../data/datasources/daily_tasks_data.dart';
import '../../data/models/daily_task_model.dart';
import '../repositories/daily_tracker_repository.dart';

/// Builds today's checklist by combining the static task definitions with
/// the persisted progress, applying the daily reset rule along the way:
/// a task is only considered completed if it was last completed today.
class GetDailyTasksUseCase {
  GetDailyTasksUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<List<DailyTask>> call({DateTime? now}) async {
    final today = now ?? DateTime.now();
    final tasks = DailyTasksData.tasksForDate(today);
    final progress = await _repository.loadProgress();

    return tasks.map((task) {
      final entry = progress[task.id];
      final completedToday =
          entry != null &&
          entry.isCompleted &&
          _isSameDate(entry.lastCompletedDate, today);

      return task.copyWith(
        isCompletedToday: completedToday,
        lastCompletedDate: entry?.lastCompletedDate,
      );
    }).toList();
  }

  bool _isSameDate(DateTime? date, DateTime today) {
    if (date == null) {
      return false;
    }
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}

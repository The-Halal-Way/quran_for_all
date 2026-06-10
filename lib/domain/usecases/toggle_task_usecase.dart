import '../../data/models/daily_task_model.dart';
import '../repositories/daily_tracker_repository.dart';

/// Marks a Daily Tracker task as done or undone and persists the change.
class ToggleTaskUseCase {
  ToggleTaskUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<void> call({
    required String taskId,
    required bool isCompleted,
    DateTime? now,
  }) async {
    final progress = await _repository.loadProgress();
    progress[taskId] = DailyTaskProgress(
      isCompleted: isCompleted,
      lastCompletedDate: now ?? DateTime.now(),
    );
    await _repository.saveProgress(progress);
  }
}

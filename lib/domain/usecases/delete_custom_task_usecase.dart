import '../repositories/daily_tracker_repository.dart';

/// Removes a user-defined Daily Tracker task and its completion progress.
class DeleteCustomTaskUseCase {
  DeleteCustomTaskUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<void> call({required String taskId}) async {
    final tasks = await _repository.loadCustomTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _repository.saveCustomTasks(tasks);

    final progress = await _repository.loadProgress();
    if (progress.remove(taskId) != null) {
      await _repository.saveProgress(progress);
    }
  }
}

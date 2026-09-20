import '../repositories/daily_tracker_repository.dart';

/// Persists the user-selected order of custom Daily Tracker tasks.
class ReorderCustomTasksUseCase {
  ReorderCustomTasksUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<void> call({required List<String> orderedTaskIds}) async {
    final tasks = await _repository.loadCustomTasks();
    final tasksById = {for (final task in tasks) task.id: task};
    final reorderedTasks = [
      for (final id in orderedTaskIds) ?tasksById.remove(id),
      ...tasksById.values,
    ];
    await _repository.saveCustomTasks(reorderedTasks);
  }
}

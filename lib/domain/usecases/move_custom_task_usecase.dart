import '../../core/enums/task_category.dart';
import '../repositories/daily_tracker_repository.dart';

/// Moves a user task while keeping its id, order, and completion history.
class MoveCustomTaskUseCase {
  MoveCustomTaskUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<void> call({
    required String taskId,
    required TaskCategory category,
  }) async {
    final tasks = await _repository.loadCustomTasks();
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index == -1 || tasks[index].category == category) return;
    tasks[index] = tasks[index].copyWith(
      category: category,
      isUserCreated: true,
    );
    await _repository.saveCustomTasks(tasks);
  }
}

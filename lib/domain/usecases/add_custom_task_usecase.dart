import '../../core/enums/task_category.dart';
import '../../data/models/daily_task_model.dart';
import '../repositories/daily_tracker_repository.dart';

/// Creates a user-defined Daily Tracker task and persists it.
class AddCustomTaskUseCase {
  AddCustomTaskUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<void> call({
    required String title,
    String subtitle = '',
    bool isOptional = false,
    String? stableId,
  }) async {
    final tasks = await _repository.loadCustomTasks();
    final id = stableId == null ? null : 'reminder_$stableId';
    if (id != null && tasks.any((task) => task.id == id)) {
      return;
    }
    final task = DailyTask(
      id: id ?? 'custom_${DateTime.now().microsecondsSinceEpoch}',
      titleEn: title,
      titleBn: subtitle,
      category: TaskCategory.custom,
      isOptional: isOptional,
    );

    await _repository.saveCustomTasks([...tasks, task]);
  }
}

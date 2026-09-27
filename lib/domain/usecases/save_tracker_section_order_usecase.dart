import '../../core/enums/task_category.dart';
import '../../core/utils/task_category_order.dart';
import '../repositories/daily_tracker_repository.dart';

class SaveTrackerSectionOrderUseCase {
  SaveTrackerSectionOrderUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<void> call(List<TaskCategory> order) =>
      _repository.saveSectionOrder(completeTaskCategoryOrder(order));
}

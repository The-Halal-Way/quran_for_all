import '../../core/enums/task_category.dart';
import '../../core/utils/task_category_order.dart';
import '../repositories/daily_tracker_repository.dart';

class GetTrackerSectionOrderUseCase {
  GetTrackerSectionOrderUseCase(this._repository);

  final DailyTrackerRepository _repository;

  Future<List<TaskCategory>> call() async =>
      completeTaskCategoryOrder(await _repository.loadSectionOrder());
}

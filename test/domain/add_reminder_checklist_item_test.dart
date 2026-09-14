import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/daily_task_model.dart';
import 'package:quran_for_all/domain/repositories/daily_tracker_repository.dart';
import 'package:quran_for_all/domain/usecases/add_custom_task_usecase.dart';

void main() {
  test('reminder checklist addition is idempotent by content ID', () async {
    final repository = _MemoryTrackerRepository();
    final useCase = AddCustomTaskUseCase(repository);
    await useCase(title: 'One small action', stableId: 'dr-0042');
    await useCase(title: 'One small action', stableId: 'dr-0042');
    expect(await repository.loadCustomTasks(), hasLength(1));
    expect((await repository.loadCustomTasks()).single.id, 'reminder_dr-0042');
  });
}

class _MemoryTrackerRepository implements DailyTrackerRepository {
  List<DailyTask> tasks = [];

  @override
  Future<List<DailyTask>> loadCustomTasks() async => [...tasks];

  @override
  Future<Map<String, DailyTaskProgress>> loadProgress() async => {};

  @override
  Future<void> saveCustomTasks(List<DailyTask> tasks) async {
    this.tasks = [...tasks];
  }

  @override
  Future<void> saveProgress(Map<String, DailyTaskProgress> progress) async {}
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/core/enums/task_category.dart';
import 'package:quran_for_all/data/repositories/daily_tracker_repository_impl.dart';
import 'package:quran_for_all/domain/usecases/add_custom_task_usecase.dart';
import 'package:quran_for_all/domain/usecases/delete_custom_task_usecase.dart';
import 'package:quran_for_all/domain/usecases/get_daily_tasks_usecase.dart';
import 'package:quran_for_all/domain/usecases/get_tracker_section_order_usecase.dart';
import 'package:quran_for_all/domain/usecases/move_custom_task_usecase.dart';
import 'package:quran_for_all/domain/usecases/save_tracker_section_order_usecase.dart';
import 'package:quran_for_all/domain/usecases/toggle_task_usecase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'default section is My Tasks; selected sections persist on reload',
    () async {
      final repository = DailyTrackerRepositoryImpl();
      final addTask = AddCustomTaskUseCase(repository);
      await addTask(title: 'Personal habit');
      await addTask(
        title: 'Read tafsir',
        subtitle: 'Ten pages',
        category: TaskCategory.quran,
      );

      final tasks = await DailyTrackerRepositoryImpl().loadCustomTasks();
      expect(tasks.first.category, TaskCategory.custom);
      expect(tasks.last.category, TaskCategory.quran);
      expect(tasks.every((task) => task.isUserCreated), isTrue);
      expect(tasks.last.titleBn, 'Ten pages');
    },
  );

  test('legacy tasks and saved completion history remain intact', () async {
    SharedPreferences.setMockInitialValues({
      'daily_tracker_custom_tasks': jsonEncode([
        {
          'id': 'custom_old',
          'titleEn': 'An old habit',
          'titleBn': 'A note',
          'category': 'custom',
        },
      ]),
      'daily_tracker_progress': jsonEncode({
        'custom_old': {
          'isCompleted': true,
          'lastCompletedDate': '2026-09-27T10:00:00.000',
        },
      }),
    });
    final repository = DailyTrackerRepositoryImpl();
    final tasks = await GetDailyTasksUseCase(repository)(
      now: DateTime(2026, 9, 27),
    );
    final legacy = tasks.singleWhere((task) => task.id == 'custom_old');
    expect(legacy.isUserCreated, isTrue);
    expect(legacy.isCompletedToday, isTrue);
    expect(legacy.titleBn, 'A note');
    expect(legacy.category, TaskCategory.custom);
    expect(
      await GetTrackerSectionOrderUseCase(repository)(),
      TaskCategory.values,
    );
  });

  test('moving a task preserves its ID, content, flags and progress', () async {
    final repository = DailyTrackerRepositoryImpl();
    await AddCustomTaskUseCase(repository)(
      title: 'Read tafsir',
      subtitle: 'Ten pages',
      isOptional: true,
    );
    final id = (await repository.loadCustomTasks()).single.id;
    await ToggleTaskUseCase(repository)(
      taskId: id,
      isCompleted: true,
      now: DateTime(2026, 9, 27),
    );
    await MoveCustomTaskUseCase(repository)(
      taskId: id,
      category: TaskCategory.quran,
    );

    final tasks = await GetDailyTasksUseCase(DailyTrackerRepositoryImpl())(
      now: DateTime(2026, 9, 27),
    );
    final moved = tasks.singleWhere((task) => task.id == id);
    expect(moved.category, TaskCategory.quran);
    expect(moved.titleEn, 'Read tafsir');
    expect(moved.titleBn, 'Ten pages');
    expect(moved.isUserCreated, isTrue);
    expect(moved.isOptional, isTrue);
    expect(moved.isCompletedToday, isTrue);
    expect(
      tasks.where((task) => task.id == 'quran_page').single.isUserCreated,
      isFalse,
    );

    final nextDay = await GetDailyTasksUseCase(repository)(
      now: DateTime(2026, 9, 28),
    );
    expect(
      nextDay.singleWhere((task) => task.id == id).isCompletedToday,
      isFalse,
    );
    expect(
      nextDay.singleWhere((task) => task.id == id).category,
      TaskCategory.quran,
    );
  });

  test(
    'section order survives app reloads and normalizes unknown/duplicate codes',
    () async {
      SharedPreferences.setMockInitialValues({
        'daily_tracker_section_order': [
          'custom',
          'unknown',
          'prayer',
          'custom',
          'nafl',
        ],
      });
      final repository = DailyTrackerRepositoryImpl();
      final order = await GetTrackerSectionOrderUseCase(repository)();
      expect(order.take(3), [
        TaskCategory.custom,
        TaskCategory.prayer,
        TaskCategory.nafl,
      ]);
      expect(order, hasLength(TaskCategory.values.length));
      expect(order.toSet(), TaskCategory.values.toSet());
      await SaveTrackerSectionOrderUseCase(repository)(order.reversed.toList());
      expect(
        await GetTrackerSectionOrderUseCase(DailyTrackerRepositoryImpl())(),
        order.reversed,
      );
      expect(await repository.loadProgress(), isEmpty);
    },
  );

  test(
    'built-in task progress cannot be removed by custom task actions',
    () async {
      final repository = DailyTrackerRepositoryImpl();
      await ToggleTaskUseCase(repository)(taskId: 'fajr', isCompleted: true);
      await DeleteCustomTaskUseCase(repository)(taskId: 'fajr');
      await MoveCustomTaskUseCase(repository)(
        taskId: 'fajr',
        category: TaskCategory.custom,
      );
      expect((await repository.loadProgress())['fajr']!.isCompleted, isTrue);
      expect(await repository.loadCustomTasks(), isEmpty);
    },
  );
}

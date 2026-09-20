import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/enums/task_category.dart';
import '../../../data/models/daily_task_model.dart';
import '../../../domain/usecases/add_custom_task_usecase.dart';
import '../../../domain/usecases/delete_custom_task_usecase.dart';
import '../../../domain/usecases/get_daily_tasks_usecase.dart';
import '../../../domain/usecases/reorder_custom_tasks_usecase.dart';
import '../../../domain/usecases/toggle_task_usecase.dart';

/// Holds the state of today's Daily Tracker checklist: the task list,
/// loading state, and whether the completion celebration should be shown.
class DailyTrackerViewModel extends ChangeNotifier {
  DailyTrackerViewModel({
    required GetDailyTasksUseCase getDailyTasksUseCase,
    required ToggleTaskUseCase toggleTaskUseCase,
    required AddCustomTaskUseCase addCustomTaskUseCase,
    required DeleteCustomTaskUseCase deleteCustomTaskUseCase,
    required ReorderCustomTasksUseCase reorderCustomTasksUseCase,
  }) : _getDailyTasksUseCase = getDailyTasksUseCase,
       _toggleTaskUseCase = toggleTaskUseCase,
       _addCustomTaskUseCase = addCustomTaskUseCase,
       _deleteCustomTaskUseCase = deleteCustomTaskUseCase,
       _reorderCustomTasksUseCase = reorderCustomTasksUseCase {
    unawaited(loadTasks());
  }

  final GetDailyTasksUseCase _getDailyTasksUseCase;
  final ToggleTaskUseCase _toggleTaskUseCase;
  final AddCustomTaskUseCase _addCustomTaskUseCase;
  final DeleteCustomTaskUseCase _deleteCustomTaskUseCase;
  final ReorderCustomTasksUseCase _reorderCustomTasksUseCase;

  List<DailyTask> _tasks = [];
  bool _isLoading = false;
  bool _showCelebration = false;

  List<DailyTask> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  bool get showCelebration => _showCelebration;
  bool get isFriday => DateTime.now().weekday == DateTime.friday;

  int get totalTasks => _tasks.length;
  int get completedTasks =>
      _tasks.where((task) => task.isCompletedToday).length;

  int get totalRequiredTasks => _tasks.where((task) => !task.isOptional).length;
  int get completedRequiredTasks =>
      _tasks.where((task) => !task.isOptional && task.isCompletedToday).length;

  double get progress => totalTasks == 0 ? 0 : completedTasks / totalTasks;

  /// Tasks grouped by category, preserving the checklist order.
  Map<TaskCategory, List<DailyTask>> get groupedTasks {
    final grouped = <TaskCategory, List<DailyTask>>{};
    for (final task in _tasks) {
      grouped.putIfAbsent(task.category, () => []).add(task);
    }
    return grouped;
  }

  /// Loads (or reloads) today's checklist, applying the daily reset rule.
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _getDailyTasksUseCase();

    _isLoading = false;
    notifyListeners();
  }

  /// Flips the completion state of [taskId] and persists the change. If
  /// this completes every non-optional task, the celebration overlay is
  /// triggered.
  Future<void> toggleTask(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final task = _tasks[index];
    final now = DateTime.now();
    final isCompleted = !task.isCompletedToday;

    _tasks[index] = task.copyWith(
      isCompletedToday: isCompleted,
      lastCompletedDate: now,
    );
    notifyListeners();

    await _toggleTaskUseCase(
      taskId: taskId,
      isCompleted: isCompleted,
      now: now,
    );

    if (isCompleted &&
        totalRequiredTasks > 0 &&
        completedRequiredTasks == totalRequiredTasks) {
      _showCelebration = true;
      notifyListeners();
    }
  }

  /// Creates a new custom task and reloads the checklist.
  Future<void> addCustomTask({
    required String title,
    String subtitle = '',
    bool isOptional = false,
  }) async {
    await _addCustomTaskUseCase(
      title: title,
      subtitle: subtitle,
      isOptional: isOptional,
    );
    await loadTasks();
  }

  /// Adds a reminder action once, keyed by its stable content ID.
  Future<void> addReminderTask({
    required String contentId,
    required String title,
    String alternateLocaleTitle = '',
  }) async {
    await _addCustomTaskUseCase(
      title: title,
      subtitle: alternateLocaleTitle,
      isOptional: true,
      stableId: contentId,
    );
    await loadTasks();
  }

  /// Deletes a custom task (and its saved progress) and reloads the
  /// checklist.
  Future<void> deleteCustomTask(String taskId) async {
    await _deleteCustomTaskUseCase(taskId: taskId);
    await loadTasks();
  }

  /// Reorders user-created tasks and persists the resulting order.
  Future<void> reorderCustomTask(int oldIndex, int newIndex) async {
    final customTasks = _tasks
        .where((task) => task.category == TaskCategory.custom)
        .toList();
    if (oldIndex < 0 || oldIndex >= customTasks.length) {
      return;
    }

    var insertionIndex = newIndex;
    if (oldIndex < insertionIndex) {
      insertionIndex--;
    }
    insertionIndex = insertionIndex.clamp(0, customTasks.length - 1);
    if (oldIndex == insertionIndex) {
      return;
    }

    final previousTasks = List<DailyTask>.of(_tasks);
    final movedTask = customTasks.removeAt(oldIndex);
    customTasks.insert(insertionIndex, movedTask);

    var customIndex = 0;
    _tasks = [
      for (final task in _tasks)
        if (task.category == TaskCategory.custom)
          customTasks[customIndex++]
        else
          task,
    ];
    notifyListeners();

    try {
      await _reorderCustomTasksUseCase(
        orderedTaskIds: customTasks.map((task) => task.id).toList(),
      );
    } catch (_) {
      _tasks = previousTasks;
      notifyListeners();
      rethrow;
    }
  }

  /// Hides the completion celebration overlay.
  void dismissCelebration() {
    if (!_showCelebration) {
      return;
    }
    _showCelebration = false;
    notifyListeners();
  }
}

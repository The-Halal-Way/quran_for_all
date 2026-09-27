import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/enums/task_category.dart';
import '../../core/utils/task_category_order.dart';
import '../../domain/repositories/daily_tracker_repository.dart';
import '../models/daily_task_model.dart';

class DailyTrackerRepositoryImpl implements DailyTrackerRepository {
  static const _keyProgress = 'daily_tracker_progress';
  static const _keyCustomTasks = 'daily_tracker_custom_tasks';
  static const _keySectionOrder = 'daily_tracker_section_order';

  @override
  Future<Map<String, DailyTaskProgress>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProgress);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (id, value) => MapEntry(
        id,
        DailyTaskProgress.fromMap(value as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveProgress(Map<String, DailyTaskProgress> progress) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      progress.map((id, entry) => MapEntry(id, entry.toMap())),
    );
    await prefs.setString(_keyProgress, encoded);
  }

  @override
  Future<List<DailyTask>> loadCustomTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCustomTasks);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => DailyTask.fromMap(entry as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveCustomTasks(List<DailyTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((task) => task.toMap()).toList());
    if (!await prefs.setString(_keyCustomTasks, encoded)) {
      throw StateError('Could not save tracker tasks');
    }
  }

  @override
  Future<List<TaskCategory>> loadSectionOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_keySectionOrder) ?? [];
    final byCode = {
      for (final category in TaskCategory.values) category.code: category,
    };
    return completeTaskCategoryOrder([for (final code in codes) ?byCode[code]]);
  }

  @override
  Future<void> saveSectionOrder(List<TaskCategory> order) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = completeTaskCategoryOrder(
      order,
    ).map((category) => category.code).toList();
    if (!await prefs.setStringList(_keySectionOrder, codes)) {
      throw StateError('Could not save tracker section order');
    }
  }
}

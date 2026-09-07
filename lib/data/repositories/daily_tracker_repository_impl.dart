import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/daily_tracker_repository.dart';
import '../models/daily_task_model.dart';

class DailyTrackerRepositoryImpl implements DailyTrackerRepository {
  static const _keyProgress = 'daily_tracker_progress';
  static const _keyCustomTasks = 'daily_tracker_custom_tasks';

  @override
  Future<Map<String, DailyTaskProgress>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProgress);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (id, value) =>
          MapEntry(id, DailyTaskProgress.fromMap(value as Map<String, dynamic>)),
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
    await prefs.setString(_keyCustomTasks, encoded);
  }
}

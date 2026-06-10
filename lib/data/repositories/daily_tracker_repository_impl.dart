import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/daily_tracker_repository.dart';
import '../models/daily_task_model.dart';

class DailyTrackerRepositoryImpl implements DailyTrackerRepository {
  static const _keyProgress = 'daily_tracker_progress';

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
}

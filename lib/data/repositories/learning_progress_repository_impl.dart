import 'package:shared_preferences/shared_preferences.dart';

import '../models/learning_progress.dart';
import '../../domain/repositories/learning_progress_repository.dart';

class LearningProgressRepositoryImpl implements LearningProgressRepository {
  static const _keyCompletedLessons = 'learning_completed_lessons';
  static const _keyStreakDays = 'learning_streak_days';
  static const _keyLastActiveDate = 'learning_last_active_date';

  @override
  Future<LearningProgress> getProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final completedLessons =
        prefs.getStringList(_keyCompletedLessons) ?? const <String>[];
    final streakDays = prefs.getInt(_keyStreakDays) ?? 0;
    final lastActiveDateRaw = prefs.getString(_keyLastActiveDate);

    return LearningProgress(
      completedLessonIds: completedLessons.toSet(),
      currentStreakDays: streakDays,
      lastActiveDate: lastActiveDateRaw == null
          ? null
          : DateTime.tryParse(lastActiveDateRaw),
    );
  }

  @override
  Future<void> saveProgress(LearningProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = progress.completedLessonIds.toList(growable: false)
      ..sort();

    await prefs.setStringList(_keyCompletedLessons, completed);
    await prefs.setInt(_keyStreakDays, progress.currentStreakDays);

    final lastActiveDate = progress.lastActiveDate;
    if (lastActiveDate == null) {
      await prefs.remove(_keyLastActiveDate);
      return;
    }

    await prefs.setString(_keyLastActiveDate, lastActiveDate.toIso8601String());
  }
}

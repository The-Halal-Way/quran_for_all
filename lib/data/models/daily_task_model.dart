import '../../core/enums/task_category.dart';

/// A single checklist item inside the Daily Tracker.
class DailyTask {
  const DailyTask({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.category,
    this.isOptional = false,
    this.isFridayOnly = false,
    this.isCompletedToday = false,
    this.lastCompletedDate,
  });

  final String id;
  final String titleEn;
  final String titleBn;
  final TaskCategory category;

  /// True for nafl prayers and other non-mandatory acts.
  final bool isOptional;

  /// True for tasks that are only part of the routine on Fridays.
  final bool isFridayOnly;

  /// Whether this task has already been completed for the current day.
  final bool isCompletedToday;

  /// The date the task was last marked complete, used for the daily reset.
  final DateTime? lastCompletedDate;

  /// Returns the task title for the given locale code (`en` or `bn`).
  String localizedTitle(String localeCode) =>
      localeCode.startsWith('bn') ? titleBn : titleEn;

  DailyTask copyWith({bool? isCompletedToday, DateTime? lastCompletedDate}) {
    return DailyTask(
      id: id,
      titleEn: titleEn,
      titleBn: titleBn,
      category: category,
      isOptional: isOptional,
      isFridayOnly: isFridayOnly,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}

/// Persisted completion state for a single [DailyTask].
class DailyTaskProgress {
  const DailyTaskProgress({required this.isCompleted, this.lastCompletedDate});

  final bool isCompleted;
  final DateTime? lastCompletedDate;

  factory DailyTaskProgress.fromMap(Map<String, dynamic> map) {
    final rawDate = map['lastCompletedDate'] as String?;
    return DailyTaskProgress(
      isCompleted: map['isCompleted'] as bool? ?? false,
      lastCompletedDate: rawDate != null ? DateTime.tryParse(rawDate) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isCompleted': isCompleted,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    };
  }
}

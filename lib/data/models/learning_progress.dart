class LearningProgress {
  const LearningProgress({
    required this.completedLessonIds,
    required this.currentStreakDays,
    this.lastActiveDate,
  });

  final Set<String> completedLessonIds;
  final int currentStreakDays;
  final DateTime? lastActiveDate;

  factory LearningProgress.initial() {
    return const LearningProgress(
      completedLessonIds: <String>{},
      currentStreakDays: 0,
    );
  }

  LearningProgress copyWith({
    Set<String>? completedLessonIds,
    int? currentStreakDays,
    DateTime? lastActiveDate,
  }) {
    return LearningProgress(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}

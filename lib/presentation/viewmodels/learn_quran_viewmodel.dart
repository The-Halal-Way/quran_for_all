import 'package:flutter/foundation.dart';

import '../../data/models/learn_quran_content.dart';
import '../../data/models/learning_progress.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/learning_progress_repository.dart';
import '../../domain/repositories/quran_repository.dart';

class LearnQuranViewModel extends ChangeNotifier {
  LearnQuranViewModel({
    required LearningProgressRepository progressRepository,
    required QuranRepository quranRepository,
    required AudioRepository audioRepository,
  }) : _progressRepository = progressRepository,
       _quranRepository = quranRepository,
       _audioRepository = audioRepository;

  final LearningProgressRepository _progressRepository;
  final QuranRepository _quranRepository;
  final AudioRepository _audioRepository;

  bool _isLoading = true;
  String? _errorMessage;
  LearningProgress _progress = LearningProgress.initial();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<LearnQuranModule> get modules => LearnQuranContent.modules;

  int get totalLessonCount => LearnQuranContent.totalLessonCount;
  int get completedLessonCount => _progress.completedLessonIds.length;
  int get streakDays => _progress.currentStreakDays;
  int get completedModuleCount {
    var count = 0;
    for (final module in modules) {
      if (isModuleComplete(module)) {
        count++;
      }
    }
    return count;
  }

  double get overallProgress {
    if (totalLessonCount == 0) {
      return 0;
    }
    return completedLessonCount / totalLessonCount;
  }

  LearnQuranLesson? get nextLesson {
    for (final module in modules) {
      for (final lesson in module.lessons) {
        if (!_progress.completedLessonIds.contains(lesson.id)) {
          return lesson;
        }
      }
    }
    return null;
  }

  LearnQuranModule? moduleForLesson(String lessonId) {
    for (final module in modules) {
      for (final lesson in module.lessons) {
        if (lesson.id == lessonId) {
          return module;
        }
      }
    }
    return null;
  }

  bool isLessonCompleted(String lessonId) {
    return _progress.completedLessonIds.contains(lessonId);
  }

  bool isModuleComplete(LearnQuranModule module) {
    return completedLessonCountFor(module) == module.lessons.length;
  }

  int completedLessonCountFor(LearnQuranModule module) {
    var count = 0;
    for (final lesson in module.lessons) {
      if (_progress.completedLessonIds.contains(lesson.id)) {
        count++;
      }
    }
    return count;
  }

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final persistedProgress = await _progressRepository.getProgress();
      final validIds = LearnQuranContent.allLessonIds;
      final filteredCompletedIds = persistedProgress.completedLessonIds
          .intersection(validIds);

      _progress = persistedProgress.copyWith(
        completedLessonIds: filteredCompletedIds,
      );

      if (filteredCompletedIds.length !=
          persistedProgress.completedLessonIds.length) {
        await _progressRepository.saveProgress(_progress);
      }
    } catch (_) {
      _errorMessage = 'Unable to load learning progress right now.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLessonCompletion({
    required LearnQuranLesson lesson,
    required bool isCompleted,
  }) async {
    final updatedLessons = Set<String>.from(_progress.completedLessonIds);

    if (isCompleted) {
      updatedLessons.add(lesson.id);
    } else {
      updatedLessons.remove(lesson.id);
    }

    final now = DateTime.now();
    final updatedProgress = _progress.copyWith(
      completedLessonIds: updatedLessons,
      currentStreakDays: isCompleted
          ? _calculateUpdatedStreak(
              now: now,
              previousDate: _progress.lastActiveDate,
              previousStreak: _progress.currentStreakDays,
            )
          : _progress.currentStreakDays,
      lastActiveDate: isCompleted ? now : _progress.lastActiveDate,
    );

    _progress = updatedProgress;
    _errorMessage = null;
    notifyListeners();

    try {
      await _progressRepository.saveProgress(updatedProgress);
    } catch (_) {
      _errorMessage = 'Unable to save progress. Please try again.';
      notifyListeners();
    }
  }

  Future<String?> playLessonAudio(LearnQuranLesson lesson) async {
    if (!lesson.hasAudioSample) {
      return 'No audio sample is attached to this lesson yet.';
    }

    final surahId = lesson.sampleSurahId!;
    final ayahNumber = lesson.sampleAyahNumber!;

    try {
      final ayah = await _quranRepository.getAyah(surahId, ayahNumber);
      if (ayah == null) {
        return 'Could not find the sample ayah audio for this lesson.';
      }

      await _audioRepository.playAyah(ayah);
      return null;
    } catch (_) {
      return 'Unable to play lesson audio right now.';
    }
  }

  int _calculateUpdatedStreak({
    required DateTime now,
    required DateTime? previousDate,
    required int previousStreak,
  }) {
    final today = DateTime(now.year, now.month, now.day);

    if (previousDate == null) {
      return 1;
    }

    final normalizedPrevious = DateTime(
      previousDate.year,
      previousDate.month,
      previousDate.day,
    );

    final dayGap = today.difference(normalizedPrevious).inDays;
    if (dayGap <= 0) {
      return previousStreak == 0 ? 1 : previousStreak;
    }

    if (dayGap == 1) {
      return previousStreak + 1;
    }

    return 1;
  }
}

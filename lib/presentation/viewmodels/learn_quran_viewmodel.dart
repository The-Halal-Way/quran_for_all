import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/enums/playback_source.dart';
import '../../core/localization/learn_quran_message_localizer.dart';
import '../../data/models/learn_quran_content.dart';
import '../../data/models/learning_progress.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/learning_progress_repository.dart';
import '../../services/lesson_audio_sample_resolver.dart';
import 'audio_control_viewmodel.dart';

class LearnQuranViewModel extends ChangeNotifier {
  LearnQuranViewModel({
    required LearningProgressRepository progressRepository,
    required LessonAudioSampleResolver audioSampleResolver,
    required AudioRepository audioRepository,
    required AudioControlViewModel audioControlViewModel,
  }) : _progressRepository = progressRepository,
       _audioSamples = audioSampleResolver,
       _audioRepository = audioRepository,
       _audioControl = audioControlViewModel {
    _audioPlaybackSubscription = _audioRepository.isPlayingStream.listen((
      isPlaying,
    ) {
      if (_playingLessonId == null) {
        return;
      }

      if (_isLessonAudioPlaying == isPlaying) {
        return;
      }

      _isLessonAudioPlaying = isPlaying;
      if (isPlaying) _loadingLessonId = null;
      if (!isPlaying) {
        _playingLessonId = null;
      }
      notifyListeners();
    });
  }

  final LearningProgressRepository _progressRepository;
  final LessonAudioSampleResolver _audioSamples;
  final AudioRepository _audioRepository;
  final AudioControlViewModel _audioControl;
  late final StreamSubscription<bool> _audioPlaybackSubscription;

  bool _isLoading = true;
  String? _errorMessageKey;
  LearningProgress _progress = LearningProgress.initial();
  bool _isLessonAudioPlaying = false;
  String? _playingLessonId;
  String? _loadingLessonId;
  int _audioRequest = 0;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  String? get errorMessageKey => _errorMessageKey;
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

  bool isAudioRunningForLesson(String lessonId) {
    final trackedState = _isLessonAudioPlaying && _playingLessonId == lessonId;
    final repositoryState =
        _audioRepository.isPlaying && _playingLessonId == lessonId;

    // Double-check playback state with both local and repository signals.
    return trackedState || repositoryState;
  }

  bool isAudioLoadingForLesson(String lessonId) => _loadingLessonId == lessonId;

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
    _errorMessageKey = null;
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
      _errorMessageKey = LearnQuranMessageKeys.errorLoadProgress;
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
    _errorMessageKey = null;
    notifyListeners();

    try {
      await _progressRepository.saveProgress(updatedProgress);
    } catch (_) {
      _errorMessageKey = LearnQuranMessageKeys.errorSaveProgress;
      notifyListeners();
    }
  }

  Future<String?> playLessonAudio(LearnQuranLesson lesson) async {
    if (_disposed) return null;
    if (!lesson.hasAudioSample) {
      return LearnQuranMessageKeys.audioMissingSample;
    }

    final request = ++_audioRequest;
    if (_playingLessonId == lesson.id || _loadingLessonId == lesson.id) {
      _isLessonAudioPlaying = false;
      _playingLessonId = null;
      _loadingLessonId = null;
      notifyListeners();
      try {
        await _audioRepository.stop();
      } catch (_) {
        return LearnQuranMessageKeys.audioPlayFailed;
      }
      return null;
    }

    final surahId = lesson.sampleSurahId!;
    final ayahNumber = lesson.sampleAyahNumber!;

    _loadingLessonId = lesson.id;
    _playingLessonId = null;
    _isLessonAudioPlaying = false;
    notifyListeners();

    try {
      // Also cancel audio that is still downloading and has not started playing.
      await _audioRepository.stop();
      if (_disposed || request != _audioRequest) return null;
      final ayah = await _audioSamples.resolve(surahId, ayahNumber);
      if (_disposed || request != _audioRequest) return null;

      _playingLessonId = lesson.id;

      _audioControl.setPlaybackContext(
        source: PlaybackSource.lessonDetail,
        title: lesson.title,
        subtitle: 'Audio sample',
      );

      await _audioRepository.playAyah(ayah);
      return null;
    } catch (_) {
      if (_disposed || request != _audioRequest) return null;
      return LearnQuranMessageKeys.audioPlayFailed;
    } finally {
      if (!_disposed && request == _audioRequest) {
        _loadingLessonId = null;
        _isLessonAudioPlaying = false;
        _playingLessonId = null;
        notifyListeners();
      }
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

  @override
  void dispose() {
    _disposed = true;
    _audioRequest++;
    _audioPlaybackSubscription.cancel();
    super.dispose();
  }
}

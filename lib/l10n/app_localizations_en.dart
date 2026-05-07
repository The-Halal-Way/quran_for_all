// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Quran For All';

  @override
  String get homeReadQuranTab => 'Read Quran';

  @override
  String get homeLearnQuranTab => 'Learn Quran';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageBangla => 'Bangla';

  @override
  String get learnQuranPageTitle => 'Learn Quran';

  @override
  String get learnQuranTracksTitle => 'Learning Tracks';

  @override
  String get learnQuranTracksSubtitle => 'Follow these sections in order or focus on the area you want to improve today.';

  @override
  String get learnHeaderTitle => 'Learn Quran';

  @override
  String get learnHeaderSubtitle => 'Structured lessons for letters, tajweed, and recitation confidence.';

  @override
  String learnHeaderLessonProgress(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get learnHeaderModulesLabel => 'Modules';

  @override
  String get learnHeaderStreakLabel => 'Streak';

  @override
  String learnHeaderStreakDays(int days) {
    return '$days days';
  }

  @override
  String get learnModuleStatusCompleted => 'Completed';

  @override
  String get learnModuleStatusNotStarted => 'Not started';

  @override
  String get learnModuleStatusInProgress => 'In progress';

  @override
  String learnMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String learnCompletedFraction(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get learnNextContinuePathTitle => 'Continue your path';

  @override
  String get learnNextAllLessonsCompletedTitle => 'All lessons completed';

  @override
  String get learnNextAllLessonsCompletedBody => 'Excellent work. Revisit any module to reinforce your learning.';

  @override
  String get learnNextStartLessonButton => 'Start Next Lesson';

  @override
  String get learnNextReviewModulesButton => 'Review Modules';

  @override
  String get learnLessonTooltipPauseAudio => 'Pause lesson sample audio';

  @override
  String get learnLessonTooltipPlayAudio => 'Play lesson sample audio';

  @override
  String get learnLessonAudioGuided => 'Audio guided';

  @override
  String get learnLessonDone => 'Done';

  @override
  String learnLessonDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String learnModuleLessonsCompleted(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get learnVmErrorLoadProgress => 'Unable to load learning progress right now.';

  @override
  String get learnVmErrorSaveProgress => 'Unable to save progress. Please try again.';

  @override
  String get learnVmAudioMissingSample => 'No audio sample is attached to this lesson yet.';

  @override
  String get learnVmAudioSampleNotFound => 'Could not find the sample ayah audio for this lesson.';

  @override
  String get learnVmAudioPlayFailed => 'Unable to play lesson audio right now.';

  @override
  String get learnQuranTextMapRaw => '';
}

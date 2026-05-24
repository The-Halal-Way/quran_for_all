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
  String get duahDailyTitle => 'Daily Du\'a';

  @override
  String get duahDailySubtitle => 'Supplications for every moment';

  @override
  String get duahPowerfulTitle => 'Powerful Du\'as';

  @override
  String get duahLanguageToggleTooltip => 'Change language';

  @override
  String get duahLevelBeginner => 'Beginner';

  @override
  String get duahLevelIntermediate => 'Intermediate';

  @override
  String get duahLevelAdvanced => 'Advanced';

  @override
  String get duahLevelBeginnerDesc => 'Short, easy-to-memorize du\'as for everyday moments. Perfect to start your journey.';

  @override
  String get duahLevelIntermediateDesc => 'Fuller wordings with richer meaning. Ideal once the basics feel natural.';

  @override
  String get duahLevelAdvancedDesc => 'Complete authentic du\'as including optional additions and all daily situations.';

  @override
  String duahCountLabel(int count) {
    return '$count du\'as';
  }

  @override
  String get duahShowVariants => 'Show variants';

  @override
  String get duahHideVariants => 'Hide variants';

  @override
  String get duahCopied => 'Copied';

  @override
  String get duahCopy => 'Copy';

  @override
  String get duahPowerfulImportantNoteTitle => 'Important note';

  @override
  String get duahPowerfulImportantNoteBody => 'Du\'a is answered in the way Allah wills, at the time He wills, and in the form He wills. These are authentic and deeply beloved supplications from Qur\'anic and Prophetic sources.';

  @override
  String get duahPowerfulBestFive => 'Best 5 to memorize first';

  @override
  String get duahSituationAll => 'All';

  @override
  String get duahSituationDistress => 'Distress';

  @override
  String get duahSituationForgiveness => 'Forgiveness';

  @override
  String get duahSituationGuidance => 'Guidance';

  @override
  String get duahSituationProvision => 'Provision';

  @override
  String get duahSituationProtection => 'Protection';

  @override
  String get duahSituationFamily => 'Family';

  @override
  String get duahSituationKnowledge => 'Knowledge';

  @override
  String duahCountOfTotal(int count, int total) {
    return '$count du\'as of $total';
  }

  @override
  String get duahTapToShowPronunciation => 'Tap to show pronunciation';

  @override
  String get dashboardGreetingMorning => 'Good morning';

  @override
  String get dashboardGreetingAfternoon => 'Good afternoon';

  @override
  String get dashboardGreetingEvening => 'Good evening';

  @override
  String get dashboardSectionPrayerTimes => 'Prayer Times';

  @override
  String get dashboardActionFullPrayerView => 'Full Prayer View';

  @override
  String get dashboardActionQiblaCompass => 'Qibla Compass';

  @override
  String get dashboardSectionDua => 'Du\'a';

  @override
  String get dashboardActionDailyDua => 'Daily Du\'a';

  @override
  String get dashboardActionDailyDuaSub => 'Morning & evening';

  @override
  String get dashboardActionPowerfulDua => 'Powerful Du\'a';

  @override
  String get dashboardActionPowerfulDuaSub => 'Curated supplications';

  @override
  String get dashboardSectionHadith => 'Hadith';

  @override
  String get dashboardContinueReadingTitle => 'Continue Reading';

  @override
  String get dashboardContinueReadingStartSubtitle => 'Start where you left off';

  @override
  String get dashboardContinueReadingStartDetail => 'Open your recent surah and continue';

  @override
  String dashboardContinueReadingAyahDetail(int ayahNumber, String surahName) {
    return 'Ayah $ayahNumber · $surahName';
  }

  @override
  String get dashboardQuranLabel => 'Quran';

  @override
  String get dashboardContinueLearningTitle => 'Continue Learning';

  @override
  String get dashboardContinueLearningStartSubtitle => 'Start Learning';

  @override
  String get dashboardContinueLearningStartDetail => 'Open learning tracks';

  @override
  String dashboardContinueLearningModuleDetail(String moduleTitle, int lessonCount) {
    return '$moduleTitle · $lessonCount lessons';
  }

  @override
  String get dashboardRetry => 'Retry';

  @override
  String get dashboardNextPrayer => 'Next Prayer';

  @override
  String get dashboardNextShortLabel => 'Next';

  @override
  String get dashboardPrayerFajr => 'Fajr';

  @override
  String get dashboardPrayerSunrise => 'Sunrise';

  @override
  String get dashboardPrayerDhuhr => 'Dhuhr';

  @override
  String get dashboardPrayerAsr => 'Asr';

  @override
  String get dashboardPrayerMaghrib => 'Maghrib';

  @override
  String get dashboardPrayerIsha => 'Isha';

  @override
  String get dashboardHadithAnNawawiTitle => 'Forty Hadith An-Nawawi';

  @override
  String get dashboardHadithAnNawawiDescription => 'The classical collection by Imam An-Nawawi';

  @override
  String get dashboardHadithShortTitle => 'Forty Short Hadith';

  @override
  String get dashboardHadithShortDescription => 'Short hadith for easy memorization & practice';

  @override
  String get learnQuranTextMapRaw => '';
}

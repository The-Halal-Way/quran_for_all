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
  String get homeDashboardTab => 'Today';

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
  String get learnQuranTracksSubtitle =>
      'Follow these sections in order or focus on the area you want to improve today.';

  @override
  String get learnHeaderTitle => 'Learn Quran';

  @override
  String get learnHeaderSubtitle =>
      'Structured lessons for letters, tajweed, and recitation confidence.';

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
  String get learnNextAllLessonsCompletedBody =>
      'Excellent work. Revisit any module to reinforce your learning.';

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
  String get learnVmErrorLoadProgress =>
      'Unable to load learning progress right now.';

  @override
  String get learnVmErrorSaveProgress =>
      'Unable to save progress. Please try again.';

  @override
  String get learnVmAudioMissingSample =>
      'No audio sample is attached to this lesson yet.';

  @override
  String get learnVmAudioSampleNotFound =>
      'Could not find the sample ayah audio for this lesson.';

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
  String get duahLevelBeginnerDesc =>
      'Short, easy-to-memorize du\'as for everyday moments. Perfect to start your journey.';

  @override
  String get duahLevelIntermediateDesc =>
      'Fuller wordings with richer meaning. Ideal once the basics feel natural.';

  @override
  String get duahLevelAdvancedDesc =>
      'Complete authentic du\'as including optional additions and all daily situations.';

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
  String get duahPowerfulImportantNoteBody =>
      'Du\'a is answered in the way Allah wills, at the time He wills, and in the form He wills. These are authentic and deeply beloved supplications from Qur\'anic and Prophetic sources.';

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
  String get duahNintyNineTitle => '99 Names';

  @override
  String get duahNintyNineSubtitle => 'Asma ul Husna';

  @override
  String duahNintyNineNamesCount(int count) {
    return '$count names';
  }

  @override
  String duahNintyNineCategoryCount(int count) {
    return '$count themes';
  }

  @override
  String get duahNintyNineVerseLabel => 'Quran reminder';

  @override
  String get duahNintyNineBenefitTitle => 'Benefit';

  @override
  String get duahNintyNineConclusionTitle => 'Conclusion';

  @override
  String get duahNintyNineNamesGridTitle => 'Beautiful Names';

  @override
  String get duahNintyNineLoading => 'Loading the beautiful names...';

  @override
  String get duahNintyNineLoadError => 'Unable to load the names right now.';

  @override
  String get duahNintyNineLoadErrorBody => 'Please try again in a moment.';

  @override
  String get duahNintyNineRetry => 'Retry';

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
  String get dashboardActionNintyNineNames => '99 Names';

  @override
  String get dashboardActionNintyNineNamesSub => 'Asma ul Husna';

  @override
  String get dashboardSectionHadith => 'Hadith';

  @override
  String get dashboardContinueReadingTitle => 'Continue Reading';

  @override
  String get dashboardContinueReadingStartSubtitle =>
      'Start where you left off';

  @override
  String get dashboardContinueReadingStartDetail =>
      'Open your recent surah and continue';

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
  String dashboardContinueLearningModuleDetail(
    String moduleTitle,
    int lessonCount,
  ) {
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
  String get dashboardPrayerSehri => 'Sehri';

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
  String get dashboardHadithAnNawawiDescription =>
      'The classical collection by Imam An-Nawawi';

  @override
  String get dashboardHadithShortTitle => 'Forty Short Hadith';

  @override
  String get dashboardHadithShortDescription =>
      'Short hadith for easy memorization & practice';

  @override
  String get prayerViewTitle => 'Prayer Details';

  @override
  String get prayerViewAppBarSubtitle => 'Guidance for this salah window';

  @override
  String get prayerViewRefreshTooltip => 'Refresh prayer times';

  @override
  String get prayerViewLanguageTooltip => 'Change language';

  @override
  String get prayerViewCurrentFocus => 'Current focus';

  @override
  String get prayerViewLoadedFromLocation => 'Location time';

  @override
  String get prayerViewTimeFallback => 'Guide mode';

  @override
  String get prayerViewHeroNextLabel => 'Time to prepare';

  @override
  String get prayerViewNoTime => '--';

  @override
  String get prayerViewSehriLast => 'Last';

  @override
  String get prayerViewPermissionHelpTitle => 'Prayer times need location';

  @override
  String get prayerViewPermissionHelpBody =>
      'Enable location permission to calculate local prayer times. The guidance below still stays available.';

  @override
  String get prayerViewTimelineTitle => 'Today\'s Prayer Rhythm';

  @override
  String get prayerViewTimelineSubtitle =>
      'Scan the full day, spot the next prayer, and keep the current focus visible.';

  @override
  String get prayerViewNowTitle => 'What to follow now';

  @override
  String get prayerViewNowSubtitle =>
      'A practical next move for the current prayer window.';

  @override
  String get prayerViewSuggestionsTitle => 'Prayer suggestions';

  @override
  String get prayerViewSuggestionsSubtitle =>
      'Small actions that make this salah feel calmer and more intentional.';

  @override
  String get prayerViewHowTitle => 'How to pray';

  @override
  String get prayerViewHowSubtitle =>
      'A simple flow for the core movements and presence of salah.';

  @override
  String get prayerViewBestPracticesTitle => 'Best practices';

  @override
  String get prayerViewBestPracticesSubtitle =>
      'Focused habits tailored to the prayer currently in view.';

  @override
  String get prayerViewFiqhNoteTitle => 'Practice note';

  @override
  String get prayerViewFiqhNoteBody =>
      'Details can vary by madhhab and local teaching. Use this as friendly guidance and follow a trusted scholar or imam for fiqh-specific rulings.';

  @override
  String get prayerViewFocus => 'Focus';

  @override
  String get prayerViewNext => 'Next';

  @override
  String get prayerViewPassed => 'Passed';

  @override
  String get prayerViewSoon => 'Soon';

  @override
  String get prayerHowIntentionTitle => 'Intention & readiness';

  @override
  String get prayerHowIntentionBody =>
      'Make wudu, face the qibla, and settle your intention in the heart before you begin.';

  @override
  String get prayerHowQiyamTitle => 'Qiyam';

  @override
  String get prayerHowQiyamBody =>
      'Stand calmly, say the opening takbir, recite Al-Fatihah, then recite what is easy from the Quran.';

  @override
  String get prayerHowRukuTitle => 'Ruku';

  @override
  String get prayerHowRukuBody =>
      'Bow with the back settled, glorify Allah, then rise with calm before going down.';

  @override
  String get prayerHowSujoodTitle => 'Sujood';

  @override
  String get prayerHowSujoodBody =>
      'Prostrate with humility, pause without rushing, then sit briefly and complete the second prostration.';

  @override
  String get prayerHowTashahhudTitle => 'Tashahhud';

  @override
  String get prayerHowTashahhudBody =>
      'In the final sitting, recite tashahhud and send salawat upon the Prophet, peace be upon him.';

  @override
  String get prayerHowSalamTitle => 'Salam';

  @override
  String get prayerHowSalamBody =>
      'End the prayer with salam, then remain present for short dhikr and du\'a.';

  @override
  String get prayerFocusFajrTitle => 'Fajr Window';

  @override
  String get prayerFocusFajrSubtitle =>
      'Begin the day before the world gets loud.';

  @override
  String get prayerFocusSunriseTitle => 'Sunrise Pause';

  @override
  String get prayerFocusSunriseSubtitle =>
      'A quiet transition after Fajr; wait before optional Duha.';

  @override
  String get prayerFocusDhuhrTitle => 'Dhuhr Reset';

  @override
  String get prayerFocusDhuhrSubtitle =>
      'Let the middle of the day become a clean spiritual reset.';

  @override
  String get prayerFocusAsrTitle => 'Asr Guard';

  @override
  String get prayerFocusAsrSubtitle =>
      'Protect the late afternoon before tasks scatter your attention.';

  @override
  String get prayerFocusMaghribTitle => 'Maghrib Return';

  @override
  String get prayerFocusMaghribSubtitle =>
      'Move quickly from sunset into remembrance and gratitude.';

  @override
  String get prayerFocusIshaTitle => 'Isha Closure';

  @override
  String get prayerFocusIshaSubtitle =>
      'Close the day with calm, repentance, and preparation for Fajr.';

  @override
  String get prayerNowFajrTitle => 'Protect the dawn';

  @override
  String get prayerNowFajrBody =>
      'Before sunrise, protect the Fajr window. If you have not prayed, make wudu and pray now; if you have, stay with morning adhkar or Quran.';

  @override
  String get prayerNowSunriseTitle => 'Pause and remember';

  @override
  String get prayerNowSunriseBody =>
      'At exact sunrise avoid starting voluntary prayer; keep morning dhikr and wait until the sun has risen before Duha.';

  @override
  String get prayerNowDhuhrTitle => 'Reset the middle of the day';

  @override
  String get prayerNowDhuhrBody =>
      'Step away from work, renew wudu, and give the fard prayer an unhurried pocket of attention.';

  @override
  String get prayerNowAsrTitle => 'Guard the late afternoon';

  @override
  String get prayerNowAsrBody =>
      'Make Asr visible before the day becomes crowded. Pray with steady pace and leave a short moment for dhikr afterward.';

  @override
  String get prayerNowMaghribTitle => 'Move promptly';

  @override
  String get prayerNowMaghribBody =>
      'When Maghrib enters, shift quickly from sunset routines into salah, then return to family, food, or travel with a lighter heart.';

  @override
  String get prayerNowIshaTitle => 'Close the day cleanly';

  @override
  String get prayerNowIshaBody =>
      'Pray Isha before sleepiness takes over. Pair it with repentance, gratitude, and a simple plan for waking for Fajr.';

  @override
  String get prayerSuggestionsFajrRaw =>
      'Pray the two raka\'at Sunnah before the fard when you are able.||Keep the recitation calm and bright, even if it is short.||After salah, spend a few minutes with morning adhkar or a small Quran portion.';

  @override
  String get prayerSuggestionsSunriseRaw =>
      'Continue morning adhkar while the sun rises.||Wait until the disliked sunrise moment passes before optional Duha.||Use the quiet transition to plan the next prayer instead of drifting.';

  @override
  String get prayerSuggestionsDhuhrRaw =>
      'Use the adhan as a hard pause from work or study.||Choose a quiet place before the day becomes crowded again.||Pair the prayer with a small gratitude check before returning to tasks.';

  @override
  String get prayerSuggestionsAsrRaw =>
      'Plan Asr before the late-afternoon rush begins.||Keep the pace steady rather than compressed.||Use one minute after salam to ask Allah for protection and consistency.';

  @override
  String get prayerSuggestionsMaghribRaw =>
      'Pray soon after adhan because the window feels short in daily life.||Keep food, family, and commute transitions from swallowing the prayer.||Follow with evening adhkar when your routine allows.';

  @override
  String get prayerSuggestionsIshaRaw =>
      'Pray before sleepiness makes focus heavy.||Prepare for Witr according to your practice after Isha.||Set up tomorrow\'s Fajr before bed: alarm, wudu plan, and sleep intention.';

  @override
  String get prayerBestPracticesFajrRaw =>
      'Sleep with Fajr in mind, not as an afterthought.||Avoid rushing the first prayer of the day; let it set the tone.||Use the stillness after Fajr for Quran, adhkar, or one sincere du\'a.';

  @override
  String get prayerBestPracticesSunriseRaw =>
      'Do not treat sunrise as an obligatory prayer; it is a transition marker.||Stay away from voluntary prayer at the exact sunrise moment.||Return to optional worship after the sun has risen and the time is clear.';

  @override
  String get prayerBestPracticesDhuhrRaw =>
      'Put Dhuhr on the calendar before the workday takes over.||Stand without carrying the whole task list into salah.||If you pray Sunnah prayers, place them around the fard according to your learned practice.';

  @override
  String get prayerBestPracticesAsrRaw =>
      'Guard Asr from being pushed to the edge of the time.||Lower the pace before takbir so the prayer does not feel like a race.||Use Asr as an accountability checkpoint for the rest of the day.';

  @override
  String get prayerBestPracticesMaghribRaw =>
      'Respond quickly when Maghrib enters.||Keep sunset meals and gatherings from delaying the prayer.||Let Maghrib open your evening adhkar and family calm.';

  @override
  String get prayerBestPracticesIshaRaw =>
      'Pray before exhaustion dulls attention.||Keep Witr visible in the night routine according to your practice.||Prepare the body and room for Fajr before sleeping.';

  @override
  String get learnQuranTextMapRaw => '';
}

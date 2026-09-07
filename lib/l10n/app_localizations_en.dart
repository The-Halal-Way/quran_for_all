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
  String get homePrayerTab => 'Prayer';

  @override
  String get homeQuranTab => 'Quran';

  @override
  String get homeReadQuranTab => 'Read Quran';

  @override
  String get homeLearnQuranTab => 'Learn Quran';

  @override
  String get homeSunnahDuaTab => 'Sunnah/Du\'a';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageBangla => 'Bangla';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsIntro => 'Personalize your recitation and reading experience.';

  @override
  String get settingsReadingPreferencesTitle => 'Reading Preferences';

  @override
  String get settingsShowPronunciationTitle => 'Show pronunciation';

  @override
  String get settingsShowPronunciationSubtitle => 'Display transliteration under Arabic ayah.';

  @override
  String get settingsShowTranslationsTitle => 'Show translations';

  @override
  String get settingsShowTranslationsSubtitle => 'Display meaning in your selected language.';

  @override
  String get settingsLanguagePreferenceLabel => 'Language preference';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsOfflineTitle => 'Offline mode is enabled';

  @override
  String get settingsOfflineBody => 'Quran text, translations, and tafsir are stored locally after setup. Audio is cached after first play.';

  @override
  String get settingsHijriCalendarTitle => 'Hijri Calendar';

  @override
  String get settingsHijriAdjustmentTitle => 'Local date adjustment';

  @override
  String get settingsHijriAdjustmentSubtitle => 'Use this if your local moon-sighting date is one day different from the calculated date.';

  @override
  String get hijriAdjustmentTitle => 'Moon-sighting adjustment';

  @override
  String get hijriAdjustmentMinusLabel => '-1 day';

  @override
  String get hijriAdjustmentCalculatedLabel => 'Calculated';

  @override
  String get hijriAdjustmentPlusLabel => '+1 day';

  @override
  String get hijriCalendarTitle => 'Hijri Calendar';

  @override
  String get hijriCalendarSubtitle => 'Browse Islamic dates and find any day';

  @override
  String get hijriCalendarTodayAction => 'Today';

  @override
  String get hijriFinderTitle => 'Find a date';

  @override
  String get hijriFinderSubtitle => 'Jump by Gregorian date or enter a Hijri date directly.';

  @override
  String get hijriFindGregorianAction => 'Pick Gregorian';

  @override
  String get hijriFindHijriAction => 'Enter Hijri';

  @override
  String get hijriDatePickerTitle => 'Find Hijri Date';

  @override
  String get hijriDatePickerYearLabel => 'Year';

  @override
  String get hijriDatePickerMonthLabel => 'Month';

  @override
  String get hijriDatePickerDayLabel => 'Day';

  @override
  String get hijriDatePickerOpenAction => 'Open date';

  @override
  String get hijriInvalidDateMessage => 'That Hijri date is not available.';

  @override
  String get hijriSelectedDateTitle => 'Selected date';

  @override
  String hijriDateFull(String day, String month, String year) {
    return '$day $month $year AH';
  }

  @override
  String get hijriWeekdaySun => 'Sun';

  @override
  String get hijriWeekdayMon => 'Mon';

  @override
  String get hijriWeekdayTue => 'Tue';

  @override
  String get hijriWeekdayWed => 'Wed';

  @override
  String get hijriWeekdayThu => 'Thu';

  @override
  String get hijriWeekdayFri => 'Fri';

  @override
  String get hijriWeekdaySat => 'Sat';

  @override
  String get hijriMonthMuharram => 'Muharram';

  @override
  String get hijriMonthSafar => 'Safar';

  @override
  String get hijriMonthRabiAlAwwal => 'Rabi\' al-Awwal';

  @override
  String get hijriMonthRabiAlThani => 'Rabi\' al-Thani';

  @override
  String get hijriMonthJumadaAlAwwal => 'Jumada al-Awwal';

  @override
  String get hijriMonthJumadaAlThani => 'Jumada al-Thani';

  @override
  String get hijriMonthRajab => 'Rajab';

  @override
  String get hijriMonthShaban => 'Sha\'ban';

  @override
  String get hijriMonthRamadan => 'Ramadan';

  @override
  String get hijriMonthShawwal => 'Shawwal';

  @override
  String get hijriMonthDhulQadah => 'Dhul Qadah';

  @override
  String get hijriMonthDhulHijjah => 'Dhul Hijjah';

  @override
  String get splashStatusPreparing => 'Preparing local Quran database...';

  @override
  String get splashStatusReady => 'Ready';

  @override
  String get splashStatusOfflineFallback => 'Ready with saved Quran data. Some newer content may sync later.';

  @override
  String get splashRetrySetup => 'Retry setup';

  @override
  String get splashSetupFailedTitle => 'Setup needs internet';

  @override
  String get splashSetupFailedBody => 'Quran For All needs a network connection the first time it prepares the local Quran database. Check your internet connection and try again.';

  @override
  String get splashSetupFailedTip => 'After setup, Quran text, translations, tafsir, bookmarks, and reading progress work from local storage.';

  @override
  String get readQuranTitle => 'Read Quran';

  @override
  String get readQuranSubtitle => 'Quran For All';

  @override
  String get readQuranSearchTooltip => 'Search';

  @override
  String get readQuranBookmarksTooltip => 'Bookmarks';

  @override
  String get readQuranAllSurahsTitle => 'All Surahs';

  @override
  String get readQuranTotalLabel => 'total';

  @override
  String get readQuranAyahLabel => 'Ayah';

  @override
  String get readQuranSurahLabel => 'Surah';

  @override
  String get readQuranJuzLabel => 'Juz';

  @override
  String get readQuranAyahsLabel => 'ayahs';

  @override
  String get readQuranSurahsLabel => 'Surahs';

  @override
  String get readQuranContinueReadingTitle => 'Continue Reading';

  @override
  String get readQuranBannerTitle => 'Read. Reflect. Remember.';

  @override
  String get readQuranBannerSubtitle => 'Offline Quran with Bangla and English support.';

  @override
  String get readQuranOfflineReadyLabel => 'Offline Ready';

  @override
  String get readQuranBannerSearchButton => 'Search Surah, Ayah, Juz';

  @override
  String get readQuranSaveAyahBookmarkTooltip => 'Save ayah bookmark';

  @override
  String get readQuranRemoveAyahBookmarkTooltip => 'Remove ayah bookmark';

  @override
  String get readQuranSaveSurahBookmarkTooltip => 'Save surah bookmark';

  @override
  String get readQuranRemoveSurahBookmarkTooltip => 'Remove surah bookmark';

  @override
  String get readQuranMarkAyahLastReadTooltip => 'Mark ayah as last read';

  @override
  String get readQuranCurrentLastReadTooltip => 'Current last read ayah';

  @override
  String get readQuranPlayAyahAudioTooltip => 'Play ayah audio';

  @override
  String get readQuranStopAyahAudioTooltip => 'Stop ayah audio';

  @override
  String get readQuranReadTafsirTooltip => 'Read tafsir';

  @override
  String get readQuranTafsirTitle => 'Tafsir';

  @override
  String get readQuranNoTafsirBody => 'No tafsir available for this ayah yet.';

  @override
  String get readQuranMeccan => 'Meccan';

  @override
  String get readQuranMedinan => 'Medinan';

  @override
  String get readQuranCouldNotLoadSurahTitle => 'Could not load surah';

  @override
  String get readQuranUnablePlayAyahAudio => 'Unable to play this ayah audio right now.';

  @override
  String get readQuranUnablePlayFullSurahAudio => 'Unable to play full surah audio right now.';

  @override
  String get readQuranAudioPermissionRequired => 'Notification permission is required for audio controls.';

  @override
  String get readQuranGoToSettings => 'Go to settings';

  @override
  String get readQuranExpandCard => 'Expand card';

  @override
  String get readQuranShrinkCard => 'Shrink card';

  @override
  String get readQuranReadingOptionsTitle => 'Reading options';

  @override
  String get readQuranReadingOptionsSubtitle => 'Pronunciation and translation visibility';

  @override
  String get readQuranReadingModeLabel => 'Reading mode';

  @override
  String get readQuranDetailsMode => 'Details';

  @override
  String get readQuranRegularMode => 'Regular';

  @override
  String get readQuranDetailsView => 'Details view';

  @override
  String get readQuranRegularView => 'Regular view';

  @override
  String get readQuranPlayFullSurah => 'Play Full Surah';

  @override
  String get readQuranStopSurahAudio => 'Stop Surah Audio';

  @override
  String get readQuranSearchInsideSurahTitle => 'Search inside this surah';

  @override
  String get readQuranSearchInsideSurahHint => 'Try ayah number, Arabic text, or translation keyword';

  @override
  String get readQuranStartTypingSurahSearch => 'Start typing to search in this surah.';

  @override
  String get readQuranSearchAyahsTitle => 'Search Ayahs';

  @override
  String get readQuranSearchAyahsBody => 'Type text or ayah number to jump quickly.';

  @override
  String get readQuranNoResultsTitle => 'No results';

  @override
  String get readQuranNoResultsBody => 'Try a different keyword or ayah number.';

  @override
  String readQuranResultsCount(int count) {
    return 'Results: $count';
  }

  @override
  String readQuranSurahOfTotal(int current, int total) {
    return 'Surah $current of $total';
  }

  @override
  String get readQuranPreviousSurahTooltip => 'Previous surah';

  @override
  String get readQuranNextSurahTooltip => 'Next surah';

  @override
  String get readQuranSearchTitle => 'Search Quran';

  @override
  String get readQuranSearchEmptyTitle => 'Search Surah, Ayah, or Juz';

  @override
  String get readQuranSearchEmptyBody => 'Use query formats like 1:1, para 2, or any Bangla/English keyword.';

  @override
  String get readQuranSearchFailedTitle => 'Search failed';

  @override
  String get readQuranSearchNoResultsBody => 'Try a shorter keyword or a direct ayah reference.';

  @override
  String get readQuranSearchHint => 'Try: Al-Baqarah, 2:255, para 1, mercy';

  @override
  String get readQuranSearchingLabel => 'Searching...';

  @override
  String readQuranSearchResultsSummary(int count, String query) {
    return 'Results: $count · \"$query\"';
  }

  @override
  String get readQuranCouldNotOpenSearchResult => 'Could not open this result.';

  @override
  String get readQuranBookmarksTitle => 'Bookmarks';

  @override
  String get readQuranCouldNotLoadBookmarksTitle => 'Could not load bookmarks';

  @override
  String get readQuranNoBookmarksTitle => 'No bookmarks yet';

  @override
  String get readQuranNoBookmarksBody => 'Save ayah or surah bookmarks to find them quickly later.';

  @override
  String get readQuranCouldNotOpenBookmark => 'Could not open this bookmark.';

  @override
  String get readQuranSavedBookmarkLabel => 'Saved bookmark';

  @override
  String get readQuranAyahBookmarkAdded => 'Ayah bookmarked successfully.';

  @override
  String get readQuranAyahBookmarkRemoved => 'Ayah bookmark removed.';

  @override
  String get readQuranCouldNotUpdateAyahBookmark => 'Could not update ayah bookmark right now.';

  @override
  String get readQuranMarkedLastRead => 'Marked as last read.';

  @override
  String get readQuranCouldNotMarkLastRead => 'Could not mark this ayah as last read.';

  @override
  String get readQuranVmSearchFailed => 'Search failed. Please try again.';

  @override
  String get readQuranVmNoSurahSelected => 'No surah selected.';

  @override
  String get readQuranVmUnableLoadAyahs => 'Unable to load ayahs for this surah.';

  @override
  String get readQuranVmUnableLoadBookmarks => 'Unable to load bookmarks right now.';

  @override
  String get quranHubTitle => 'Quran';

  @override
  String get quranHubHeroEyebrow => 'The Book that guides';

  @override
  String get quranHubHeroArabic => 'الْقُرْآن';

  @override
  String get quranHubHeroBody => 'A single home for reading, learning, reflecting, and returning to Allah\'s words with a calmer heart.';

  @override
  String get quranHubStatOfflineValue => 'Offline';

  @override
  String get quranHubStatOfflineLabel => 'Text ready';

  @override
  String get quranHubStatLanguagesValue => '2';

  @override
  String get quranHubStatLanguagesLabel => 'Languages';

  @override
  String get quranHubSectionChooseTitle => 'Choose your Quran path';

  @override
  String get quranHubSectionChooseSubtitle => 'Move straight into recitation, or slow down and build stronger Quran skills.';

  @override
  String get quranHubReadTitle => 'Read Quran';

  @override
  String get quranHubReadSubtitle => 'Open the mushaf, search ayahs, save bookmarks, and continue from your last read.';

  @override
  String get quranHubReadAction => 'Start reading';

  @override
  String get quranHubReadFreshStart => 'Begin from any surah';

  @override
  String quranHubReadContinueDetail(String surahName, int ayahNumber) {
    return 'Last read: $surahName, Ayah $ayahNumber';
  }

  @override
  String get quranHubLearnTitle => 'Learn Quran';

  @override
  String get quranHubLearnSubtitle => 'Build pronunciation, tajweed, word meaning, and salah-ready recitation step by step.';

  @override
  String get quranHubLearnAction => 'Start learning';

  @override
  String get quranHubLearningFreshStart => 'Begin with the first guided lesson';

  @override
  String get quranHubHadithTitle => 'Hadith about the Quran';

  @override
  String get quranHubHadithSubtitle => 'Short reminders that keep reading and learning connected to reward, mercy, and practice.';

  @override
  String get quranHubHadithBestTitle => 'Learn and teach';

  @override
  String get quranHubHadithBestBody => 'The Prophet ﷺ taught that the best people are those who learn the Quran and teach it.';

  @override
  String get quranHubHadithBestSource => 'Sahih al-Bukhari 5027';

  @override
  String get quranHubHadithIntercessorTitle => 'A companion on that Day';

  @override
  String get quranHubHadithIntercessorBody => 'The Quran will come on the Day of Resurrection as an intercessor for its companions.';

  @override
  String get quranHubHadithIntercessorSource => 'Sahih Muslim 804';

  @override
  String get quranHubHadithEffortTitle => 'Effort is honored';

  @override
  String get quranHubHadithEffortBody => 'The skilled reciter is with noble angels, and the one who recites with difficulty receives two rewards.';

  @override
  String get quranHubHadithEffortSource => 'Sahih al-Bukhari 4937; Sahih Muslim 798';

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
  String get duahCategoryEatingDrinking => 'Eating & Drinking';

  @override
  String get duahCategoryHome => 'Home';

  @override
  String get duahCategoryWashroom => 'Washroom';

  @override
  String get duahCategorySleep => 'Sleep';

  @override
  String get duahCategoryDailyDhikr => 'Daily Dhikr';

  @override
  String get duahCategoryWudu => 'Wudū\'';

  @override
  String get duahCategoryMasjid => 'Masjid';

  @override
  String get duahCategorySneezing => 'Sneezing';

  @override
  String get duahCategoryDifficulty => 'Difficulty';

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
  String get languageNativeName => 'English';

  @override
  String get sunnahDuaCollectionsTitle => 'For every moment';

  @override
  String get sunnahDuaCollectionsSubtitle => 'Du\'a, remembrance & a little inspiration';

  @override
  String get sunnahDuaRoutineTitle => 'A day with the Sunnah';

  @override
  String get sunnahDuaRoutineSubtitle => 'Small practices, from waking to restful sleep.';

  @override
  String get sunnahDuaSearchCollections => 'Search collections';

  @override
  String get sunnahDuaSearchRoutine => 'Search your daily Sunnah';

  @override
  String get sunnahDuaClearSearch => 'Clear search';

  @override
  String get sunnahDuaNoResults => 'No matches found';

  @override
  String get sunnahDuaNoResultsBody => 'Try another word or clear your search.';

  @override
  String get sunnahDuaMorningLabel => 'Begin your morning';

  @override
  String get sunnahDuaDaytimeLabel => 'Through the day';

  @override
  String get sunnahDuaEveningLabel => 'Ease into the night';

  @override
  String get sunnahDuaWakeLabel => 'Wake';

  @override
  String get sunnahDuaDayLabel => 'Live';

  @override
  String get sunnahDuaRestLabel => 'Rest';

  @override
  String get sunnahDuaHeroDescription => 'Let everyday moments bring you closer to Allah.';

  @override
  String get sunnahDuaOpenPractice => 'Read practice';

  @override
  String get sunnahRoutineWakeUpTitle => 'Wake up';

  @override
  String get sunnahRoutineWakeUpSubtitle => 'Begin again with gratitude';

  @override
  String get sunnahRoutineWakeUpPointsRaw => 'Praise Allah as you wake.||Clean your mouth with miswak before prayer.';

  @override
  String get sunnahRoutineWakeUpPractice => 'Make the waking du\'a your first words of the day.';

  @override
  String get sunnahRoutineWashroomTitle => 'Washroom';

  @override
  String get sunnahRoutineWashroomSubtitle => 'Care for cleanliness and privacy';

  @override
  String get sunnahRoutineWashroomPointsRaw => 'Read the du\'a before entering the washroom.||Use the left hand for cleaning after relieving yourself.||After leaving, ask Allah for forgiveness.';

  @override
  String get sunnahRoutineWashroomPractice => 'Learn the short duas for entering and leaving.';

  @override
  String get sunnahRoutineMiswakTitle => 'Miswak';

  @override
  String get sunnahRoutineMiswakSubtitle => 'A fresh start before worship';

  @override
  String get sunnahRoutineMiswakPointsRaw => 'Use miswak after waking.||Clean your mouth with miswak before prayer.';

  @override
  String get sunnahRoutineMiswakPractice => 'Keep your miswak clean and within reach.';

  @override
  String get sunnahRoutineWuduTitle => 'Wudu';

  @override
  String get sunnahRoutineWuduSubtitle => 'Prepare for prayer with care';

  @override
  String get sunnahRoutineWuduPointsRaw => 'Wash the hands, rinse the mouth and nose, then wash the face and arms.||Wipe the head and wash the feet as taught in wudu.||Complete wudu carefully, then recite the testimony of faith.';

  @override
  String get sunnahRoutineWuduPractice => 'Learn the complete method of wudu; these reminders include both essential acts and Sunnah details.';

  @override
  String get sunnahRoutineDressingTitle => 'Getting dressed';

  @override
  String get sunnahRoutineDressingSubtitle => 'Begin with the right side';

  @override
  String get sunnahRoutineDressingPointsRaw => 'Start with the right side when putting on shoes and tending to your appearance.||Put on the right shoe first and remove the left shoe first.';

  @override
  String get sunnahRoutineDressingPractice => 'Let getting ready become a small, consistent Sunnah habit.';

  @override
  String get sunnahRoutineAdhanTitle => 'Hearing the adhan';

  @override
  String get sunnahRoutineAdhanSubtitle => 'Pause and answer the call';

  @override
  String get sunnahRoutineAdhanPointsRaw => 'Repeat the caller\'s words.||At the calls to prayer and success, say la hawla wa la quwwata illa billah.||After the adhan, send blessings upon the Prophet ﷺ and ask Allah to grant him al-Wasilah.';

  @override
  String get sunnahRoutineAdhanPractice => 'Pause other conversation long enough to listen and respond.';

  @override
  String get sunnahRoutineMasjidTitle => 'At the masjid';

  @override
  String get sunnahRoutineMasjidSubtitle => 'Arrive with calm and reverence';

  @override
  String get sunnahRoutineMasjidPointsRaw => 'Walk to prayer calmly, even if the prayer has begun.||Ask Allah to open the doors of His mercy when entering.||Pray two rak\'ahs before sitting when appropriate.||When leaving, ask Allah for His bounty.';

  @override
  String get sunnahRoutineMasjidPractice => 'Keep the space peaceful for other worshippers.';

  @override
  String get sunnahRoutineAfterPrayerTitle => 'After salah';

  @override
  String get sunnahRoutineAfterPrayerSubtitle => 'Stay a little longer in remembrance';

  @override
  String get sunnahRoutineAfterPrayerPointsRaw => 'Ask Allah for forgiveness three times after the prayer.||Recite Allahumma antas-salam wa minkas-salam.||Say Subhanallah, Alhamdulillah and Allahu akbar 33 times each, completing a hundred with the reported declaration of Allah\'s oneness.';

  @override
  String get sunnahRoutineAfterPrayerPractice => 'Learn one complete, authentic form of the post-prayer adhkar.';

  @override
  String get sunnahRoutineMorningTitle => 'Morning dhikr';

  @override
  String get sunnahRoutineMorningSubtitle => 'Carry remembrance into your day';

  @override
  String get sunnahRoutineMorningPointsRaw => 'Say Subhanallahi wa bihamdihi one hundred times in the morning.';

  @override
  String get sunnahRoutineMorningPractice => 'Use the Morning & evening collection for the Arabic and meaning.';

  @override
  String get sunnahRoutineDuhaTitle => 'Duha prayer';

  @override
  String get sunnahRoutineDuhaSubtitle => 'A quiet pause in the forenoon';

  @override
  String get sunnahRoutineDuhaPointsRaw => 'Pray two rak\'ahs of Duha during the forenoon, after the sun has risen sufficiently and before the sun reaches its zenith.';

  @override
  String get sunnahRoutineDuhaPractice => 'Choose a regular time within the Duha window that fits your day.';

  @override
  String get sunnahRoutineLeavingHomeTitle => 'Leaving home';

  @override
  String get sunnahRoutineLeavingHomeSubtitle => 'Step outside with trust';

  @override
  String get sunnahRoutineLeavingHomePointsRaw => 'Say the du\'a for leaving home.||Remember that strength and ability come from Allah.';

  @override
  String get sunnahRoutineLeavingHomePractice => 'Make the doorway a reminder to place your trust in Allah.';

  @override
  String get sunnahRoutineEatingTitle => 'Eating';

  @override
  String get sunnahRoutineEatingSubtitle => 'Bring Sunnah to the table';

  @override
  String get sunnahRoutineEatingPointsRaw => 'Mention Allah\'s name before eating.||Eat with your right hand and from the food nearest to you.||Do not criticize food.||Eat moderately.';

  @override
  String get sunnahRoutineEatingPractice => 'Use each meal as a reminder to practise these manners.';

  @override
  String get sunnahRoutineDrinkingTitle => 'Drinking water';

  @override
  String get sunnahRoutineDrinkingSubtitle => 'Small sips, sincere gratitude';

  @override
  String get sunnahRoutineDrinkingPointsRaw => 'Drink with the right hand.||Pause between sips to breathe away from the vessel.||Praise Allah after drinking.';

  @override
  String get sunnahRoutineDrinkingPractice => 'Take your time and keep your breath out of the cup.';

  @override
  String get sunnahRoutineGreetingsTitle => 'Salam & a smile';

  @override
  String get sunnahRoutineGreetingsSubtitle => 'Make kindness your greeting';

  @override
  String get sunnahRoutineGreetingsPointsRaw => 'Spread salam among people.||Meet others with a warm smile.';

  @override
  String get sunnahRoutineGreetingsPractice => 'Begin ordinary encounters with care and respect.';

  @override
  String get sunnahRoutineSpeechTitle => 'Mindful speech';

  @override
  String get sunnahRoutineSpeechSubtitle => 'Speak well and with gentleness';

  @override
  String get sunnahRoutineSpeechPointsRaw => 'Say what is good or remain silent.||Be gentle in your words and dealings.';

  @override
  String get sunnahRoutineSpeechPractice => 'Pause before speaking when you feel upset.';

  @override
  String get sunnahRoutineSneezingTitle => 'Sneezing & yawning';

  @override
  String get sunnahRoutineSneezingSubtitle => 'Gratitude in a small moment';

  @override
  String get sunnahRoutineSneezingPointsRaw => 'After sneezing, say Alhamdulillah.||A Muslim who hears it responds Yarhamukallah; the sneezer replies Yahdikumullahu wa yuslihu balakum.||Cover your mouth when yawning.';

  @override
  String get sunnahRoutineSneezingPractice => 'Learn both parts of the exchange so you can respond with care.';

  @override
  String get sunnahRoutineReturningHomeTitle => 'Returning home';

  @override
  String get sunnahRoutineReturningHomeSubtitle => 'Enter with remembrance and salam';

  @override
  String get sunnahRoutineReturningHomePointsRaw => 'Mention Allah when entering your home.||Greet the people at home with salam.';

  @override
  String get sunnahRoutineReturningHomePractice => 'Begin your return with a peaceful greeting.';

  @override
  String get sunnahRoutineFamilyTitle => 'Time with family';

  @override
  String get sunnahRoutineFamilySubtitle => 'Kindness begins at home';

  @override
  String get sunnahRoutineFamilyPointsRaw => 'Help with the work of your household.||Treat your family with kindness.';

  @override
  String get sunnahRoutineFamilyPractice => 'Choose one useful household task and do it with care.';

  @override
  String get sunnahRoutineEveningTitle => 'Evening dhikr';

  @override
  String get sunnahRoutineEveningSubtitle => 'Welcome the evening with remembrance';

  @override
  String get sunnahRoutineEveningPointsRaw => 'Say Subhanallahi wa bihamdihi one hundred times in the evening.';

  @override
  String get sunnahRoutineEveningPractice => 'Return to the Morning & evening collection as the day draws to a close.';

  @override
  String get sunnahRoutineNightSafetyTitle => 'Settle the home';

  @override
  String get sunnahRoutineNightSafetySubtitle => 'A little care before bedtime';

  @override
  String get sunnahRoutineNightSafetyPointsRaw => 'Cover food and drink vessels.||Close the doors before sleeping.||Extinguish lamps with flames and other open fires safely.';

  @override
  String get sunnahRoutineNightSafetyPractice => 'Include these steps in your nightly household routine.';

  @override
  String get sunnahRoutineBedtimeRecitationTitle => 'Bedtime recitation';

  @override
  String get sunnahRoutineBedtimeRecitationSubtitle => 'Close the day with Quran';

  @override
  String get sunnahRoutineBedtimeRecitationPointsRaw => 'Recite Al-Ikhlas, Al-Falaq and An-Nas into cupped hands, blow lightly and wipe over the body; repeat three times.||Recite Ayat al-Kursi before sleeping.||Recite the final two verses of Al-Baqarah at night.';

  @override
  String get sunnahRoutineBedtimeRecitationPractice => 'Learn these passages gradually and keep the routine steady.';

  @override
  String get sunnahRoutineSleepTitle => 'Go to sleep';

  @override
  String get sunnahRoutineSleepSubtitle => 'Rest with trust in Allah';

  @override
  String get sunnahRoutineSleepPointsRaw => 'Perform wudu before going to bed.||Dust the bed before lying down.||Lie on your right side and recite the sleeping du\'a.';

  @override
  String get sunnahRoutineSleepPractice => 'Keep the routine simple enough to follow on tired nights.';

  @override
  String get sunnahRoutineForgivenessTitle => 'Seeking forgiveness';

  @override
  String get sunnahRoutineForgivenessSubtitle => 'Return to Allah, again and again';

  @override
  String get sunnahRoutineForgivenessPointsRaw => 'Make seeking forgiveness a regular part of your day.||Turn back sincerely and try to leave the wrong behind.';

  @override
  String get sunnahRoutineForgivenessPractice => 'The Prophet ﷺ sought forgiveness and repented to Allah a hundred times a day.';

  @override
  String get sunnahRoutineDifficultyTitle => 'In difficulty';

  @override
  String get sunnahRoutineDifficultySubtitle => 'Words of trust when life feels heavy';

  @override
  String get sunnahRoutineDifficultyPointsRaw => 'Recite this du\'a in distress.||Reflect on Allah\'s greatness and forbearance.';

  @override
  String get sunnahRoutineDifficultyPractice => 'Read slowly and attentively when facing hardship.';

  @override
  String get sunnahRoutineMorningEveningTitle => 'Morning & evening';

  @override
  String get sunnahRoutineMorningEveningSubtitle => 'A daily rhythm of remembrance';

  @override
  String get sunnahRoutineMorningEveningPointsRaw => 'Say Subhanallahi wa bihamdihi one hundred times in the morning and one hundred times in the evening.';

  @override
  String get sunnahRoutineMorningEveningPractice => 'Keep a quiet moment for remembrance at both ends of your day.';

  @override
  String get sunnahRoutineGratitudeTitle => 'Gratitude';

  @override
  String get sunnahRoutineGratitudeSubtitle => 'Notice the blessings around you';

  @override
  String get sunnahRoutineGratitudePointsRaw => 'Ask Allah to help you be thankful.||Ask for the ability to do good deeds that please Him.';

  @override
  String get sunnahRoutineGratitudePractice => 'This Quranic supplication is from the prayer of Sulayman عليه السلام.';

  @override
  String get sunnahRoutineFastingTitle => 'Sunnah fasting';

  @override
  String get sunnahRoutineFastingSubtitle => 'Make room for voluntary worship';

  @override
  String get sunnahRoutineFastingPointsRaw => 'Take suhur and break your fast promptly once the sun has set.||Consider fasting on Mondays when able.||Learn about the six fasts of Shawwal.';

  @override
  String get sunnahRoutineFastingPractice => 'Build a sustainable voluntary practice alongside your obligations.';

  @override
  String get sunnahRoutineWakeUpSource => 'Sahih al-Bukhari 6312, 245';

  @override
  String get sunnahRoutineWashroomSource => 'Sahih al-Bukhari 142, 154; Jami’ at-Tirmidhi 7';

  @override
  String get sunnahRoutineMiswakSource => 'Sahih al-Bukhari 245, 887';

  @override
  String get sunnahRoutineWuduSource => 'Sahih al-Bukhari 159; Sahih Muslim 234a';

  @override
  String get sunnahRoutineDressingSource => 'Sahih al-Bukhari 168, 5856';

  @override
  String get sunnahRoutineAdhanSource => 'Sahih Muslim 384, 385';

  @override
  String get sunnahRoutineMasjidSource => 'Sahih al-Bukhari 636, 444; Sahih Muslim 713a';

  @override
  String get sunnahRoutineAfterPrayerSource => 'Sahih Muslim 591, 597a';

  @override
  String get sunnahRoutineMorningSource => 'Sahih Muslim 2692';

  @override
  String get sunnahRoutineDuhaSource => 'Sahih Muslim 720';

  @override
  String get sunnahRoutineLeavingHomeSource => 'Sunan Abi Dawud 5095';

  @override
  String get sunnahRoutineEatingSource => 'Sahih al-Bukhari 5376, 5409; Jami’ at-Tirmidhi 2380';

  @override
  String get sunnahRoutineDrinkingSource => 'Sahih al-Bukhari 5630, 5631; Sahih Muslim 2020, 2734a';

  @override
  String get sunnahRoutineGreetingsSource => 'Sahih Muslim 54a; Jami’ at-Tirmidhi 1956';

  @override
  String get sunnahRoutineSpeechSource => 'Sahih al-Bukhari 6018; Sahih Muslim 2594a';

  @override
  String get sunnahRoutineSneezingSource => 'Sahih al-Bukhari 6224; Sahih Muslim 2995a';

  @override
  String get sunnahRoutineReturningHomeSource => 'Sahih Muslim 2018a; Quran 24:61';

  @override
  String get sunnahRoutineFamilySource => 'Sahih al-Bukhari 676; Jami’ at-Tirmidhi 3895';

  @override
  String get sunnahRoutineEveningSource => 'Sahih Muslim 2692';

  @override
  String get sunnahRoutineNightSafetySource => 'Sahih al-Bukhari 6295';

  @override
  String get sunnahRoutineBedtimeRecitationSource => 'Sahih al-Bukhari 5017, 2311, 5009';

  @override
  String get sunnahRoutineSleepSource => 'Sahih al-Bukhari 247, 6320, 6312';

  @override
  String get sunnahRoutineForgivenessSource => 'Sahih Muslim 2702a';

  @override
  String get sunnahRoutineDifficultySource => 'Sahih al-Bukhari 6346';

  @override
  String get sunnahRoutineMorningEveningSource => 'Sahih Muslim 2692';

  @override
  String get sunnahRoutineGratitudeSource => 'Quran 27:19';

  @override
  String get sunnahRoutineFastingSource => 'Sahih al-Bukhari 1923, 1957; Sahih Muslim 1162, 1164; Sahih al-Bukhari 1894';

  @override
  String get sunnahRecitationWakeArabic => 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ';

  @override
  String get sunnahRecitationWakePronunciation => 'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur.';

  @override
  String get sunnahRecitationWakeTranslation => 'Praise belongs to Allah, who gave us life after causing us to die; to Him is the resurrection.';

  @override
  String get sunnahRecitationWashroomArabic => 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ\n\nغُفْرَانَكَ';

  @override
  String get sunnahRecitationWashroomPronunciation => 'Before entering: Allahumma inni a\'udhu bika minal-khubuthi wal-khaba\'ith.\nAfter leaving: Ghufranak.';

  @override
  String get sunnahRecitationWashroomTranslation => 'Before entering: O Allah, I seek Your protection from male and female devils.\nAfter leaving: I ask Your forgiveness.';

  @override
  String get sunnahRecitationWuduArabic => 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ';

  @override
  String get sunnahRecitationWuduPronunciation => 'Ashhadu an la ilaha illallahu wahdahu la sharika lahu, wa ashhadu anna Muhammadan \'abduhu wa rasuluh.';

  @override
  String get sunnahRecitationWuduTranslation => 'I testify that none is worthy of worship but Allah alone, without partner, and that Muhammad is His servant and messenger.';

  @override
  String get sunnahRecitationMasjidArabic => 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ\n\nاللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ';

  @override
  String get sunnahRecitationMasjidPronunciation => 'Entering: Allahummaftah li abwaba rahmatik.\nLeaving: Allahumma inni as\'aluka min fadlik.';

  @override
  String get sunnahRecitationMasjidTranslation => 'Entering: O Allah, open the doors of Your mercy for me.\nLeaving: O Allah, I ask You for Your bounty.';

  @override
  String get sunnahRecitationAfterPrayerArabic => 'أَسْتَغْفِرُ اللَّهَ\nاللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ ذَا الْجَلَالِ وَالْإِكْرَامِ';

  @override
  String get sunnahRecitationAfterPrayerPronunciation => 'Astaghfirullah (three times).\nAllahumma antas-salamu wa minkas-salam, tabarakta dhal-jalali wal-ikram.';

  @override
  String get sunnahRecitationAfterPrayerTranslation => 'I ask Allah\'s forgiveness.\nO Allah, You are Peace and from You comes peace. Blessed are You, Possessor of majesty and honour.';

  @override
  String get sunnahRecitationLeavingHomeArabic => 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ';

  @override
  String get sunnahRecitationLeavingHomePronunciation => 'Bismillahi tawakkaltu \'alallah, wa la hawla wa la quwwata illa billah.';

  @override
  String get sunnahRecitationLeavingHomeTranslation => 'In Allah\'s name, I put my trust in Allah. There is no might or power except through Allah.';

  @override
  String get sunnahRecitationEatingArabic => 'بِسْمِ اللَّهِ';

  @override
  String get sunnahRecitationEatingPronunciation => 'Bismillah.';

  @override
  String get sunnahRecitationEatingTranslation => 'In the name of Allah.';

  @override
  String get sunnahRecitationSneezingArabic => 'الْحَمْدُ لِلَّهِ\nيَرْحَمُكَ اللَّهُ\nيَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ';

  @override
  String get sunnahRecitationSneezingPronunciation => 'Alhamdulillah.\nYarhamukallah.\nYahdikumullahu wa yuslihu balakum.';

  @override
  String get sunnahRecitationSneezingTranslation => 'Praise belongs to Allah.\nMay Allah have mercy on you.\nMay Allah guide you and set your affairs right.';

  @override
  String get sunnahRecitationSleepArabic => 'بِاسْمِكَ أَمُوتُ وَأَحْيَا';

  @override
  String get sunnahRecitationSleepPronunciation => 'Bismika amutu wa ahya.';

  @override
  String get sunnahRecitationSleepTranslation => 'In Your name I die and I live.';

  @override
  String get sunnahRecitationForgivenessArabic => 'أَسْتَغْفِرُ اللَّهَ';

  @override
  String get sunnahRecitationForgivenessPronunciation => 'Astaghfirullah.';

  @override
  String get sunnahRecitationForgivenessTranslation => 'I ask Allah for forgiveness.';

  @override
  String get sunnahRecitationDifficultyArabic => 'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ';

  @override
  String get sunnahRecitationDifficultyPronunciation => 'La ilaha illallahul-\'azimul-halim. La ilaha illallahu rabbul-\'arshil-\'azim. La ilaha illallahu rabbus-samawati wa rabbul-ardi wa rabbul-\'arshil-karim.';

  @override
  String get sunnahRecitationDifficultyTranslation => 'None is worthy of worship but Allah, the Magnificent, the Forbearing. None is worthy of worship but Allah, Lord of the mighty Throne. None is worthy of worship but Allah, Lord of the heavens, the earth and the noble Throne.';

  @override
  String get sunnahRecitationRemembranceArabic => 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ';

  @override
  String get sunnahRecitationRemembrancePronunciation => 'Subhanallahi wa bihamdihi.';

  @override
  String get sunnahRecitationRemembranceTranslation => 'Glory and praise belong to Allah.';

  @override
  String get sunnahRecitationGratitudeArabic => 'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ';

  @override
  String get sunnahRecitationGratitudePronunciation => 'Rabbi awzi\'ni an ashkura ni\'matakal-lati an\'amta \'alayya wa \'ala walidayya wa an a\'mala salihan tardahu wa adkhilni birahmatika fi \'ibadikas-salihin.';

  @override
  String get sunnahRecitationGratitudeTranslation => 'My Lord, enable me to thank You for the blessings You have given me and my parents, to do good that pleases You, and admit me by Your mercy among Your righteous servants.';

  @override
  String get sunnahRecitationFastingArabic => 'الصِّيَامُ جُنَّةٌ';

  @override
  String get sunnahRecitationFastingPronunciation => 'As-siyamu junnah.';

  @override
  String get sunnahRecitationFastingTranslation => 'Fasting is a shield.';

  @override
  String get sunnahDuaTitle => 'Sunnah & Du\'a';

  @override
  String get sunnahDuaHeroEyebrow => 'Daily practice';

  @override
  String get sunnahDuaHeroBody => 'Whole Sunnah practices with related du\'as placed inside them, plus standalone du\'as and dhikr.';

  @override
  String get sunnahDuaHeroArabic => 'سُنَّة وَدُعَاء';

  @override
  String get sunnahDuaHeroStatGrid => 'Grid';

  @override
  String get sunnahDuaFilterAll => 'All';

  @override
  String get sunnahDuaFilterSunnah => 'Sunnah';

  @override
  String get sunnahDuaFilterDua => 'Du\'a';

  @override
  String get sunnahDuaFilterDhikr => 'Dhikr';

  @override
  String get sunnahDuaKindSunnah => 'Sunnah';

  @override
  String get sunnahDuaKindDua => 'Du\'a';

  @override
  String get sunnahDuaKindDhikr => 'Dhikr';

  @override
  String get sunnahDuaGridTitle => 'Sunnah Amal';

  @override
  String sunnahDuaItemsCount(int count) {
    return '$count items';
  }

  @override
  String get sunnahDuaSourceLabel => 'Source';

  @override
  String get sunnahDuaArabicLabel => 'Arabic';

  @override
  String get sunnahDuaPronunciationLabel => 'Pronunciation';

  @override
  String get sunnahDuaTranslationLabel => 'Meaning';

  @override
  String get sunnahDuaPracticeLabel => 'Practice note';

  @override
  String get sunnahDuaSunnahPointsLabel => 'Sunnah practice';

  @override
  String get sunnahDuaRelatedDuaLabel => 'Related du\'a';

  @override
  String get sunnahDuaDuaIncludedLabel => 'Du\'a included';

  @override
  String get sunnahDuaSourceDailySunnah => 'Daily Sunnah practice';

  @override
  String get sunnahDuaSourceDailyDua => 'Daily du\'a collection';

  @override
  String get sunnahDuaEatingSunnahsTitle => 'Eating Sunnahs';

  @override
  String get sunnahDuaEatingSunnahsSubtitle => 'The du\'a is one part of the whole eating adab';

  @override
  String get sunnahDuaEatingSunnahsPointsRaw => 'Begin with Allah\'s name before eating.||Eat with the right hand.||Eat from the food nearest to you.||Avoid criticizing food and stop before overfilling yourself.';

  @override
  String get sunnahDuaEatingSunnahsPractice => 'Use the card as a small checklist at meals. Say the du\'a, then keep the manners through the whole meal.';

  @override
  String get sunnahDuaMiswakTitle => 'Miswakh';

  @override
  String get sunnahDuaMiswakSubtitle => 'Freshen the mouth before worship';

  @override
  String get sunnahDuaMiswakPointsRaw => 'Use it before wudu or prayer when easy.||Keep the mouth clean before Quran recitation.||Refresh the mouth after waking or before sleep.||Keep the miswakh clean and replace it when worn.';

  @override
  String get sunnahDuaMiswakArabic => 'السِّوَاك';

  @override
  String get sunnahDuaMiswakPronunciation => 'As-siwak';

  @override
  String get sunnahDuaMiswakTranslation => 'Using miswak, or cleaning the teeth when miswak is unavailable, keeps the mouth ready for prayer, wudu, and recitation.';

  @override
  String get sunnahDuaMiswakPractice => 'Keep a miswak near your wudu space or prayer mat so this sunnah becomes an easy daily habit.';

  @override
  String get sunnahDuaMiswakSource => 'Sunnah of purification';

  @override
  String get sunnahDuaSleepingSunnahsTitle => 'Sleeping Sunnahs';

  @override
  String get sunnahDuaSleepingSunnahsSubtitle => 'End the day with remembrance and calm';

  @override
  String get sunnahDuaSleepingSunnahsPointsRaw => 'Make wudu before sleep when you are able.||Dust or check the bed before lying down.||Sleep on the right side.||Close the day with the sleeping du\'a and remembrance.';

  @override
  String get sunnahDuaSleepingSunnahsPractice => 'Keep the sleep routine short and repeatable so it survives tired nights too.';

  @override
  String get sunnahDuaHomeSunnahsTitle => 'Home Sunnahs';

  @override
  String get sunnahDuaHomeSunnahsSubtitle => 'Enter and leave with salam, remembrance, and trust';

  @override
  String get sunnahDuaHomeSunnahsPointsRaw => 'Say bismillah when entering.||Give salam to the people at home.||Leave home with trust in Allah.||Make the first and last moments at home peaceful.';

  @override
  String get sunnahDuaHomeSunnahsPractice => 'Attach this routine to the doorway so the habit triggers naturally.';

  @override
  String get sunnahDuaWuduSunnahsTitle => 'Wudu Sunnahs';

  @override
  String get sunnahDuaWuduSunnahsSubtitle => 'Purification with mindful details';

  @override
  String get sunnahDuaWuduSunnahsPointsRaw => 'Begin with Allah\'s name.||Wash carefully without wasting water.||Give each limb its due attention.||Finish with the testimony after wudu.';

  @override
  String get sunnahDuaWuduSunnahsPractice => 'Slow down enough that wudu feels like preparation for salah, not just a task.';

  @override
  String get sunnahDuaSiyamSunnahsTitle => 'Siyam';

  @override
  String get sunnahDuaSiyamSunnahsSubtitle => 'Sunnah fasting beyond Ramadan';

  @override
  String get sunnahDuaSiyamSunnahsPointsRaw => 'Keep the intention sincere and clear before the fast.||Guard the fast beyond food and drink: protect speech, anger, eyes, and actions.||Fast Mondays and Thursdays when you are able.||Keep three days each lunar month, especially Ayyam al-Bid: the 13th, 14th, and 15th.||Remember special sunnah fasts: six days of Shawwal, Ashura, and the day of Arafah for those not at Hajj.||Take suhur close to Fajr and hasten iftar after sunset.||Break the fast with dates or water and make du\'a at iftar.||Do not harm yourself; leave voluntary fasts when sick, travelling, or when duties would be neglected.';

  @override
  String get sunnahDuaSiyamArabic => 'الصِّيَامُ جُنَّةٌ';

  @override
  String get sunnahDuaSiyamPronunciation => 'As-siyamu junnah';

  @override
  String get sunnahDuaSiyamTranslation => 'Fasting is a shield.';

  @override
  String get sunnahDuaSiyamSunnahsPractice => 'Start with one sustainable sunnah fast, then build slowly. The goal is not just hunger; it is taqwa, restraint, gratitude, and a cleaner heart before Allah.';

  @override
  String get sunnahDuaSiyamSource => 'Sahih al-Bukhari 1894; Sahih Muslim 1151, 1162, 1164; Jami\' at-Tirmidhi 761';

  @override
  String get sunnahDuaMasjidSunnahsTitle => 'Masjid Sunnahs';

  @override
  String get sunnahDuaMasjidSunnahsSubtitle => 'Enter the masjid with mercy and composure';

  @override
  String get sunnahDuaMasjidSunnahsPointsRaw => 'Enter calmly and avoid rushing.||Ask Allah to open the doors of mercy.||Keep the phone and talk quiet.||Leave with gratitude and ask Allah from His bounty.';

  @override
  String get sunnahDuaMasjidSunnahsPractice => 'Let the masjid doorway become a reminder to lower noise, hurry, and distraction.';

  @override
  String get sunnahDuaSneezingSunnahTitle => 'Sneezing Sunnah';

  @override
  String get sunnahDuaSneezingSunnahSubtitle => 'A tiny moment of gratitude and mercy';

  @override
  String get sunnahDuaSneezingSunnahPointsRaw => 'Say alhamdulillah after sneezing.||A listener responds with mercy.||The sneezer replies with guidance and goodness.||Keep the exchange gentle and brief.';

  @override
  String get sunnahDuaSneezingSunnahPractice => 'This is small, but it turns an ordinary moment into gratitude and care.';

  @override
  String get sunnahDuaSeekingForgivenessSubtitle => 'Keep istighfar close';

  @override
  String get sunnahDuaSeekingForgivenessPractice => 'Repeat it between tasks, after salah, or whenever the heart feels heavy.';

  @override
  String get sunnahDuaDifficultySubtitle => 'When the heart feels crowded';

  @override
  String get sunnahDuaDifficultyPractice => 'Read it slowly, then choose the next right action with trust in Allah.';

  @override
  String get dashboardSectionPrayerTimes => 'Prayer Times';

  @override
  String get dashboardActionFullPrayerView => 'Full Prayer View';

  @override
  String get dashboardActionQiblaCompass => 'Qibla Compass';

  @override
  String get dashboardActionQiblaCompassSub => 'Find qibla direction';

  @override
  String get dashboardActionHijriCalendar => 'Hijri Calendar';

  @override
  String get dashboardActionHijriCalendarSub => 'Islamic date finder';

  @override
  String get dashboardSectionDua => 'Duah';

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
  String get dashboardActionSunnahDua => 'Sunnah & Du\'a';

  @override
  String get dashboardActionSunnahDuaSub => 'Habits & daily duas';

  @override
  String get dashboardSectionOthers => 'Others';

  @override
  String get dashboardActionTasbeeh => 'Tasbeeh';

  @override
  String get dashboardActionTasbeehSub => 'Counter & dhikr';

  @override
  String get dashboardSectionHadith => 'Hadith';

  @override
  String get tasbeehTitle => 'Tasbeeh Counter';

  @override
  String get tasbeehSubtitle => 'Count dhikr with focus';

  @override
  String get tasbeehPhraseTitle => 'Dhikr';

  @override
  String get tasbeehPhraseSubhanAllah => 'SubhanAllah';

  @override
  String get tasbeehPhraseAlhamdulillah => 'Alhamdulillah';

  @override
  String get tasbeehPhraseAllahuAkbar => 'Allahu Akbar';

  @override
  String get tasbeehPhraseLaIlahaIllallah => 'La ilaha illallah';

  @override
  String get tasbeehTarget => 'Target';

  @override
  String get tasbeehTargetReached => 'Target reached';

  @override
  String get tasbeehCurrent => 'Current';

  @override
  String get tasbeehTotal => 'Total';

  @override
  String get tasbeehRounds => 'Rounds';

  @override
  String get tasbeehUndo => 'Undo';

  @override
  String get tasbeehReset => 'Reset';

  @override
  String get tasbeehResetAll => 'Reset all';

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
  String get dashboardCurrentPrayer => 'Current Prayer';

  @override
  String get dashboardNextPrayer => 'Next Prayer';

  @override
  String get dashboardNextShortLabel => 'Next';

  @override
  String get dashboardNowShortLabel => 'Now';

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
  String get dashboardHadithAnNawawiDescription => 'The classical collection by Imam An-Nawawi';

  @override
  String get dashboardHadithShortTitle => 'Forty Short Hadith';

  @override
  String get dashboardHadithShortDescription => 'Short hadith for easy memorization & practice';

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
  String get prayerViewPermissionHelpBody => 'Enable location permission to calculate local prayer times. The guidance below still stays available.';

  @override
  String get prayerTimesPermissionDeniedTitle => 'Location permission needed';

  @override
  String get prayerTimesPermissionDeniedBody => 'Allow location access to calculate prayer times for your area. You can still use the guidance sections without live times.';

  @override
  String get prayerTimesPermissionDeniedForeverTitle => 'Location permission is blocked';

  @override
  String get prayerTimesPermissionDeniedForeverBody => 'Open app settings and allow location access, then refresh prayer times.';

  @override
  String get prayerTimesLocationDisabledTitle => 'Location services are off';

  @override
  String get prayerTimesLocationDisabledBody => 'Turn on device location services, then refresh to calculate local prayer times.';

  @override
  String get prayerTimesNetworkErrorTitle => 'Could not prepare prayer times';

  @override
  String get prayerTimesNetworkErrorBody => 'Check your connection and device location settings, then try again.';

  @override
  String get compassTitle => 'Compass';

  @override
  String get compassInitializing => 'Initializing compass...';

  @override
  String get compassRetry => 'Retry';

  @override
  String get compassNativeActive => 'Native compass active';

  @override
  String get compassHeadingLabel => 'Heading';

  @override
  String get compassQiblaOffsetLabel => 'Qibla offset';

  @override
  String get compassAccuracyLabel => 'Accuracy';

  @override
  String get compassNotAvailableShort => 'N/A';

  @override
  String get compassApiAccuracyLabel => 'API';

  @override
  String get compassNativeAccuracyLabel => '±2°';

  @override
  String get compassFacingMeccaLabel => 'Facing Mecca!';

  @override
  String get compassRotateToAlignLabel => 'Rotate to align';

  @override
  String get compassApiFallbackTitle => 'Compass sensor unavailable';

  @override
  String get compassApiFallbackBody => 'Your device does not expose a native compass sensor. We can calculate the Qibla angle from your location, but live rotation needs a compass-capable device.';

  @override
  String compassApiFallbackQibla(String degrees) {
    return 'Qibla angle: $degrees°';
  }

  @override
  String get compassLocationDeniedTitle => 'Location permission needed';

  @override
  String get compassLocationDeniedBody => 'Allow location access so Qibla can be calculated from your current position.';

  @override
  String get compassLocationBlockedTitle => 'Location permission is blocked';

  @override
  String get compassLocationBlockedBody => 'Open app settings and allow location access, then retry the Qibla compass.';

  @override
  String get compassLocationDisabledTitle => 'Location services are off';

  @override
  String get compassLocationDisabledBody => 'Turn on device location services, then retry the Qibla compass.';

  @override
  String get compassGenericErrorTitle => 'Compass could not start';

  @override
  String get compassGenericErrorBody => 'Check location permission, sensor availability, and your connection, then try again.';

  @override
  String get prayerViewTimelineTitle => 'Today\'s Prayer Rhythm';

  @override
  String get prayerViewTimelineSubtitle => 'Scan the full day, spot the next prayer, and keep the current focus visible.';

  @override
  String get prayerRakatGuideTitle => 'Rakat Guide';

  @override
  String get prayerRakatGuideSubtitle => 'See the common daily prayer count and how each salah is divided.';

  @override
  String get prayerRakatViewDetails => 'View details';

  @override
  String prayerRakatTotalLabel(int count) {
    return '$count rak\'ahs';
  }

  @override
  String get prayerRakatUnitLabel => 'rak\'ahs';

  @override
  String get prayerRakatTypeFard => 'Fard';

  @override
  String get prayerRakatTypeSunnahMuakkadah => 'Sunnah Mu\'akkadah';

  @override
  String get prayerRakatTypeSunnahGhairMuakkadah => 'Sunnah Ghair Mu\'akkadah';

  @override
  String get prayerRakatTypeNafl => 'Nafl';

  @override
  String get prayerRakatTypeWitr => 'Witr';

  @override
  String get prayerRakatBeforeFardLabel => 'Before fard';

  @override
  String get prayerRakatFardLabel => 'Obligatory';

  @override
  String get prayerRakatAfterFardLabel => 'After fard';

  @override
  String get prayerRakatOptionalLabel => 'Optional';

  @override
  String get prayerRakatWitrLabel => 'After Isha';

  @override
  String get prayerRakatFajrNote => 'The 2 sunnah before Fajr are strongly emphasized.';

  @override
  String get prayerRakatDhuhrNote => 'A common flow is 4 sunnah, 4 fard, 2 sunnah, then optional nafl.';

  @override
  String get prayerRakatAsrNote => 'The 4 sunnah before Asr are generally treated as non-emphasized.';

  @override
  String get prayerRakatMaghribNote => 'Pray the 3 fard first, then the emphasized sunnah and optional nafl.';

  @override
  String get prayerRakatIshaNote => 'Witr details vary by school; many communities pray 3 after Isha.';

  @override
  String get prayerViewNowTitle => 'What to follow now';

  @override
  String get prayerViewNowSubtitle => 'A practical next move for the current prayer window.';

  @override
  String get prayerViewSuggestionsTitle => 'Prayer suggestions';

  @override
  String get prayerViewSuggestionsSubtitle => 'Small actions that make this salah feel calmer and more intentional.';

  @override
  String get prayerViewHowTitle => 'How to pray';

  @override
  String get prayerViewHowSubtitle => 'A simple flow for the core movements and presence of salah.';

  @override
  String get prayerViewBestPracticesTitle => 'Best practices';

  @override
  String get prayerViewBestPracticesSubtitle => 'Focused habits tailored to the prayer currently in view.';

  @override
  String get prayerViewFiqhNoteTitle => 'Practice note';

  @override
  String get prayerViewFiqhNoteBody => 'Details can vary by madhhab and local teaching. Use this as friendly guidance and follow a trusted scholar or imam for fiqh-specific rulings.';

  @override
  String get prayerViewFocus => 'Focus';

  @override
  String get prayerViewNow => 'Now';

  @override
  String get prayerViewNext => 'Next';

  @override
  String get prayerViewPassed => 'Passed';

  @override
  String get prayerViewSoon => 'Soon';

  @override
  String get prayerForbiddenTimesTitle => 'Forbidden Times';

  @override
  String get prayerForbiddenTimesSubtitle => 'Short windows where starting voluntary salah should be avoided.';

  @override
  String get prayerForbiddenAlertTitle => 'Pause voluntary prayer here';

  @override
  String get prayerForbiddenAlertBody => 'Keep dhikr, Quran listening, or quiet reflection, then pray again once the window clears. Fiqh details can vary, so follow a trusted scholar for specific rulings.';

  @override
  String get prayerForbiddenPauseLabel => 'PAUSE';

  @override
  String get prayerForbiddenSunriseTitle => 'At sunrise';

  @override
  String get prayerForbiddenSunriseBody => 'Avoid beginning voluntary prayer while the sun is rising; wait until it has clearly risen.';

  @override
  String get prayerForbiddenZenithTitle => 'At zenith';

  @override
  String get prayerForbiddenZenithBody => 'Pause optional salah when the sun is at its highest point, just before Dhuhr enters.';

  @override
  String get prayerForbiddenSunsetTitle => 'At sunset';

  @override
  String get prayerForbiddenSunsetBody => 'Avoid starting voluntary prayer as the sun is setting; pray Maghrib when its time begins.';

  @override
  String get prayerForbiddenTimeFallback => 'Time unavailable';

  @override
  String prayerForbiddenAroundTime(String time) {
    return 'Around $time';
  }

  @override
  String prayerForbiddenBeforeTime(String time) {
    return 'Before $time';
  }

  @override
  String get prayerReferenceTitle => 'Guidance Library';

  @override
  String get prayerReferenceSubtitle => 'Open the details only when you need them, so the main prayer view stays calm.';

  @override
  String get prayerReferenceMovementsActionTitle => 'Salah Movement Guide';

  @override
  String get prayerReferenceMovementsActionSubtitle => 'See every position with Arabic recitation, pronunciation, and meaning.';

  @override
  String get prayerReferenceForbiddenActionTitle => 'Forbidden Times';

  @override
  String get prayerReferenceForbiddenActionSubtitle => 'Know when to pause voluntary salah.';

  @override
  String get prayerReferenceNafalActionTitle => 'Daily Nafal Prayers';

  @override
  String get prayerReferenceNafalActionSubtitle => 'Tahajjud, Ishraq, Duha, and Awwabin in one daily flow.';

  @override
  String get prayerReferenceJanazaActionTitle => 'Janaja Prayer';

  @override
  String get prayerReferenceJanazaActionSubtitle => 'A standing mercy prayer with four takbirs and sincere du\'a.';

  @override
  String get prayerReferenceTasbeehActionTitle => 'Salatul Tasbeeh';

  @override
  String get prayerReferenceTasbeehActionSubtitle => 'Follow the 300-tasbih rhythm across four rak\'ahs.';

  @override
  String get prayerReferenceOpenLabel => 'View';

  @override
  String get prayerMovementsTitle => 'Salah Movement Guide';

  @override
  String get prayerMovementsHeroEyebrow => 'Prayer in motion';

  @override
  String get prayerMovementsHeroTitle => 'Pray with clarity, calm, and meaning';

  @override
  String get prayerMovementsHeroBody => 'A visual walkthrough from takbir to dhikr, pairing each posture with the Arabic words, pronunciation, and translation.';

  @override
  String prayerMovementsHeroStepsCount(int count) {
    return '$count positions';
  }

  @override
  String get prayerMovementsHeroArabicLabel => 'Arabic + meaning';

  @override
  String get prayerMovementsHeroHadithLabel => 'Hadith notes';

  @override
  String get prayerMovementsSequenceTitle => 'Movement sequence';

  @override
  String get prayerMovementsSequenceSubtitle => 'Follow the flow from opening takbir to post-prayer dhikr, one settled posture at a time.';

  @override
  String get prayerMovementsArabicLabel => 'Arabic to recite';

  @override
  String get prayerMovementsPronunciationLabel => 'Pronunciation';

  @override
  String get prayerMovementsTranslationLabel => 'Translation';

  @override
  String get prayerMovementsNoteLabel => 'Practice note';

  @override
  String get prayerMovementsHadithTitle => 'Hadith anchors';

  @override
  String get prayerMovementsHadithSubtitle => 'Short reminders that keep the demonstration rooted in sunnah, calmness, and presence.';

  @override
  String get prayerMovementsHadithSourceLabel => 'Source';

  @override
  String get prayerMovementsFiqhNoteTitle => 'Respectful variation note';

  @override
  String get prayerMovementsFiqhNoteBody => 'Hand placement, finger movement, and some wordings can vary by madhhab and teacher. Use this as a friendly demonstration and follow trusted local guidance for rulings.';

  @override
  String get prayerNafalTitle => 'Daily Nafal Prayers';

  @override
  String get prayerNafalSubtitle => 'A graceful optional-prayer rhythm for morning, daylight, evening, and night.';

  @override
  String get prayerNafalArabicLabel => 'نفل';

  @override
  String get prayerNafalDailyFlowLabel => 'Daily flow';

  @override
  String get prayerNafalFlexibleLabel => 'Flexible raka\'ahs';

  @override
  String get prayerNafalTimeLabel => 'Time';

  @override
  String get prayerNafalRakahLabel => 'Raka\'ahs';

  @override
  String get prayerNafalBenefitLabel => 'Benefit';

  @override
  String get prayerNafalHadithReferencesLabel => 'Hadith references';

  @override
  String get prayerNafalNoteTitle => 'Gentle fiqh note';

  @override
  String get prayerNafalNoteBody => 'These are friendly reminders for common nafal windows. Details and rakah counts may vary by madhhab and teacher, so follow trusted local guidance for rulings.';

  @override
  String get prayerNafalTahajjudTitle => 'Tahajjud';

  @override
  String get prayerNafalTahajjudBadge => 'Deep night';

  @override
  String get prayerNafalTahajjudTime => 'Last third of the night before Fajr';

  @override
  String get prayerNafalTahajjudRakah => '2+';

  @override
  String get prayerNafalTahajjudBenefit => 'Turns the quiet night into du\'a, repentance, and deeper focus.';

  @override
  String get prayerNafalTahajjudBody => 'Wake gently, pray in pairs, and keep the recitation calm. Even two focused raka\'ahs can become the quietest anchor of the day.';

  @override
  String get prayerNafalTahajjudHadith1Source => 'Sahih Muslim 1163a';

  @override
  String get prayerNafalTahajjudHadith1Body => 'The best prayer after the obligatory prayer is night prayer.';

  @override
  String get prayerNafalIshraqTitle => 'Ishraq';

  @override
  String get prayerNafalIshraqBadge => 'After sunrise';

  @override
  String get prayerNafalIshraqTime => 'After sunrise has clearly passed';

  @override
  String get prayerNafalIshraqRakah => '2';

  @override
  String get prayerNafalIshraqBenefit => 'Connects Fajr, dhikr, and a hopeful start to the morning.';

  @override
  String get prayerNafalIshraqBody => 'Wait until the forbidden sunrise window clears, then begin with a light heart and a short, sincere prayer.';

  @override
  String get prayerNafalIshraqHadith1Source => 'Jami\' at-Tirmidhi 586';

  @override
  String get prayerNafalIshraqHadith1Body => 'Fajr in congregation, dhikr until sunrise, then two raka\'ahs is reported with Hajj and Umrah reward.';

  @override
  String get prayerNafalDuhaTitle => 'Duha / Chasht';

  @override
  String get prayerNafalDuhaBadge => 'Bright morning';

  @override
  String get prayerNafalDuhaTime => 'Mid-morning until before Dhuhr';

  @override
  String get prayerNafalDuhaRakah => '2-8';

  @override
  String get prayerNafalDuhaBenefit => 'Refreshes gratitude and covers the morning charity due from the body.';

  @override
  String get prayerNafalDuhaBody => 'Use the morning stretch for gratitude, provision, and renewed energy before the day gets heavy.';

  @override
  String get prayerNafalDuhaHadith1Source => 'Sahih Muslim 720';

  @override
  String get prayerNafalDuhaHadith1Body => 'Two raka\'ahs of Duha suffice for the morning charity due from every joint.';

  @override
  String get prayerNafalDuhaHadith2Source => 'Sahih al-Bukhari 1178; Sahih Muslim 721a';

  @override
  String get prayerNafalDuhaHadith2Body => 'Abu Hurayrah was advised to keep Duha among regular acts.';

  @override
  String get prayerNafalAwwabinTitle => 'Awwabin';

  @override
  String get prayerNafalAwwabinBadge => 'Evening return';

  @override
  String get prayerNafalAwwabinTime => 'After Maghrib sunnah, before Isha';

  @override
  String get prayerNafalAwwabinRakah => '2-6';

  @override
  String get prayerNafalAwwabinBenefit => 'Keeps the Maghrib-Isha window alive with short extra raka\'ahs and dhikr.';

  @override
  String get prayerNafalAwwabinBody => 'Let the evening soften: return to Allah with short raka\'ahs, dhikr, and a quieter transition toward Isha.';

  @override
  String get prayerNafalAwwabinHadith1Source => 'Jami\' at-Tirmidhi 435; Sunan Ibn Majah 1167';

  @override
  String get prayerNafalAwwabinHadith1Body => 'Six raka\'ahs after Maghrib are reported; scholars discuss the report\'s strength.';

  @override
  String get prayerNafalAwwabinHadith2Source => 'Sahih Muslim 748b';

  @override
  String get prayerNafalAwwabinHadith2Body => 'The name Salat al-Awwabin is also authentically used for the Duha-time prayer.';

  @override
  String get prayerHowIntentionTitle => 'Intention & readiness';

  @override
  String get prayerHowIntentionBody => 'Make wudu, face the qibla, and settle your intention in the heart before you begin.';

  @override
  String get prayerHowQiyamTitle => 'Qiyam';

  @override
  String get prayerHowQiyamBody => 'Stand calmly, say the opening takbir, recite Al-Fatihah, then recite what is easy from the Quran.';

  @override
  String get prayerHowRukuTitle => 'Ruku';

  @override
  String get prayerHowRukuBody => 'Bow with the back settled, glorify Allah, then rise with calm before going down.';

  @override
  String get prayerHowSujoodTitle => 'Sujood';

  @override
  String get prayerHowSujoodBody => 'Prostrate with humility, pause without rushing, then sit briefly and complete the second prostration.';

  @override
  String get prayerHowTashahhudTitle => 'Tashahhud';

  @override
  String get prayerHowTashahhudBody => 'In the final sitting, recite tashahhud and send salawat upon the Prophet, peace be upon him.';

  @override
  String get prayerHowSalamTitle => 'Salam';

  @override
  String get prayerHowSalamBody => 'End the prayer with salam, then remain present for short dhikr and du\'a.';

  @override
  String get prayerFocusFajrTitle => 'Fajr Window';

  @override
  String get prayerFocusFajrSubtitle => 'Begin the day before the world gets loud.';

  @override
  String get prayerFocusSunriseTitle => 'Sunrise Pause';

  @override
  String get prayerFocusSunriseSubtitle => 'A quiet transition after Fajr; wait before optional Duha.';

  @override
  String get prayerFocusDhuhrTitle => 'Dhuhr Reset';

  @override
  String get prayerFocusDhuhrSubtitle => 'Let the middle of the day become a clean spiritual reset.';

  @override
  String get prayerFocusAsrTitle => 'Asr Guard';

  @override
  String get prayerFocusAsrSubtitle => 'Protect the late afternoon before tasks scatter your attention.';

  @override
  String get prayerFocusMaghribTitle => 'Maghrib Return';

  @override
  String get prayerFocusMaghribSubtitle => 'Move quickly from sunset into remembrance and gratitude.';

  @override
  String get prayerFocusIshaTitle => 'Isha Closure';

  @override
  String get prayerFocusIshaSubtitle => 'Close the day with calm, repentance, and preparation for Fajr.';

  @override
  String get prayerNowFajrTitle => 'Protect the dawn';

  @override
  String get prayerNowFajrBody => 'Before sunrise, protect the Fajr window. If you have not prayed, make wudu and pray now; if you have, stay with morning adhkar or Quran.';

  @override
  String get prayerNowSunriseTitle => 'Pause and remember';

  @override
  String get prayerNowSunriseBody => 'At exact sunrise avoid starting voluntary prayer; keep morning dhikr and wait until the sun has risen before Duha.';

  @override
  String get prayerNowDhuhrTitle => 'Reset the middle of the day';

  @override
  String get prayerNowDhuhrBody => 'Step away from work, renew wudu, and give the fard prayer an unhurried pocket of attention.';

  @override
  String get prayerNowAsrTitle => 'Guard the late afternoon';

  @override
  String get prayerNowAsrBody => 'Make Asr visible before the day becomes crowded. Pray with steady pace and leave a short moment for dhikr afterward.';

  @override
  String get prayerNowMaghribTitle => 'Move promptly';

  @override
  String get prayerNowMaghribBody => 'When Maghrib enters, shift quickly from sunset routines into salah, then return to family, food, or travel with a lighter heart.';

  @override
  String get prayerNowIshaTitle => 'Close the day cleanly';

  @override
  String get prayerNowIshaBody => 'Pray Isha before sleepiness takes over. Pair it with repentance, gratitude, and a simple plan for waking for Fajr.';

  @override
  String get prayerSuggestionsFajrRaw => 'Pray the two raka\'at Sunnah before the fard when you are able.||Keep the recitation calm and bright, even if it is short.||After salah, spend a few minutes with morning adhkar or a small Quran portion.';

  @override
  String get prayerSuggestionsSunriseRaw => 'Continue morning adhkar while the sun rises.||Wait until the disliked sunrise moment passes before optional Duha.||Use the quiet transition to plan the next prayer instead of drifting.';

  @override
  String get prayerSuggestionsDhuhrRaw => 'Use the adhan as a hard pause from work or study.||Choose a quiet place before the day becomes crowded again.||Pair the prayer with a small gratitude check before returning to tasks.';

  @override
  String get prayerSuggestionsAsrRaw => 'Plan Asr before the late-afternoon rush begins.||Keep the pace steady rather than compressed.||Use one minute after salam to ask Allah for protection and consistency.';

  @override
  String get prayerSuggestionsMaghribRaw => 'Pray soon after adhan because the window feels short in daily life.||Keep food, family, and commute transitions from swallowing the prayer.||Follow with evening adhkar when your routine allows.';

  @override
  String get prayerSuggestionsIshaRaw => 'Pray before sleepiness makes focus heavy.||Prepare for Witr according to your practice after Isha.||Set up tomorrow\'s Fajr before bed: alarm, wudu plan, and sleep intention.';

  @override
  String get prayerBestPracticesFajrRaw => 'Sleep with Fajr in mind, not as an afterthought.||Avoid rushing the first prayer of the day; let it set the tone.||Use the stillness after Fajr for Quran, adhkar, or one sincere du\'a.';

  @override
  String get prayerBestPracticesSunriseRaw => 'Do not treat sunrise as an obligatory prayer; it is a transition marker.||Stay away from voluntary prayer at the exact sunrise moment.||Return to optional worship after the sun has risen and the time is clear.';

  @override
  String get prayerBestPracticesDhuhrRaw => 'Put Dhuhr on the calendar before the workday takes over.||Stand without carrying the whole task list into salah.||If you pray Sunnah prayers, place them around the fard according to your learned practice.';

  @override
  String get prayerBestPracticesAsrRaw => 'Guard Asr from being pushed to the edge of the time.||Lower the pace before takbir so the prayer does not feel like a race.||Use Asr as an accountability checkpoint for the rest of the day.';

  @override
  String get prayerBestPracticesMaghribRaw => 'Respond quickly when Maghrib enters.||Keep sunset meals and gatherings from delaying the prayer.||Let Maghrib open your evening adhkar and family calm.';

  @override
  String get prayerBestPracticesIshaRaw => 'Pray before exhaustion dulls attention.||Keep Witr visible in the night routine according to your practice.||Prepare the body and room for Fajr before sleeping.';

  @override
  String get learnQuranTextMapRaw => '';

  @override
  String get dailyTrackerSectionTitle => 'Daily Tracker';

  @override
  String get dailyTrackerSectionSubtitle => 'Tap to view your full checklist';

  @override
  String dailyTrackerProgressLabel(int completed, int total) {
    return '$completed/$total completed';
  }

  @override
  String get dailyTrackerFullViewTitle => 'Daily Tracker';

  @override
  String get dailyTrackerOptionalBadge => 'Optional';

  @override
  String get dailyTrackerFridayBadge => 'Friday';

  @override
  String get dailyTrackerFridayBannerTitle => 'Jumu\'ah Mubarak!';

  @override
  String get dailyTrackerFridayBannerSubtitle => 'Special Friday tasks have been added to today\'s routine';

  @override
  String get dailyTrackerCategoryPrayer => 'Prayers';

  @override
  String get dailyTrackerCategoryNafl => 'Nafl Prayers';

  @override
  String get dailyTrackerCategoryDua => 'Daily Duas';

  @override
  String get dailyTrackerCategorySunnah => 'Sunnahs';

  @override
  String get dailyTrackerCategoryQuran => 'Quran';

  @override
  String get dailyTrackerCategoryTasbeeh => 'Tasbeeh';

  @override
  String get dailyTrackerCategoryHadith => 'Hadith';

  @override
  String get dailyTrackerCategoryCustom => 'My Tasks';

  @override
  String get dailyTrackerCelebrationTitle => 'MashaAllah! You completed today\'s routine!';

  @override
  String get dailyTrackerCelebrationButton => 'Alhamdulillah';

  @override
  String get dailyTrackerAddTaskTooltip => 'Add task';

  @override
  String get dailyTrackerAddTaskSheetTitle => 'New Task';

  @override
  String get dailyTrackerAddTaskNameLabel => 'Task name';

  @override
  String get dailyTrackerAddTaskNameHint => 'e.g. Read 10 pages of tafsir';

  @override
  String get dailyTrackerAddTaskNameEmptyError => 'Please enter a task name';

  @override
  String get dailyTrackerAddTaskSubtitleLabel => 'Subtitle (optional)';

  @override
  String get dailyTrackerAddTaskSubtitleHint => 'e.g. Extra detail or reminder';

  @override
  String get dailyTrackerAddTaskOptionalLabel => 'Mark as optional';

  @override
  String get dailyTrackerAddTaskSaveAction => 'Add Task';

  @override
  String get dailyTrackerDeleteTaskTooltip => 'Delete task';

  @override
  String get dailyTrackerDeleteTaskConfirmTitle => 'Delete task?';

  @override
  String dailyTrackerDeleteTaskConfirmMessage(String title) {
    return '\"$title\" will be removed permanently.';
  }

  @override
  String get dailyTrackerDeleteAction => 'Delete';
}

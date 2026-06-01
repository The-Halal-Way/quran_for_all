// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'কুরআন ফর অল';

  @override
  String get homeDashboardTab => 'আজ';

  @override
  String get homePrayerTab => 'নামাজ';

  @override
  String get homeQuranTab => 'কুরআন';

  @override
  String get homeReadQuranTab => 'কুরআন পড়ুন';

  @override
  String get homeLearnQuranTab => 'কুরআন শিখুন';

  @override
  String get homeSunnahDuaTab => 'সুন্নাহ/দু\'আ';

  @override
  String get languageEnglish => 'ইংরেজি';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsIntro =>
      'আপনার তিলাওয়াত ও পাঠ অভিজ্ঞতা ব্যক্তিগতকৃত করুন।';

  @override
  String get settingsReadingPreferencesTitle => 'পাঠ পছন্দসমূহ';

  @override
  String get settingsShowPronunciationTitle => 'উচ্চারণ দেখান';

  @override
  String get settingsShowPronunciationSubtitle =>
      'আরবি আয়াতের নিচে প্রতিলিপি প্রদর্শন করুন।';

  @override
  String get settingsShowTranslationsTitle => 'অনুবাদ দেখান';

  @override
  String get settingsShowTranslationsSubtitle =>
      'নির্বাচিত ভাষায় অর্থ প্রদর্শন করুন।';

  @override
  String get settingsLanguagePreferenceLabel => 'ভাষা পছন্দ';

  @override
  String get settingsAppearanceTitle => 'অ্যাপিয়ারেন্স';

  @override
  String get settingsThemeTitle => 'থিম';

  @override
  String get settingsThemeSystem => 'সিস্টেম';

  @override
  String get settingsThemeLight => 'লাইট';

  @override
  String get settingsThemeDark => 'ডার্ক';

  @override
  String get settingsOfflineTitle => 'অফলাইন মোড চালু আছে';

  @override
  String get settingsOfflineBody =>
      'সেটআপের পরে কুরআনের লেখা, অনুবাদ ও তাফসির স্থানীয়ভাবে সংরক্ষিত। অডিও প্রথমবার চালানোর পরে ক্যাশ হয়।';

  @override
  String get settingsHijriCalendarTitle => 'হিজরি ক্যালেন্ডার';

  @override
  String get settingsHijriAdjustmentTitle => 'স্থানীয় তারিখ সমন্বয়';

  @override
  String get settingsHijriAdjustmentSubtitle =>
      'স্থানীয় চাঁদ দেখার তারিখ গণনাকৃত তারিখের চেয়ে এক দিন ভিন্ন হলে এটি ব্যবহার করুন।';

  @override
  String get hijriAdjustmentTitle => 'চাঁদ দেখা অনুযায়ী সমন্বয়';

  @override
  String get hijriAdjustmentMinusLabel => '-১ দিন';

  @override
  String get hijriAdjustmentCalculatedLabel => 'গণনাকৃত';

  @override
  String get hijriAdjustmentPlusLabel => '+১ দিন';

  @override
  String get hijriCalendarTitle => 'হিজরি ক্যালেন্ডার';

  @override
  String get hijriCalendarSubtitle => 'ইসলামি তারিখ দেখুন ও যেকোনো দিন খুঁজুন';

  @override
  String get hijriCalendarTodayAction => 'আজ';

  @override
  String get hijriFinderTitle => 'তারিখ খুঁজুন';

  @override
  String get hijriFinderSubtitle =>
      'গ্রেগরিয়ান তারিখ বেছে নিন অথবা সরাসরি হিজরি তারিখ দিন।';

  @override
  String get hijriFindGregorianAction => 'গ্রেগরিয়ান বেছে নিন';

  @override
  String get hijriFindHijriAction => 'হিজরি লিখুন';

  @override
  String get hijriDatePickerTitle => 'হিজরি তারিখ খুঁজুন';

  @override
  String get hijriDatePickerYearLabel => 'বছর';

  @override
  String get hijriDatePickerMonthLabel => 'মাস';

  @override
  String get hijriDatePickerDayLabel => 'দিন';

  @override
  String get hijriDatePickerOpenAction => 'তারিখ খুলুন';

  @override
  String get hijriInvalidDateMessage => 'এই হিজরি তারিখটি পাওয়া যাচ্ছে না।';

  @override
  String get hijriSelectedDateTitle => 'নির্বাচিত তারিখ';

  @override
  String hijriDateFull(String day, String month, String year) {
    return '$day $month $year হিজরি';
  }

  @override
  String get hijriWeekdaySun => 'রবি';

  @override
  String get hijriWeekdayMon => 'সোম';

  @override
  String get hijriWeekdayTue => 'মঙ্গল';

  @override
  String get hijriWeekdayWed => 'বুধ';

  @override
  String get hijriWeekdayThu => 'বৃহস্পতি';

  @override
  String get hijriWeekdayFri => 'শুক্র';

  @override
  String get hijriWeekdaySat => 'শনি';

  @override
  String get hijriMonthMuharram => 'মুহাররম';

  @override
  String get hijriMonthSafar => 'সফর';

  @override
  String get hijriMonthRabiAlAwwal => 'রবিউল আউয়াল';

  @override
  String get hijriMonthRabiAlThani => 'রবিউস সানি';

  @override
  String get hijriMonthJumadaAlAwwal => 'জমাদিউল আউয়াল';

  @override
  String get hijriMonthJumadaAlThani => 'জমাদিউস সানি';

  @override
  String get hijriMonthRajab => 'রজব';

  @override
  String get hijriMonthShaban => 'শাবান';

  @override
  String get hijriMonthRamadan => 'রমজান';

  @override
  String get hijriMonthShawwal => 'শাওয়াল';

  @override
  String get hijriMonthDhulQadah => 'জিলকদ';

  @override
  String get hijriMonthDhulHijjah => 'জিলহজ';

  @override
  String get splashStatusPreparing =>
      'স্থানীয় কুরআন ডাটাবেস প্রস্তুত হচ্ছে...';

  @override
  String get splashStatusReady => 'প্রস্তুত';

  @override
  String get splashStatusOfflineFallback =>
      'সংরক্ষিত কুরআন ডেটা দিয়ে প্রস্তুত। নতুন কিছু কনটেন্ট পরে সিঙ্ক হতে পারে।';

  @override
  String get splashRetrySetup => 'সেটআপ আবার চেষ্টা করুন';

  @override
  String get splashSetupFailedTitle => 'সেটআপের জন্য ইন্টারনেট দরকার';

  @override
  String get splashSetupFailedBody =>
      'প্রথমবার স্থানীয় কুরআন ডাটাবেস প্রস্তুত করতে Quran For All-এর নেটওয়ার্ক সংযোগ দরকার। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get splashSetupFailedTip =>
      'সেটআপের পরে কুরআনের লেখা, অনুবাদ, তাফসির, বুকমার্ক ও পড়ার অগ্রগতি স্থানীয় স্টোরেজ থেকে কাজ করবে।';

  @override
  String get readQuranTitle => 'কুরআন পড়ুন';

  @override
  String get readQuranSubtitle => 'কুরআন ফর অল';

  @override
  String get readQuranSearchTooltip => 'খুঁজুন';

  @override
  String get readQuranBookmarksTooltip => 'বুকমার্কসমূহ';

  @override
  String get readQuranAllSurahsTitle => 'সব সূরা';

  @override
  String get readQuranTotalLabel => 'মোট';

  @override
  String get readQuranAyahLabel => 'আয়াত';

  @override
  String get readQuranSurahLabel => 'সূরা';

  @override
  String get readQuranJuzLabel => 'পারা';

  @override
  String get readQuranAyahsLabel => 'আয়াত';

  @override
  String get readQuranSurahsLabel => 'সূরা';

  @override
  String get readQuranContinueReadingTitle => 'পড়া চালিয়ে যান';

  @override
  String get readQuranBannerTitle => 'পড়ুন। ভাবুন। মনে রাখুন।';

  @override
  String get readQuranBannerSubtitle => 'বাংলা ও ইংরেজি সমর্থনসহ অফলাইন কুরআন।';

  @override
  String get readQuranOfflineReadyLabel => 'অফলাইনে প্রস্তুত';

  @override
  String get readQuranBannerSearchButton => 'সূরা, আয়াত, পারা খুঁজুন';

  @override
  String get readQuranSaveAyahBookmarkTooltip => 'আয়াত বুকমার্ক করুন';

  @override
  String get readQuranRemoveAyahBookmarkTooltip => 'আয়াত বুকমার্ক সরান';

  @override
  String get readQuranSaveSurahBookmarkTooltip => 'সূরা বুকমার্ক করুন';

  @override
  String get readQuranRemoveSurahBookmarkTooltip => 'সূরা বুকমার্ক সরান';

  @override
  String get readQuranMarkAyahLastReadTooltip =>
      'শেষ পড়া হিসেবে আয়াত চিহ্নিত করুন';

  @override
  String get readQuranCurrentLastReadTooltip => 'বর্তমান শেষ পড়া আয়াত';

  @override
  String get readQuranPlayAyahAudioTooltip => 'আয়াতের অডিও চালান';

  @override
  String get readQuranStopAyahAudioTooltip => 'আয়াতের অডিও বন্ধ করুন';

  @override
  String get readQuranReadTafsirTooltip => 'তাফসির পড়ুন';

  @override
  String get readQuranTafsirTitle => 'তাফসির';

  @override
  String get readQuranNoTafsirBody => 'এই আয়াতের তাফসির এখনও পাওয়া যায়নি।';

  @override
  String get readQuranMeccan => 'মক্কী';

  @override
  String get readQuranMedinan => 'মাদানী';

  @override
  String get readQuranCouldNotLoadSurahTitle => 'সূরা লোড করা যায়নি';

  @override
  String get readQuranUnablePlayAyahAudio =>
      'এই মুহূর্তে এই আয়াতের অডিও চালানো যাচ্ছে না।';

  @override
  String get readQuranUnablePlayFullSurahAudio =>
      'এই মুহূর্তে পূর্ণ সূরার অডিও চালানো যাচ্ছে না।';

  @override
  String get readQuranAudioPermissionRequired =>
      'অডিও কন্ট্রোলের জন্য নোটিফিকেশন অনুমতি প্রয়োজন।';

  @override
  String get readQuranGoToSettings => 'সেটিংসে যান';

  @override
  String get readQuranExpandCard => 'কার্ড প্রসারিত করুন';

  @override
  String get readQuranShrinkCard => 'কার্ড সঙ্কুচিত করুন';

  @override
  String get readQuranReadingOptionsTitle => 'পাঠের অপশনসমূহ';

  @override
  String get readQuranReadingOptionsSubtitle =>
      'উচ্চারণ ও অনুবাদের প্রদর্শন নিয়ন্ত্রণ';

  @override
  String get readQuranReadingModeLabel => 'পাঠ মোড';

  @override
  String get readQuranDetailsMode => 'বিস্তারিত';

  @override
  String get readQuranRegularMode => 'সাধারণ';

  @override
  String get readQuranDetailsView => 'বিস্তারিত ভিউ';

  @override
  String get readQuranRegularView => 'সাধারণ ভিউ';

  @override
  String get readQuranPlayFullSurah => 'পূর্ণ সূরা চালান';

  @override
  String get readQuranStopSurahAudio => 'সূরার অডিও বন্ধ করুন';

  @override
  String get readQuranSearchInsideSurahTitle => 'এই সূরার মধ্যে খুঁজুন';

  @override
  String get readQuranSearchInsideSurahHint =>
      'আয়াত নম্বর, আরবি লেখা বা অনুবাদের কীওয়ার্ড লিখুন';

  @override
  String get readQuranStartTypingSurahSearch =>
      'এই সূরায় খুঁজতে টাইপ করা শুরু করুন।';

  @override
  String get readQuranSearchAyahsTitle => 'আয়াত খুঁজুন';

  @override
  String get readQuranSearchAyahsBody =>
      'দ্রুত যেতে লেখা বা আয়াত নম্বর টাইপ করুন।';

  @override
  String get readQuranNoResultsTitle => 'কোনো ফলাফল নেই';

  @override
  String get readQuranNoResultsBody =>
      'ভিন্ন কীওয়ার্ড বা আয়াত নম্বর চেষ্টা করুন।';

  @override
  String readQuranResultsCount(int count) {
    return 'ফলাফল: $count';
  }

  @override
  String get readQuranSearchTitle => 'কুরআন অনুসন্ধান';

  @override
  String get readQuranSearchEmptyTitle => 'সূরা, আয়াত বা পারা খুঁজুন';

  @override
  String get readQuranSearchEmptyBody =>
      '1:1, para 2 বা বাংলা/ইংরেজি কীওয়ার্ড ব্যবহার করুন।';

  @override
  String get readQuranSearchFailedTitle => 'অনুসন্ধান ব্যর্থ';

  @override
  String get readQuranSearchNoResultsBody =>
      'ছোট কীওয়ার্ড বা সরাসরি আয়াত রেফারেন্স ব্যবহার করুন।';

  @override
  String get readQuranSearchHint =>
      'চেষ্টা করুন: Al-Baqarah, 2:255, para 1, mercy';

  @override
  String get readQuranSearchingLabel => 'অনুসন্ধান চলছে...';

  @override
  String readQuranSearchResultsSummary(int count, String query) {
    return 'ফলাফল: $count · \"$query\"';
  }

  @override
  String get readQuranCouldNotOpenSearchResult => 'এই ফলাফল খোলা যায়নি।';

  @override
  String get readQuranBookmarksTitle => 'বুকমার্কসমূহ';

  @override
  String get readQuranCouldNotLoadBookmarksTitle => 'বুকমার্ক লোড করা যায়নি';

  @override
  String get readQuranNoBookmarksTitle => 'এখনও কোনো বুকমার্ক নেই';

  @override
  String get readQuranNoBookmarksBody =>
      'পরে দ্রুত খুঁজে পেতে আয়াত বা সূরা বুকমার্ক করে রাখুন।';

  @override
  String get readQuranCouldNotOpenBookmark => 'এই বুকমার্ক খোলা যায়নি।';

  @override
  String get readQuranSavedBookmarkLabel => 'সংরক্ষিত বুকমার্ক';

  @override
  String get readQuranAyahBookmarkAdded => 'আয়াত বুকমার্ক করা হয়েছে।';

  @override
  String get readQuranAyahBookmarkRemoved => 'আয়াত বুকমার্ক সরানো হয়েছে।';

  @override
  String get readQuranCouldNotUpdateAyahBookmark =>
      'এই মুহূর্তে আয়াত বুকমার্ক আপডেট করা যাচ্ছে না।';

  @override
  String get readQuranMarkedLastRead => 'শেষ পড়া হিসেবে চিহ্নিত হয়েছে।';

  @override
  String get readQuranCouldNotMarkLastRead =>
      'এই আয়াতকে শেষ পড়া হিসেবে চিহ্নিত করা যায়নি।';

  @override
  String get readQuranVmSearchFailed =>
      'অনুসন্ধান ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get readQuranVmNoSurahSelected => 'কোনো সূরা নির্বাচন করা হয়নি।';

  @override
  String get readQuranVmUnableLoadAyahs => 'এই সূরার আয়াতগুলো লোড করা যায়নি।';

  @override
  String get readQuranVmUnableLoadBookmarks =>
      'এই মুহূর্তে বুকমার্ক লোড করা যাচ্ছে না।';

  @override
  String get quranHubTitle => 'কুরআন';

  @override
  String get quranHubHeroEyebrow => 'যে কিতাব পথ দেখায়';

  @override
  String get quranHubHeroArabic => 'الْقُرْآن';

  @override
  String get quranHubHeroBody =>
      'পড়া, শেখা, ভাবনা এবং আল্লাহর কালামের দিকে শান্ত হৃদয়ে ফিরে আসার এক জায়গা।';

  @override
  String get quranHubStatOfflineValue => 'অফলাইন';

  @override
  String get quranHubStatOfflineLabel => 'টেক্সট প্রস্তুত';

  @override
  String get quranHubStatLanguagesValue => '২';

  @override
  String get quranHubStatLanguagesLabel => 'ভাষা';

  @override
  String get quranHubSectionChooseTitle => 'আপনার কুরআন পথ বেছে নিন';

  @override
  String get quranHubSectionChooseSubtitle =>
      'সরাসরি তিলাওয়াতে যান, অথবা ধীরে ধীরে কুরআনের দক্ষতা গড়ে তুলুন।';

  @override
  String get quranHubReadTitle => 'কুরআন পড়ুন';

  @override
  String get quranHubReadSubtitle =>
      'মুসহাফ খুলুন, আয়াত খুঁজুন, বুকমার্ক রাখুন এবং শেষ পড়া থেকে চালিয়ে যান।';

  @override
  String get quranHubReadAction => 'পড়া শুরু করুন';

  @override
  String get quranHubReadFreshStart => 'যেকোনো সূরা থেকে শুরু করুন';

  @override
  String quranHubReadContinueDetail(String surahName, int ayahNumber) {
    return 'শেষ পড়া: $surahName, আয়াত $ayahNumber';
  }

  @override
  String get quranHubLearnTitle => 'কুরআন শিখুন';

  @override
  String get quranHubLearnSubtitle =>
      'উচ্চারণ, তাজবিদ, শব্দের অর্থ এবং নামাজের উপযোগী তিলাওয়াত ধাপে ধাপে গড়ে তুলুন।';

  @override
  String get quranHubLearnAction => 'শেখা শুরু করুন';

  @override
  String get quranHubLearningFreshStart => 'প্রথম গাইডেড লেসন দিয়ে শুরু করুন';

  @override
  String get quranHubHadithTitle => 'কুরআন সম্পর্কে হাদিস';

  @override
  String get quranHubHadithSubtitle =>
      'পড়া ও শেখাকে সওয়াব, রহমত এবং আমলের সঙ্গে যুক্ত রাখার সংক্ষিপ্ত স্মরণ।';

  @override
  String get quranHubHadithBestTitle => 'শেখা ও শেখানো';

  @override
  String get quranHubHadithBestBody =>
      'নবী ﷺ শিখিয়েছেন, তোমাদের মধ্যে উত্তম সে, যে কুরআন শেখে এবং শেখায়।';

  @override
  String get quranHubHadithBestSource => 'সহীহ বুখারী ৫০২৭';

  @override
  String get quranHubHadithIntercessorTitle => 'সেদিনের সঙ্গী';

  @override
  String get quranHubHadithIntercessorBody =>
      'কিয়ামতের দিন কুরআন তার সঙ্গীদের জন্য সুপারিশকারী হয়ে আসবে।';

  @override
  String get quranHubHadithIntercessorSource => 'সহীহ মুসলিম ৮০৪';

  @override
  String get quranHubHadithEffortTitle => 'চেষ্টারও মর্যাদা আছে';

  @override
  String get quranHubHadithEffortBody =>
      'দক্ষ তিলাওয়াতকারী সম্মানিত ফেরেশতাদের সঙ্গী; আর কষ্ট করে পড়লে দ্বিগুণ সওয়াব।';

  @override
  String get quranHubHadithEffortSource => 'সহীহ বুখারী ৪৯৩৭; সহীহ মুসলিম ৭৯৮';

  @override
  String get learnQuranPageTitle => 'কুরআন শিখুন';

  @override
  String get learnQuranTracksTitle => 'লার্নিং ট্র্যাকস';

  @override
  String get learnQuranTracksSubtitle =>
      'ধাপে ধাপে এই সেকশনগুলো অনুসরণ করুন, অথবা আজ যেটি উন্নত করতে চান সেটি বেছে নিন।';

  @override
  String get learnHeaderTitle => 'কুরআন শিখুন';

  @override
  String get learnHeaderSubtitle =>
      'হরফ, তাজবিদ ও সাবলীল তিলাওয়াতের জন্য কাঠামোবদ্ধ পাঠ।';

  @override
  String learnHeaderLessonProgress(int completed, int total) {
    return '$completed / $total টি লেসন সম্পন্ন';
  }

  @override
  String get learnHeaderModulesLabel => 'মডিউল';

  @override
  String get learnHeaderStreakLabel => 'স্ট্রিক';

  @override
  String learnHeaderStreakDays(int days) {
    return '$days দিন';
  }

  @override
  String get learnModuleStatusCompleted => 'সম্পন্ন';

  @override
  String get learnModuleStatusNotStarted => 'শুরু হয়নি';

  @override
  String get learnModuleStatusInProgress => 'চলমান';

  @override
  String learnMinutesShort(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String learnCompletedFraction(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get learnNextContinuePathTitle => 'আপনার যাত্রা চালিয়ে যান';

  @override
  String get learnNextAllLessonsCompletedTitle => 'সব লেসন সম্পন্ন';

  @override
  String get learnNextAllLessonsCompletedBody =>
      'দারুণ কাজ। শেখা মজবুত করতে যেকোনো মডিউল আবার দেখুন।';

  @override
  String get learnNextStartLessonButton => 'পরের লেসন শুরু করুন';

  @override
  String get learnNextReviewModulesButton => 'মডিউল রিভিউ করুন';

  @override
  String get learnLessonTooltipPauseAudio => 'লেসনের অডিও থামান';

  @override
  String get learnLessonTooltipPlayAudio => 'লেসনের অডিও চালান';

  @override
  String get learnLessonAudioGuided => 'অডিও গাইডেড';

  @override
  String get learnLessonDone => 'সম্পন্ন';

  @override
  String learnLessonDurationMinutes(int minutes) {
    return '$minutes মিনিট';
  }

  @override
  String learnModuleLessonsCompleted(int completed, int total) {
    return '$completed / $total টি লেসন সম্পন্ন';
  }

  @override
  String get learnVmErrorLoadProgress =>
      'এই মুহূর্তে শেখার অগ্রগতি লোড করা যাচ্ছে না।';

  @override
  String get learnVmErrorSaveProgress =>
      'অগ্রগতি সংরক্ষণ করা যাচ্ছে না। আবার চেষ্টা করুন।';

  @override
  String get learnVmAudioMissingSample =>
      'এই লেসনের জন্য এখনো কোনো অডিও স্যাম্পল যুক্ত নেই।';

  @override
  String get learnVmAudioSampleNotFound =>
      'এই লেসনের অডিও স্যাম্পল আয়াত খুঁজে পাওয়া যায়নি।';

  @override
  String get learnVmAudioPlayFailed =>
      'এই মুহূর্তে লেসনের অডিও চালানো যাচ্ছে না।';

  @override
  String get duahDailyTitle => 'দৈনন্দিন দু\'আ';

  @override
  String get duahDailySubtitle => 'প্রতিটি মুহূর্তের জন্য দু\'আ';

  @override
  String get duahPowerfulTitle => 'শক্তিশালী দু\'আসমূহ';

  @override
  String get duahLanguageToggleTooltip => 'ভাষা পরিবর্তন করুন';

  @override
  String get duahLevelBeginner => 'শুরুর স্তর';

  @override
  String get duahLevelIntermediate => 'মধ্যম স্তর';

  @override
  String get duahLevelAdvanced => 'উন্নত স্তর';

  @override
  String get duahLevelBeginnerDesc =>
      'প্রতিদিনের জন্য ছোট ও সহজে মুখস্থযোগ্য দু\'আ। যাত্রা শুরু করার জন্য উপযুক্ত।';

  @override
  String get duahLevelIntermediateDesc =>
      'আরও পূর্ণ বাক্য ও গভীর অর্থসহ দু\'আ। বেসিক স্বাভাবিক হলে এটি আদর্শ।';

  @override
  String get duahLevelAdvancedDesc =>
      'ঐচ্ছিক অংশসহ পূর্ণ প্রামাণ্য দু\'আ এবং দৈনন্দিন সব পরিস্থিতি।';

  @override
  String get duahCategoryEatingDrinking => 'খাওয়া ও পানীয়';

  @override
  String get duahCategoryHome => 'বাড়ি';

  @override
  String get duahCategoryWashroom => 'ওয়াশরুম';

  @override
  String get duahCategorySleep => 'ঘুম';

  @override
  String get duahCategoryDailyDhikr => 'দৈনিক যিকির';

  @override
  String get duahCategoryWudu => 'ওজু';

  @override
  String get duahCategoryMasjid => 'মসজিদ';

  @override
  String get duahCategorySneezing => 'হাঁচি';

  @override
  String get duahCategoryDifficulty => 'কঠিন সময়';

  @override
  String duahCountLabel(int count) {
    return '$count টি দু\'আ';
  }

  @override
  String get duahShowVariants => 'ভ্যারিয়েন্ট দেখুন';

  @override
  String get duahHideVariants => 'ভ্যারিয়েন্ট লুকান';

  @override
  String get duahCopied => 'কপি হয়েছে';

  @override
  String get duahCopy => 'কপি';

  @override
  String get duahPowerfulImportantNoteTitle => 'গুরুত্বপূর্ণ নোট';

  @override
  String get duahPowerfulImportantNoteBody =>
      'দু\'আ কবুল হয় আল্লাহ যেমন চান, যখন চান, এবং যে রূপে চান। এগুলো কুরআন ও হাদিসভিত্তিক প্রামাণ্য ও অত্যন্ত প্রিয় দু\'আ।';

  @override
  String get duahPowerfulBestFive => 'প্রথমে মুখস্থের জন্য সেরা ৫টি';

  @override
  String get duahSituationAll => 'সব';

  @override
  String get duahSituationDistress => 'দুশ্চিন্তা';

  @override
  String get duahSituationForgiveness => 'ক্ষমা';

  @override
  String get duahSituationGuidance => 'হিদায়াত';

  @override
  String get duahSituationProvision => 'রিযিক';

  @override
  String get duahSituationProtection => 'হিফাজত';

  @override
  String get duahSituationFamily => 'পরিবার';

  @override
  String get duahSituationKnowledge => 'জ্ঞান';

  @override
  String duahCountOfTotal(int count, int total) {
    return '$totalটির মধ্যে $count টি দু\'আ';
  }

  @override
  String get duahTapToShowPronunciation => 'উচ্চারণ দেখতে ট্যাপ করুন';

  @override
  String get duahNintyNineTitle => '৯৯টি নাম';

  @override
  String get duahNintyNineSubtitle => 'আসমা উল হুসনা';

  @override
  String duahNintyNineNamesCount(int count) {
    return '$countটি নাম';
  }

  @override
  String duahNintyNineCategoryCount(int count) {
    return '$countটি থিম';
  }

  @override
  String get duahNintyNineVerseLabel => 'কুরআনের স্মরণ';

  @override
  String get duahNintyNineBenefitTitle => 'উপকারিতা';

  @override
  String get duahNintyNineConclusionTitle => 'উপসংহার';

  @override
  String get duahNintyNineNamesGridTitle => 'সুন্দর নামসমূহ';

  @override
  String get duahNintyNineLoading => 'সুন্দর নামসমূহ লোড হচ্ছে...';

  @override
  String get duahNintyNineLoadError => 'এই মুহূর্তে নামসমূহ লোড করা যাচ্ছে না।';

  @override
  String get duahNintyNineLoadErrorBody => 'একটু পর আবার চেষ্টা করুন।';

  @override
  String get duahNintyNineRetry => 'আবার চেষ্টা করুন';

  @override
  String get sunnahDuaTitle => 'সুন্নাহ ও দু\'আ';

  @override
  String get sunnahDuaHeroEyebrow => 'দৈনন্দিন আমল';

  @override
  String get sunnahDuaHeroBody =>
      'পূর্ণ সুন্নাহ আমলের ভেতরে সংশ্লিষ্ট দু\'আ, সঙ্গে আলাদা দু\'আ ও যিকির।';

  @override
  String get sunnahDuaHeroArabic => 'سُنَّة وَدُعَاء';

  @override
  String get sunnahDuaHeroStatGrid => 'গ্রিড';

  @override
  String get sunnahDuaFilterAll => 'সব';

  @override
  String get sunnahDuaFilterSunnah => 'সুন্নাহ';

  @override
  String get sunnahDuaFilterDua => 'দু\'আ';

  @override
  String get sunnahDuaFilterDhikr => 'যিকির';

  @override
  String get sunnahDuaKindSunnah => 'সুন্নাহ';

  @override
  String get sunnahDuaKindDua => 'দু\'আ';

  @override
  String get sunnahDuaKindDhikr => 'যিকির';

  @override
  String get sunnahDuaGridTitle => 'সুন্নাহ আমল';

  @override
  String sunnahDuaItemsCount(int count) {
    return '$countটি আইটেম';
  }

  @override
  String get sunnahDuaSourceLabel => 'সূত্র';

  @override
  String get sunnahDuaArabicLabel => 'আরবি';

  @override
  String get sunnahDuaPronunciationLabel => 'উচ্চারণ';

  @override
  String get sunnahDuaTranslationLabel => 'অর্থ';

  @override
  String get sunnahDuaPracticeLabel => 'আমলের নোট';

  @override
  String get sunnahDuaSunnahPointsLabel => 'সুন্নাহ আমল';

  @override
  String get sunnahDuaRelatedDuaLabel => 'সংশ্লিষ্ট দু\'আ';

  @override
  String get sunnahDuaDuaIncludedLabel => 'দু\'আ আছে';

  @override
  String get sunnahDuaSourceDailySunnah => 'দৈনন্দিন সুন্নাহ আমল';

  @override
  String get sunnahDuaSourceDailyDua => 'দৈনন্দিন দু\'আ সংগ্রহ';

  @override
  String get sunnahDuaEatingSunnahsTitle => 'খাওয়ার সুন্নাহসমূহ';

  @override
  String get sunnahDuaEatingSunnahsSubtitle =>
      'দু\'আটি পুরো খাওয়ার আদবের একটি অংশ';

  @override
  String get sunnahDuaEatingSunnahsPointsRaw =>
      'খাওয়ার আগে আল্লাহর নাম নিন।||ডান হাতে খাবার খান।||নিজের কাছের দিক থেকে খান।||খাবারের দোষ বলবেন না এবং অতিরিক্ত ভরার আগে থামুন।';

  @override
  String get sunnahDuaEatingSunnahsPractice =>
      'খাবারের সময় এই কার্ডটিকে ছোট চেকলিস্ট করুন। দু\'আ বলুন, তারপর পুরো খাবার জুড়ে আদবগুলো রাখুন।';

  @override
  String get sunnahDuaMiswakTitle => 'মিসওয়াক';

  @override
  String get sunnahDuaMiswakSubtitle => 'ইবাদতের আগে মুখ সতেজ রাখুন';

  @override
  String get sunnahDuaMiswakPointsRaw =>
      'সহজ হলে ওজু বা নামাজের আগে ব্যবহার করুন।||কুরআন তিলাওয়াতের আগে মুখ পরিষ্কার রাখুন।||ঘুম থেকে ওঠার পর বা ঘুমের আগে মুখ সতেজ করুন।||মিসওয়াক পরিষ্কার রাখুন এবং ক্ষয় হলে বদলান।';

  @override
  String get sunnahDuaMiswakArabic => 'السِّوَاك';

  @override
  String get sunnahDuaMiswakPronunciation => 'আস-সিওয়াক';

  @override
  String get sunnahDuaMiswakTranslation =>
      'মিসওয়াক ব্যবহার করা, অথবা মিসওয়াক না থাকলে দাঁত পরিষ্কার রাখা, নামাজ, ওজু ও তিলাওয়াতের জন্য মুখ প্রস্তুত রাখে।';

  @override
  String get sunnahDuaMiswakPractice =>
      'ওজুর জায়গা বা জায়নামাজের কাছে একটি মিসওয়াক রাখুন, যেন সুন্নাহটি সহজ দৈনন্দিন অভ্যাস হয়ে যায়।';

  @override
  String get sunnahDuaMiswakSource => 'পবিত্রতার সুন্নাহ';

  @override
  String get sunnahDuaSleepingSunnahsTitle => 'ঘুমের সুন্নাহসমূহ';

  @override
  String get sunnahDuaSleepingSunnahsSubtitle =>
      'দিন শেষ করুন স্মরণ ও প্রশান্তিতে';

  @override
  String get sunnahDuaSleepingSunnahsPointsRaw =>
      'সামর্থ্য থাকলে ঘুমের আগে ওজু করুন।||শোয়ার আগে বিছানা ঝেড়ে বা দেখে নিন।||ডান কাতে ঘুমান।||ঘুমের দু\'আ ও যিকির দিয়ে দিন শেষ করুন।';

  @override
  String get sunnahDuaSleepingSunnahsPractice =>
      'ঘুমের রুটিনটি ছোট ও পুনরাবৃত্তিযোগ্য রাখুন, যেন ক্লান্ত রাতেও করা যায়।';

  @override
  String get sunnahDuaHomeSunnahsTitle => 'ঘরের সুন্নাহসমূহ';

  @override
  String get sunnahDuaHomeSunnahsSubtitle =>
      'সালাম, স্মরণ ও ভরসা নিয়ে প্রবেশ ও বের হওয়া';

  @override
  String get sunnahDuaHomeSunnahsPointsRaw =>
      'ঘরে প্রবেশের সময় বিসমিল্লাহ বলুন।||ঘরের মানুষকে সালাম দিন।||বের হওয়ার সময় আল্লাহর ওপর ভরসা রাখুন।||ঘরের প্রথম ও শেষ মুহূর্ত শান্ত রাখুন।';

  @override
  String get sunnahDuaHomeSunnahsPractice =>
      'এই আমলটিকে দরজার সঙ্গে যুক্ত করুন, তাহলে অভ্যাসটি স্বাভাবিকভাবে মনে পড়বে।';

  @override
  String get sunnahDuaWuduSunnahsTitle => 'ওজুর সুন্নাহসমূহ';

  @override
  String get sunnahDuaWuduSunnahsSubtitle => 'মনোযোগী খুঁটিনাটিসহ পবিত্রতা';

  @override
  String get sunnahDuaWuduSunnahsPointsRaw =>
      'আল্লাহর নামে শুরু করুন।||পানি অপচয় না করে যত্ন নিয়ে ধুয়ে নিন।||প্রতিটি অঙ্গ মনোযোগ দিয়ে ধুয়ে নিন।||ওজুর পরে সাক্ষ্য পাঠ করুন।';

  @override
  String get sunnahDuaWuduSunnahsPractice =>
      'ওজুকে শুধু কাজ না বানিয়ে নামাজের প্রস্তুতি হিসেবে অনুভব করার মতো ধীরে করুন।';

  @override
  String get sunnahDuaSiyamSunnahsTitle => 'সিয়াম';

  @override
  String get sunnahDuaSiyamSunnahsSubtitle => 'রমজানের বাইরে সুন্নাহ রোজা';

  @override
  String get sunnahDuaSiyamSunnahsPointsRaw =>
      'রোজার আগে নিয়তকে আন্তরিক ও স্পষ্ট রাখুন।||রোজাকে শুধু পানাহার থেকে বিরত থাকা বানাবেন না; কথা, রাগ, দৃষ্টি ও কাজকেও সংযত রাখুন।||সামর্থ্য থাকলে সোমবার ও বৃহস্পতিবার রোজা রাখুন।||প্রতি চন্দ্র মাসে তিন দিন রাখুন, বিশেষ করে আইয়ামে বীদ: ১৩, ১৪ ও ১৫ তারিখ।||বিশেষ সুন্নাহ রোজা মনে রাখুন: শাওয়ালের ছয় রোজা, আশুরা, এবং হাজ্জে না থাকা ব্যক্তির জন্য আরাফার দিন।||সেহরি ফজরের কাছাকাছি করুন এবং সূর্যাস্তের পর ইফতার দ্রুত করুন।||খেজুর বা পানি দিয়ে ইফতার করুন এবং ইফতারের সময় দু\'আ করুন।||নিজেকে কষ্ট দেবেন না; অসুস্থতা, সফর বা দায়িত্ব নষ্ট হওয়ার আশঙ্কা থাকলে নফল রোজা ছেড়ে দিন।';

  @override
  String get sunnahDuaSiyamArabic => 'الصِّيَامُ جُنَّةٌ';

  @override
  String get sunnahDuaSiyamPronunciation => 'আস-সিয়ামু জুন্নাহ';

  @override
  String get sunnahDuaSiyamTranslation => 'রোজা ঢালস্বরূপ।';

  @override
  String get sunnahDuaSiyamSunnahsPractice =>
      'একটি সহজ ও ধারাবাহিক সুন্নাহ রোজা দিয়ে শুরু করুন, তারপর ধীরে ধীরে বাড়ান। লক্ষ্য শুধু ক্ষুধা নয়; লক্ষ্য তাকওয়া, সংযম, কৃতজ্ঞতা ও আল্লাহর সামনে পরিষ্কার অন্তর।';

  @override
  String get sunnahDuaSiyamSource =>
      'সহিহ বুখারি ১৮৯৪; সহিহ মুসলিম ১১৫১, ১১৬২, ১১৬৪; জামে তিরমিজি ৭৬১';

  @override
  String get sunnahDuaMasjidSunnahsTitle => 'মসজিদের সুন্নাহসমূহ';

  @override
  String get sunnahDuaMasjidSunnahsSubtitle =>
      'রহমত ও স্থিরতা নিয়ে মসজিদে প্রবেশ';

  @override
  String get sunnahDuaMasjidSunnahsPointsRaw =>
      'শান্তভাবে প্রবেশ করুন, তাড়াহুড়া করবেন না।||আল্লাহর কাছে রহমতের দরজা খুলে দেওয়ার দু\'আ করুন।||ফোন ও কথা কম রাখুন।||কৃতজ্ঞতা নিয়ে বের হন এবং আল্লাহর অনুগ্রহ চান।';

  @override
  String get sunnahDuaMasjidSunnahsPractice =>
      'মসজিদের দরজাটিকে শব্দ, তাড়া ও অমনোযোগ কমানোর স্মরণ বানান।';

  @override
  String get sunnahDuaSneezingSunnahTitle => 'হাঁচির সুন্নাহ';

  @override
  String get sunnahDuaSneezingSunnahSubtitle => 'কৃতজ্ঞতা ও রহমতের ছোট মুহূর্ত';

  @override
  String get sunnahDuaSneezingSunnahPointsRaw =>
      'হাঁচির পরে আলহামদুলিল্লাহ বলুন।||শ্রোতা রহমতের জবাব দেবে।||হাঁচিদাতা হিদায়াত ও কল্যাণের জবাব দেবে।||আদান-প্রদানটি কোমল ও সংক্ষিপ্ত রাখুন।';

  @override
  String get sunnahDuaSneezingSunnahPractice =>
      'এটি ছোট, কিন্তু সাধারণ মুহূর্তকে কৃতজ্ঞতা ও যত্নে বদলে দেয়।';

  @override
  String get sunnahDuaSeekingForgivenessSubtitle => 'ইস্তিগফার কাছে রাখুন';

  @override
  String get sunnahDuaSeekingForgivenessPractice =>
      'কাজের ফাঁকে, নামাজের পরে, অথবা মন ভারী লাগলে এটি বারবার বলুন।';

  @override
  String get sunnahDuaDifficultySubtitle => 'যখন মন ভারী হয়ে যায়';

  @override
  String get sunnahDuaDifficultyPractice =>
      'ধীরে ধীরে পড়ুন, তারপর আল্লাহর ওপর ভরসা রেখে সঠিক পরের কাজটি বেছে নিন।';

  @override
  String get dashboardSectionPrayerTimes => 'নামাজের সময়সূচি';

  @override
  String get dashboardActionFullPrayerView => 'পূর্ণ নামাজ ভিউ';

  @override
  String get dashboardActionQiblaCompass => 'কিবলা কম্পাস';

  @override
  String get dashboardActionQiblaCompassSub => 'কিবলার দিক দেখুন';

  @override
  String get dashboardActionHijriCalendar => 'হিজরি ক্যালেন্ডার';

  @override
  String get dashboardActionHijriCalendarSub => 'ইসলামি তারিখ খুঁজুন';

  @override
  String get dashboardSectionDua => 'দু\'আ';

  @override
  String get dashboardActionDailyDua => 'দৈনন্দিন দু\'আ';

  @override
  String get dashboardActionDailyDuaSub => 'সকাল ও সন্ধ্যা';

  @override
  String get dashboardActionPowerfulDua => 'শক্তিশালী দু\'আ';

  @override
  String get dashboardActionPowerfulDuaSub => 'নির্বাচিত প্রার্থনাসমূহ';

  @override
  String get dashboardActionNintyNineNames => '৯৯টি নাম';

  @override
  String get dashboardActionNintyNineNamesSub => 'আসমা উল হুসনা';

  @override
  String get dashboardActionSunnahDua => 'সুন্নাহ ও দু\'আ';

  @override
  String get dashboardActionSunnahDuaSub => 'আমল ও দৈনিক দু\'আ';

  @override
  String get dashboardSectionOthers => 'অন্যান্য';

  @override
  String get dashboardActionTasbeeh => 'তাসবিহ';

  @override
  String get dashboardActionTasbeehSub => 'গণনা ও জিকির';

  @override
  String get dashboardSectionHadith => 'হাদিস';

  @override
  String get tasbeehTitle => 'তাসবিহ কাউন্টার';

  @override
  String get tasbeehSubtitle => 'মনোযোগ দিয়ে জিকির গুনুন';

  @override
  String get tasbeehPhraseTitle => 'জিকির';

  @override
  String get tasbeehPhraseSubhanAllah => 'সুবহানাল্লাহ';

  @override
  String get tasbeehPhraseAlhamdulillah => 'আলহামদুলিল্লাহ';

  @override
  String get tasbeehPhraseAllahuAkbar => 'আল্লাহু আকবার';

  @override
  String get tasbeehPhraseLaIlahaIllallah => 'লা ইলাহা ইল্লাল্লাহ';

  @override
  String get tasbeehTarget => 'লক্ষ্য';

  @override
  String get tasbeehTargetReached => 'লক্ষ্য পূর্ণ';

  @override
  String get tasbeehCurrent => 'বর্তমান';

  @override
  String get tasbeehTotal => 'মোট';

  @override
  String get tasbeehRounds => 'রাউন্ড';

  @override
  String get tasbeehUndo => 'পিছিয়ে দিন';

  @override
  String get tasbeehReset => 'রিসেট';

  @override
  String get tasbeehResetAll => 'সব রিসেট';

  @override
  String get dashboardContinueReadingTitle => 'পড়া চালিয়ে যান';

  @override
  String get dashboardContinueReadingStartSubtitle =>
      'যেখান থেকে থেমেছেন সেখান থেকেই শুরু করুন';

  @override
  String get dashboardContinueReadingStartDetail =>
      'সাম্প্রতিক সূরা খুলে পড়া চালিয়ে যান';

  @override
  String dashboardContinueReadingAyahDetail(int ayahNumber, String surahName) {
    return 'আয়াত $ayahNumber · $surahName';
  }

  @override
  String get dashboardQuranLabel => 'কুরআন';

  @override
  String get dashboardContinueLearningTitle => 'শেখা চালিয়ে যান';

  @override
  String get dashboardContinueLearningStartSubtitle => 'শেখা শুরু করুন';

  @override
  String get dashboardContinueLearningStartDetail => 'লার্নিং ট্র্যাক খুলুন';

  @override
  String dashboardContinueLearningModuleDetail(
    String moduleTitle,
    int lessonCount,
  ) {
    return '$moduleTitle · $lessonCountটি লেসন';
  }

  @override
  String get dashboardRetry => 'আবার চেষ্টা করুন';

  @override
  String get dashboardNextPrayer => 'পরবর্তী নামাজ';

  @override
  String get dashboardNextShortLabel => 'পরবর্তী';

  @override
  String get dashboardPrayerFajr => 'ফজর';

  @override
  String get dashboardPrayerSehri => 'সেহরি';

  @override
  String get dashboardPrayerSunrise => 'সূর্যোদয়';

  @override
  String get dashboardPrayerDhuhr => 'যোহর';

  @override
  String get dashboardPrayerAsr => 'আসর';

  @override
  String get dashboardPrayerMaghrib => 'মাগরিব';

  @override
  String get dashboardPrayerIsha => 'ইশা';

  @override
  String get dashboardHadithAnNawawiTitle => 'ইমাম নববীর ৪০ হাদিস';

  @override
  String get dashboardHadithAnNawawiDescription =>
      'ইমাম আন-নববীর ক্লাসিক হাদিস সংকলন';

  @override
  String get dashboardHadithShortTitle => '৪০টি ছোট হাদিস';

  @override
  String get dashboardHadithShortDescription =>
      'সহজে মুখস্থ ও অনুশীলনের জন্য ছোট হাদিস';

  @override
  String get prayerViewTitle => 'নামাজের বিস্তারিত';

  @override
  String get prayerViewAppBarSubtitle => 'এই নামাজের সময়ের নির্দেশনা';

  @override
  String get prayerViewRefreshTooltip => 'নামাজের সময় রিফ্রেশ করুন';

  @override
  String get prayerViewLanguageTooltip => 'ভাষা পরিবর্তন করুন';

  @override
  String get prayerViewCurrentFocus => 'বর্তমান ফোকাস';

  @override
  String get prayerViewLoadedFromLocation => 'লোকেশনভিত্তিক সময়';

  @override
  String get prayerViewTimeFallback => 'গাইড মোড';

  @override
  String get prayerViewHeroNextLabel => 'প্রস্তুতির সময়';

  @override
  String get prayerViewNoTime => '--';

  @override
  String get prayerViewSehriLast => 'সর্বশেষ';

  @override
  String get prayerViewPermissionHelpTitle => 'নামাজের সময়ের জন্য লোকেশন দরকার';

  @override
  String get prayerViewPermissionHelpBody =>
      'স্থানীয় নামাজের সময় হিসাব করতে লোকেশন অনুমতি দিন। নিচের নির্দেশনাগুলো তবুও পাওয়া যাবে।';

  @override
  String get prayerTimesPermissionDeniedTitle => 'লোকেশন অনুমতি দরকার';

  @override
  String get prayerTimesPermissionDeniedBody =>
      'আপনার এলাকার নামাজের সময় হিসাব করতে লোকেশন অনুমতি দিন। লাইভ সময় ছাড়াও নির্দেশনা সেকশনগুলো ব্যবহার করা যাবে।';

  @override
  String get prayerTimesPermissionDeniedForeverTitle =>
      'লোকেশন অনুমতি ব্লক করা আছে';

  @override
  String get prayerTimesPermissionDeniedForeverBody =>
      'অ্যাপ সেটিংসে গিয়ে লোকেশন অনুমতি দিন, তারপর নামাজের সময় রিফ্রেশ করুন।';

  @override
  String get prayerTimesLocationDisabledTitle => 'ডিভাইস লোকেশন বন্ধ আছে';

  @override
  String get prayerTimesLocationDisabledBody =>
      'ডিভাইস লোকেশন সার্ভিস চালু করুন, তারপর স্থানীয় নামাজের সময় হিসাব করতে রিফ্রেশ করুন।';

  @override
  String get prayerTimesNetworkErrorTitle => 'নামাজের সময় প্রস্তুত করা যায়নি';

  @override
  String get prayerTimesNetworkErrorBody =>
      'ইন্টারনেট সংযোগ ও ডিভাইস লোকেশন সেটিংস দেখে আবার চেষ্টা করুন।';

  @override
  String get compassTitle => 'কম্পাস';

  @override
  String get compassInitializing => 'কম্পাস চালু হচ্ছে...';

  @override
  String get compassRetry => 'আবার চেষ্টা করুন';

  @override
  String get compassNativeActive => 'নেটিভ কম্পাস চালু আছে';

  @override
  String get compassHeadingLabel => 'হেডিং';

  @override
  String get compassQiblaOffsetLabel => 'কিবলা অফসেট';

  @override
  String get compassAccuracyLabel => 'নির্ভুলতা';

  @override
  String get compassNotAvailableShort => 'প্রযোজ্য নয়';

  @override
  String get compassApiAccuracyLabel => 'API';

  @override
  String get compassNativeAccuracyLabel => '±২°';

  @override
  String get compassFacingMeccaLabel => 'কিবলার দিকে আছেন!';

  @override
  String get compassRotateToAlignLabel => 'মেলাতে ঘোরান';

  @override
  String get compassApiFallbackTitle => 'কম্পাস সেন্সর পাওয়া যায়নি';

  @override
  String get compassApiFallbackBody =>
      'আপনার ডিভাইস নেটিভ কম্পাস সেন্সর দিচ্ছে না। আপনার লোকেশন থেকে কিবলার কোণ হিসাব করা যাবে, কিন্তু লাইভ ঘূর্ণনের জন্য কম্পাস-সক্ষম ডিভাইস দরকার।';

  @override
  String compassApiFallbackQibla(String degrees) {
    return 'কিবলার কোণ: $degrees°';
  }

  @override
  String get compassLocationDeniedTitle => 'লোকেশন অনুমতি দরকার';

  @override
  String get compassLocationDeniedBody =>
      'বর্তমান অবস্থান থেকে কিবলা হিসাব করতে লোকেশন অনুমতি দিন।';

  @override
  String get compassLocationBlockedTitle => 'লোকেশন অনুমতি ব্লক করা আছে';

  @override
  String get compassLocationBlockedBody =>
      'অ্যাপ সেটিংসে গিয়ে লোকেশন অনুমতি দিন, তারপর কিবলা কম্পাস আবার চেষ্টা করুন।';

  @override
  String get compassLocationDisabledTitle => 'ডিভাইস লোকেশন বন্ধ আছে';

  @override
  String get compassLocationDisabledBody =>
      'ডিভাইস লোকেশন সার্ভিস চালু করুন, তারপর কিবলা কম্পাস আবার চেষ্টা করুন।';

  @override
  String get compassGenericErrorTitle => 'কম্পাস চালু করা যায়নি';

  @override
  String get compassGenericErrorBody =>
      'লোকেশন অনুমতি, সেন্সর এবং সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get prayerViewTimelineTitle => 'আজকের নামাজের ছন্দ';

  @override
  String get prayerViewTimelineSubtitle =>
      'পুরো দিনের সময় দেখুন, পরবর্তী নামাজ চিনে নিন, আর বর্তমান ফোকাস সামনে রাখুন।';

  @override
  String get prayerRakatGuideTitle => 'রাকাত গাইড';

  @override
  String get prayerRakatGuideSubtitle =>
      'প্রতিদিনের নামাজের সাধারণ রাকাত সংখ্যা ও ভাগগুলো এক নজরে দেখুন।';

  @override
  String get prayerRakatViewDetails => 'বিস্তারিত দেখুন';

  @override
  String prayerRakatTotalLabel(int count) {
    return '$count রাকাত';
  }

  @override
  String get prayerRakatUnitLabel => 'রাকাত';

  @override
  String get prayerRakatTypeFard => 'ফরজ';

  @override
  String get prayerRakatTypeSunnahMuakkadah => 'সুন্নাতে মুয়াক্কাদা';

  @override
  String get prayerRakatTypeSunnahGhairMuakkadah =>
      'সুন্নাতে গায়রে মুয়াক্কাদা';

  @override
  String get prayerRakatTypeNafl => 'নফল';

  @override
  String get prayerRakatTypeWitr => 'বিতর';

  @override
  String get prayerRakatBeforeFardLabel => 'ফরজের আগে';

  @override
  String get prayerRakatFardLabel => 'আবশ্যক';

  @override
  String get prayerRakatAfterFardLabel => 'ফরজের পরে';

  @override
  String get prayerRakatOptionalLabel => 'ঐচ্ছিক';

  @override
  String get prayerRakatWitrLabel => 'ইশার পরে';

  @override
  String get prayerRakatFajrNote =>
      'ফজরের আগে ২ রাকাত সুন্নত অত্যন্ত গুরুত্বপূর্ণ।';

  @override
  String get prayerRakatDhuhrNote =>
      'সাধারণ ধারা: ৪ সুন্নত, ৪ ফরজ, ২ সুন্নত, তারপর ঐচ্ছিক নফল।';

  @override
  String get prayerRakatAsrNote =>
      'আসরের আগে ৪ রাকাত সুন্নত সাধারণত গায়রে মুয়াক্কাদা হিসেবে ধরা হয়।';

  @override
  String get prayerRakatMaghribNote =>
      'আগে ৩ রাকাত ফরজ, তারপর সুন্নতে মুয়াক্কাদা ও ঐচ্ছিক নফল।';

  @override
  String get prayerRakatIshaNote =>
      'বিতরের বিস্তারিত মাযহাবভেদে ভিন্ন হতে পারে; অনেক সমাজে ইশার পরে ৩ রাকাত পড়া হয়।';

  @override
  String get prayerViewNowTitle => 'এখন কী অনুসরণ করবেন';

  @override
  String get prayerViewNowSubtitle =>
      'বর্তমান নামাজের সময়ের জন্য ব্যবহারিক পরবর্তী পদক্ষেপ।';

  @override
  String get prayerViewSuggestionsTitle => 'নামাজের পরামর্শ';

  @override
  String get prayerViewSuggestionsSubtitle =>
      'ছোট ছোট কাজ, যা এই নামাজকে আরও শান্ত ও নিয়তপূর্ণ করে।';

  @override
  String get prayerViewHowTitle => 'কীভাবে নামাজ পড়বেন';

  @override
  String get prayerViewHowSubtitle =>
      'নামাজের মূল অঙ্গভঙ্গি ও মনোযোগের সহজ ধারা।';

  @override
  String get prayerViewBestPracticesTitle => 'সেরা অনুশীলন';

  @override
  String get prayerViewBestPracticesSubtitle =>
      'বর্তমানে সামনে থাকা নামাজ অনুযায়ী ফোকাসড অভ্যাস।';

  @override
  String get prayerViewFiqhNoteTitle => 'অনুশীলন নোট';

  @override
  String get prayerViewFiqhNoteBody =>
      'মাযহাব ও স্থানীয় শিক্ষার ভিত্তিতে কিছু বিস্তারিত বিষয়ে পার্থক্য থাকতে পারে। এটিকে বন্ধুসুলভ নির্দেশনা হিসেবে নিন এবং ফিকহ-নির্দিষ্ট বিষয়ে বিশ্বস্ত আলেম বা ইমামের অনুসরণ করুন।';

  @override
  String get prayerViewFocus => 'ফোকাস';

  @override
  String get prayerViewNext => 'পরবর্তী';

  @override
  String get prayerViewPassed => 'অতিবাহিত';

  @override
  String get prayerViewSoon => 'শিগগির';

  @override
  String get prayerForbiddenTimesTitle => 'নিষিদ্ধ সময়';

  @override
  String get prayerForbiddenTimesSubtitle =>
      'ছোট কিছু সময়, যখন নফল নামাজ শুরু করা এড়িয়ে চলা উচিত।';

  @override
  String get prayerForbiddenAlertTitle => 'এখানে নফল নামাজে বিরতি দিন';

  @override
  String get prayerForbiddenAlertBody =>
      'জিকির, কুরআন শ্রবণ বা নীরব চিন্তায় থাকুন, তারপর সময় পরিষ্কার হলে আবার নামাজ পড়ুন। ফিকহি বিস্তারিত ভিন্ন হতে পারে, তাই নির্দিষ্ট বিষয়ে বিশ্বস্ত আলেমের অনুসরণ করুন।';

  @override
  String get prayerForbiddenPauseLabel => 'বিরতি';

  @override
  String get prayerForbiddenSunriseTitle => 'সূর্যোদয়ের সময়';

  @override
  String get prayerForbiddenSunriseBody =>
      'সূর্য ওঠার সময় নফল নামাজ শুরু করা এড়িয়ে চলুন; সূর্য স্পষ্টভাবে উঠে গেলে অপেক্ষা শেষ করুন।';

  @override
  String get prayerForbiddenZenithTitle => 'সূর্য মধ্যাকাশে';

  @override
  String get prayerForbiddenZenithBody =>
      'যোহর শুরুর ঠিক আগে সূর্য যখন সর্বোচ্চ অবস্থানে থাকে, তখন ঐচ্ছিক নামাজে বিরতি দিন।';

  @override
  String get prayerForbiddenSunsetTitle => 'সূর্যাস্তের সময়';

  @override
  String get prayerForbiddenSunsetBody =>
      'সূর্য ডোবার সময় নফল নামাজ শুরু করা এড়িয়ে চলুন; মাগরিবের সময় শুরু হলে মাগরিব পড়ুন।';

  @override
  String get prayerForbiddenTimeFallback => 'সময় পাওয়া যায়নি';

  @override
  String prayerForbiddenAroundTime(String time) {
    return 'প্রায় $time';
  }

  @override
  String prayerForbiddenBeforeTime(String time) {
    return '$time-এর আগে';
  }

  @override
  String get prayerReferenceTitle => 'নির্দেশনা লাইব্রেরি';

  @override
  String get prayerReferenceSubtitle =>
      'প্রয়োজন হলে বিস্তারিত খুলুন, যাতে মূল নামাজ ভিউ শান্ত ও হালকা থাকে।';

  @override
  String get prayerReferenceMovementsActionTitle => 'নামাজের অঙ্গভঙ্গি গাইড';

  @override
  String get prayerReferenceMovementsActionSubtitle =>
      'প্রতিটি অবস্থান, আরবি পাঠ, উচ্চারণ ও অর্থ একসঙ্গে দেখুন।';

  @override
  String get prayerReferenceForbiddenActionTitle => 'নিষিদ্ধ সময়';

  @override
  String get prayerReferenceForbiddenActionSubtitle =>
      'কখন নফল নামাজে বিরতি দিতে হবে জেনে নিন।';

  @override
  String get prayerReferenceNafalActionTitle => 'দৈনিক নফল নামাজ';

  @override
  String get prayerReferenceNafalActionSubtitle =>
      'তাহাজ্জুদ, ইশরাক, দুহা ও আউয়াবিন এক ধারায় দেখুন।';

  @override
  String get prayerReferenceJanazaActionTitle => 'জানাজা নামাজ';

  @override
  String get prayerReferenceJanazaActionSubtitle =>
      'চার তাকবির ও আন্তরিক দু\'আসহ দাঁড়িয়ে পড়া রহমতের নামাজ।';

  @override
  String get prayerReferenceTasbeehActionTitle => 'সালাতুত তাসবিহ';

  @override
  String get prayerReferenceTasbeehActionSubtitle =>
      'চার রাকাতে ৩০০ তাসবিহের ধারা অনুসরণ করুন।';

  @override
  String get prayerReferenceOpenLabel => 'দেখুন';

  @override
  String get prayerMovementsTitle => 'নামাজের অঙ্গভঙ্গি গাইড';

  @override
  String get prayerMovementsHeroEyebrow => 'চলনে নামাজ';

  @override
  String get prayerMovementsHeroTitle =>
      'স্বচ্ছতা, স্থিরতা ও অর্থসহ নামাজ পড়ুন';

  @override
  String get prayerMovementsHeroBody =>
      'তাকবির থেকে জিকির পর্যন্ত দৃশ্যভিত্তিক গাইড, যেখানে প্রতিটি অঙ্গভঙ্গির সঙ্গে আরবি পাঠ, উচ্চারণ ও অর্থ আছে।';

  @override
  String prayerMovementsHeroStepsCount(int count) {
    return '$countটি অবস্থান';
  }

  @override
  String get prayerMovementsHeroArabicLabel => 'আরবি + অর্থ';

  @override
  String get prayerMovementsHeroHadithLabel => 'হাদিস নোট';

  @override
  String get prayerMovementsSequenceTitle => 'অঙ্গভঙ্গির ধারাবাহিকতা';

  @override
  String get prayerMovementsSequenceSubtitle =>
      'তাকবিরে তাহরিমা থেকে নামাজের পরের জিকির পর্যন্ত একেকটি স্থির অঙ্গভঙ্গি অনুসরণ করুন।';

  @override
  String get prayerMovementsArabicLabel => 'যে আরবি পড়বেন';

  @override
  String get prayerMovementsPronunciationLabel => 'উচ্চারণ';

  @override
  String get prayerMovementsTranslationLabel => 'অর্থ';

  @override
  String get prayerMovementsNoteLabel => 'অনুশীলন নোট';

  @override
  String get prayerMovementsHadithTitle => 'হাদিসভিত্তিক স্মরণিকা';

  @override
  String get prayerMovementsHadithSubtitle =>
      'সুন্নাহ, স্থিরতা ও মনোযোগের সঙ্গে এই প্রদর্শনীকে যুক্ত রাখে এমন সংক্ষিপ্ত স্মরণিকা।';

  @override
  String get prayerMovementsHadithSourceLabel => 'সূত্র';

  @override
  String get prayerMovementsFiqhNoteTitle => 'সম্মানজনক ভিন্নতার নোট';

  @override
  String get prayerMovementsFiqhNoteBody =>
      'হাত বাঁধা, আঙুল নাড়ানো এবং কিছু শব্দচয়নে মাযহাব ও শিক্ষকের ভিত্তিতে ভিন্নতা থাকতে পারে। এটিকে বন্ধুসুলভ প্রদর্শনী হিসেবে নিন এবং নির্দিষ্ট বিধানের জন্য বিশ্বস্ত স্থানীয় নির্দেশনা অনুসরণ করুন।';

  @override
  String get prayerNafalTitle => 'দৈনিক নফল নামাজ';

  @override
  String get prayerNafalSubtitle =>
      'সকাল, দিন, সন্ধ্যা ও রাতের জন্য শান্ত ঐচ্ছিক নামাজের ধারা।';

  @override
  String get prayerNafalArabicLabel => 'نفل';

  @override
  String get prayerNafalDailyFlowLabel => 'দৈনিক ধারা';

  @override
  String get prayerNafalFlexibleLabel => 'রাকাত নমনীয়';

  @override
  String get prayerNafalTimeLabel => 'সময়';

  @override
  String get prayerNafalRakahLabel => 'রাকাত';

  @override
  String get prayerNafalBenefitLabel => 'ফজিলত';

  @override
  String get prayerNafalHadithReferencesLabel => 'হাদিসের রেফারেন্স';

  @override
  String get prayerNafalNoteTitle => 'ফিকহি কোমল নোট';

  @override
  String get prayerNafalNoteBody =>
      'এগুলো প্রচলিত নফল সময়ের বন্ধুসুলভ স্মরণিকা। মাযহাব ও শিক্ষকের ভিত্তিতে বিস্তারিত ও রাকাত সংখ্যা ভিন্ন হতে পারে, তাই নির্দিষ্ট বিষয়ে বিশ্বস্ত স্থানীয় নির্দেশনা অনুসরণ করুন।';

  @override
  String get prayerNafalTahajjudTitle => 'তাহাজ্জুদ';

  @override
  String get prayerNafalTahajjudBadge => 'গভীর রাত';

  @override
  String get prayerNafalTahajjudTime => 'ফজরের আগে রাতের শেষ তৃতীয়াংশ';

  @override
  String get prayerNafalTahajjudRakah => '২+';

  @override
  String get prayerNafalTahajjudBenefit =>
      'নীরব রাতকে দু\'আ, তওবা ও গভীর মনোযোগের সময়ে বদলে দেয়।';

  @override
  String get prayerNafalTahajjudBody =>
      'ধীরে জেগে উঠুন, দুই রাকাত করে পড়ুন, আর তিলাওয়াত শান্ত রাখুন। মনোযোগী দুই রাকাতও দিনের সবচেয়ে নীরব ভরসা হতে পারে।';

  @override
  String get prayerNafalTahajjudHadith1Source => 'সহিহ মুসলিম ১১৬৩a';

  @override
  String get prayerNafalTahajjudHadith1Body =>
      'ফরজ নামাজের পর সবচেয়ে উত্তম নামাজ হলো রাতের নামাজ।';

  @override
  String get prayerNafalIshraqTitle => 'ইশরাক';

  @override
  String get prayerNafalIshraqBadge => 'সূর্যোদয়ের পর';

  @override
  String get prayerNafalIshraqTime => 'সূর্য স্পষ্টভাবে উঠে যাওয়ার পর';

  @override
  String get prayerNafalIshraqRakah => '২';

  @override
  String get prayerNafalIshraqBenefit =>
      'ফজর, জিকির ও আশাময় সকালের শুরু একসঙ্গে যুক্ত করে।';

  @override
  String get prayerNafalIshraqBody =>
      'সূর্যোদয়ের নিষিদ্ধ সময় শেষ হওয়া পর্যন্ত অপেক্ষা করুন, তারপর হালকা মন ও আন্তরিক নিয়তে শুরু করুন।';

  @override
  String get prayerNafalIshraqHadith1Source => 'জামে আত-তিরমিজি ৫৮৬';

  @override
  String get prayerNafalIshraqHadith1Body =>
      'জামাতে ফজর, সূর্য ওঠা পর্যন্ত জিকির, তারপর দুই রাকাতের জন্য হজ ও উমরার সওয়াবের বর্ণনা এসেছে।';

  @override
  String get prayerNafalDuhaTitle => 'দুহা / চাশত';

  @override
  String get prayerNafalDuhaBadge => 'উজ্জ্বল সকাল';

  @override
  String get prayerNafalDuhaTime => 'সকাল গড়িয়ে যোহরের আগে পর্যন্ত';

  @override
  String get prayerNafalDuhaRakah => '২-৮';

  @override
  String get prayerNafalDuhaBenefit =>
      'কৃতজ্ঞতা সতেজ করে এবং শরীরের প্রতিটি জোড়ার সদকার দায়িত্ব পূরণে সাহায্য করে।';

  @override
  String get prayerNafalDuhaBody =>
      'সকালের সময়টুকু কৃতজ্ঞতা, রিজিক ও নতুন শক্তির জন্য ব্যবহার করুন, দিন ভারী হওয়ার আগেই।';

  @override
  String get prayerNafalDuhaHadith1Source => 'সহিহ মুসলিম ৭২০';

  @override
  String get prayerNafalDuhaHadith1Body =>
      'দুহার দুই রাকাত শরীরের প্রতিটি জোড়ার সকালের সদকার জন্য যথেষ্ট হয়।';

  @override
  String get prayerNafalDuhaHadith2Source =>
      'সহিহ বুখারি ১১৭৮; সহিহ মুসলিম ৭২১a';

  @override
  String get prayerNafalDuhaHadith2Body =>
      'আবু হুরাইরা (রা.)-কে নিয়মিত আমলের মধ্যে দুহা ধরে রাখতে উপদেশ দেওয়া হয়েছিল।';

  @override
  String get prayerNafalAwwabinTitle => 'আউয়াবিন';

  @override
  String get prayerNafalAwwabinBadge => 'সন্ধ্যার প্রত্যাবর্তন';

  @override
  String get prayerNafalAwwabinTime => 'মাগরিবের সুন্নতের পর, ইশার আগে';

  @override
  String get prayerNafalAwwabinRakah => '২-৬';

  @override
  String get prayerNafalAwwabinBenefit =>
      'মাগরিব-ইশার মাঝের সময়কে ছোট নফল রাকাত ও জিকিরে জীবন্ত রাখে।';

  @override
  String get prayerNafalAwwabinBody =>
      'সন্ধ্যাকে কোমল করুন: ছোট রাকাত, জিকির ও শান্ত মনোযোগে আল্লাহর দিকে ফিরে আসুন।';

  @override
  String get prayerNafalAwwabinHadith1Source =>
      'জামে আত-তিরমিজি ৪৩৫; সুনান ইবন মাজাহ ১১৬৭';

  @override
  String get prayerNafalAwwabinHadith1Body =>
      'মাগরিবের পর ছয় রাকাতের বর্ণনা এসেছে; এই বর্ণনার শক্তি নিয়ে আলেমদের আলোচনা আছে।';

  @override
  String get prayerNafalAwwabinHadith2Source => 'সহিহ মুসলিম ৭৪৮b';

  @override
  String get prayerNafalAwwabinHadith2Body =>
      'সালাতুল আউয়াবিন নামটি সহিহভাবে দুহার সময়ের নামাজের জন্যও এসেছে।';

  @override
  String get prayerHowIntentionTitle => 'নিয়ত ও প্রস্তুতি';

  @override
  String get prayerHowIntentionBody =>
      'ওজু করুন, কিবলামুখী হন, এবং শুরু করার আগে অন্তরে নিয়ত স্থির করুন।';

  @override
  String get prayerHowQiyamTitle => 'কিয়াম';

  @override
  String get prayerHowQiyamBody =>
      'শান্তভাবে দাঁড়ান, তাকবিরে তাহরিমা বলুন, সূরা ফাতিহা পড়ুন, তারপর কুরআন থেকে যা সহজ হয় পড়ুন।';

  @override
  String get prayerHowRukuTitle => 'রুকু';

  @override
  String get prayerHowRukuBody =>
      'পিঠ স্থির রেখে রুকু করুন, আল্লাহর পবিত্রতা ঘোষণা করুন, তারপর শান্তভাবে উঠে দাঁড়ান।';

  @override
  String get prayerHowSujoodTitle => 'সিজদা';

  @override
  String get prayerHowSujoodBody =>
      'বিনয়ের সঙ্গে সিজদা করুন, তাড়াহুড়া না করে থামুন, তারপর সংক্ষিপ্ত বসে দ্বিতীয় সিজদা সম্পন্ন করুন।';

  @override
  String get prayerHowTashahhudTitle => 'তাশাহহুদ';

  @override
  String get prayerHowTashahhudBody =>
      'শেষ বৈঠকে তাশাহহুদ পড়ুন এবং নবীজির ওপর দরুদ পাঠ করুন।';

  @override
  String get prayerHowSalamTitle => 'সালাম';

  @override
  String get prayerHowSalamBody =>
      'সালামের মাধ্যমে নামাজ শেষ করুন, তারপর সংক্ষিপ্ত জিকির ও দু\'আর জন্য মনোযোগ ধরে রাখুন।';

  @override
  String get prayerFocusFajrTitle => 'ফজরের সময়';

  @override
  String get prayerFocusFajrSubtitle =>
      'পৃথিবী ব্যস্ত হওয়ার আগেই দিন শুরু করুন।';

  @override
  String get prayerFocusSunriseTitle => 'সূর্যোদয়ের বিরতি';

  @override
  String get prayerFocusSunriseSubtitle =>
      'ফজরের পর শান্ত একটি রূপান্তর; ঐচ্ছিক দুহা শুরু করার আগে অপেক্ষা করুন।';

  @override
  String get prayerFocusDhuhrTitle => 'যোহরের নবায়ন';

  @override
  String get prayerFocusDhuhrSubtitle =>
      'দিনের মাঝামাঝি সময়কে পরিচ্ছন্ন আধ্যাত্মিক রিসেটে বদলে দিন।';

  @override
  String get prayerFocusAsrTitle => 'আসরের পাহারা';

  @override
  String get prayerFocusAsrSubtitle =>
      'কাজকর্ম মনোযোগ ছড়িয়ে দেওয়ার আগে বিকেলকে রক্ষা করুন।';

  @override
  String get prayerFocusMaghribTitle => 'মাগরিবে ফিরে আসা';

  @override
  String get prayerFocusMaghribSubtitle =>
      'সূর্যাস্ত থেকে দ্রুত স্মরণ ও কৃতজ্ঞতায় ফিরে আসুন।';

  @override
  String get prayerFocusIshaTitle => 'ইশার সমাপ্তি';

  @override
  String get prayerFocusIshaSubtitle =>
      'শান্তি, তাওবা এবং ফজরের প্রস্তুতি দিয়ে দিন শেষ করুন।';

  @override
  String get prayerNowFajrTitle => 'ভোরকে রক্ষা করুন';

  @override
  String get prayerNowFajrBody =>
      'সূর্যোদয়ের আগে ফজরের সময়কে রক্ষা করুন। এখনও না পড়ে থাকলে ওজু করে এখনই পড়ুন; পড়ে থাকলে সকালের জিকির বা কুরআনের সঙ্গে থাকুন।';

  @override
  String get prayerNowSunriseTitle => 'বিরতি নিন ও স্মরণ করুন';

  @override
  String get prayerNowSunriseBody =>
      'ঠিক সূর্যোদয়ের সময় নফল নামাজ শুরু করা এড়িয়ে চলুন; সকালের জিকির চালিয়ে যান এবং সূর্য ওঠার পর দুহার জন্য অপেক্ষা করুন।';

  @override
  String get prayerNowDhuhrTitle => 'দিনের মাঝখানে রিসেট করুন';

  @override
  String get prayerNowDhuhrBody =>
      'কাজ থেকে একটু সরে আসুন, ওজু নবায়ন করুন, এবং ফরজ নামাজকে তাড়াহুড়াহীন মনোযোগ দিন।';

  @override
  String get prayerNowAsrTitle => 'বিকেলকে রক্ষা করুন';

  @override
  String get prayerNowAsrBody =>
      'দিন ভিড়ভাট্টা হওয়ার আগে আসরকে সামনে আনুন। স্থির গতিতে নামাজ পড়ুন এবং শেষে সংক্ষিপ্ত জিকিরের সময় রাখুন।';

  @override
  String get prayerNowMaghribTitle => 'দ্রুত এগিয়ে যান';

  @override
  String get prayerNowMaghribBody =>
      'মাগরিবের সময় হলে সূর্যাস্তের কাজ থেকে দ্রুত নামাজে যান, তারপর হালকা হৃদয়ে পরিবার, খাবার বা যাত্রায় ফিরুন।';

  @override
  String get prayerNowIshaTitle => 'দিনটি সুন্দরভাবে শেষ করুন';

  @override
  String get prayerNowIshaBody =>
      'ঘুম ঘিরে ধরার আগেই ইশা পড়ুন। তাওবা, কৃতজ্ঞতা এবং ফজরের জন্য সহজ পরিকল্পনার সঙ্গে এটি জুড়ে দিন।';

  @override
  String get prayerSuggestionsFajrRaw =>
      'সামর্থ্য হলে ফরজের আগে দুই রাকাআত সুন্নাহ পড়ুন।||তিলাওয়াত ছোট হলেও শান্ত ও উজ্জ্বল রাখুন।||নামাজের পর কয়েক মিনিট সকালের জিকির বা অল্প কুরআন পাঠে দিন।';

  @override
  String get prayerSuggestionsSunriseRaw =>
      'সূর্য ওঠার সময় সকালের জিকির চালিয়ে যান।||সূর্যোদয়ের অপছন্দনীয় মুহূর্ত পার হওয়া পর্যন্ত ঐচ্ছিক দুহার জন্য অপেক্ষা করুন।||এ শান্ত সময়টিকে ভেসে না দিয়ে পরবর্তী নামাজের পরিকল্পনায় ব্যবহার করুন।';

  @override
  String get prayerSuggestionsDhuhrRaw =>
      'আজানকে কাজ বা পড়াশোনা থেকে দৃঢ় বিরতি হিসেবে নিন।||দিন আবার ব্যস্ত হওয়ার আগে শান্ত জায়গা বেছে নিন।||কাজে ফেরার আগে ছোট্ট কৃতজ্ঞতার যাচাইয়ের সঙ্গে নামাজটি জুড়ে দিন।';

  @override
  String get prayerSuggestionsAsrRaw =>
      'বিকেলের ব্যস্ততা শুরু হওয়ার আগেই আসরের পরিকল্পনা করুন।||চাপা তাড়াহুড়ার বদলে গতি স্থির রাখুন।||সালামের পর এক মিনিট আল্লাহর কাছে হিফাজত ও ধারাবাহিকতা চান।';

  @override
  String get prayerSuggestionsMaghribRaw =>
      'দৈনন্দিন জীবনে সময়টি ছোট মনে হয়, তাই আজানের পর দ্রুত নামাজ পড়ুন।||খাবার, পরিবার বা যাত্রাপথ যেন নামাজকে ঢেকে না ফেলে।||রুটিনে সম্ভব হলে সন্ধ্যার জিকির দিয়ে অনুসরণ করুন।';

  @override
  String get prayerSuggestionsIshaRaw =>
      'ঘুম মনোযোগ ভারী করার আগেই নামাজ পড়ুন।||নিজের অনুশীলন অনুযায়ী ইশার পর বিতরের প্রস্তুতি রাখুন।||ঘুমের আগে আগামী ফজরের ব্যবস্থা করুন: অ্যালার্ম, ওজুর পরিকল্পনা, এবং ঘুমের নিয়ত।';

  @override
  String get prayerBestPracticesFajrRaw =>
      'ফজরকে মাথায় রেখে ঘুমান, পরে দেখা যাবে এমন ভাবনায় নয়।||দিনের প্রথম নামাজ তাড়াহুড়া করে নয়; এটিকে দিনের সুর বানাতে দিন।||ফজরের পরের নীরবতা কুরআন, জিকির বা এক আন্তরিক দু\'আর জন্য ব্যবহার করুন।';

  @override
  String get prayerBestPracticesSunriseRaw =>
      'সূর্যোদয়কে ফরজ নামাজ ভাববেন না; এটি একটি সময়-পরিবর্তনের চিহ্ন।||ঠিক সূর্যোদয়ের মুহূর্তে নফল নামাজ থেকে বিরত থাকুন।||সূর্য উঠে সময় পরিষ্কার হলে ঐচ্ছিক ইবাদতে ফিরুন।';

  @override
  String get prayerBestPracticesDhuhrRaw =>
      'কর্মদিবস পুরোটা দখল করার আগেই যোহরকে ক্যালেন্ডারে রাখুন।||পুরো কাজের তালিকা নামাজে নিয়ে না দাঁড়ানোর চেষ্টা করুন।||সুন্নাহ নামাজ পড়লে শেখা অনুশীলন অনুযায়ী ফরজের আগে-পরে সাজান।';

  @override
  String get prayerBestPracticesAsrRaw =>
      'আসরের সময় একেবারে শেষ প্রান্তে ঠেলে দেওয়া থেকে রক্ষা করুন।||তাকবিরের আগে গতি কমান, যাতে নামাজ দৌড়ের মতো না লাগে।||বাকি দিনের জন্য আসরকে আত্মপর্যালোচনার চেকপয়েন্ট বানান।';

  @override
  String get prayerBestPracticesMaghribRaw =>
      'মাগরিবের সময় হলে দ্রুত সাড়া দিন।||সূর্যাস্তের খাবার বা জমায়েত যেন নামাজ বিলম্বিত না করে।||মাগরিব দিয়ে সন্ধ্যার জিকির ও পারিবারিক শান্তির দরজা খুলুন।';

  @override
  String get prayerBestPracticesIshaRaw =>
      'ক্লান্তি মনোযোগ ম্লান করার আগে নামাজ পড়ুন।||নিজের অনুশীলন অনুযায়ী রাতের রুটিনে বিতরকে দৃশ্যমান রাখুন।||ঘুমানোর আগে শরীর ও ঘরকে ফজরের জন্য প্রস্তুত করুন।';

  @override
  String get learnQuranTextMapRaw =>
      'Arabic Letters=আরবি বর্ণমালা||Pronunciation Basics=উচ্চারণের ভিত্তি||Makharij=মাখারিজ||Tajweed Rules=তাজবিদের নিয়ম||Word-by-Word Understanding=শব্দে-শব্দে বুঝে পড়া||Short Surah Practice=ছোট সূরা অনুশীলন||Audio Assisted Practice=অডিও সহায়তায় অনুশীলন||Beginner=শুরুর স্তর||Beginner to Intermediate=শুরুর স্তর থেকে মধ্যম||Intermediate=মধ্যম||Track Flow=শেখার ধারা||Word map=শব্দ মানচিত্র||Meaning=অর্থ||Family=পরিবার||Core meaning=মূল অর্থ||Examples=উদাহরণ||Tip=টিপস||Focus=ফোকাস||Function=কার্য||Sample=নমুনা||Reading cue=পাঠ নির্দেশনা||Distinction=পার্থক্য||Practice=অনুশীলন||Watch for=খেয়াল রাখুন||Location=অবস্থান||Sound cue=ধ্বনি নির্দেশনা||Common mistake=সাধারণ ভুল||Drill=ড্রিল||Goal=লক্ষ্য||Success marker=সফলতার সূচক||Listen for=শুনে ধরুন||Repeat target=পুনরাবৃত্তির লক্ষ্য||Pacing=গতি||Action=করণীয়||Check prompt=পরীক্ষা নির্দেশনা||Common signs=সাধারণ লক্ষণ||Fix=সংশোধন||Pause=বিরতি||Restart=পুনরারম্ভ||Example=উদাহরণ||Base letter=মূল বর্ণ||Fatha=ফাতহা||Kasra=কাসরা||Damma=দাম্মা||Sukoon=সুকুন||Sound=ধ্বনি||Count=গণনা||Note=নোট||Qalqalah Focus=কালকালাহ ফোকাস||Madd Focus=মাদ্দ ফোকাস||Trigger=ট্রিগার||Delivery=প্রয়োগ পদ্ধতি||How to read=কীভাবে পড়বেন||Coach note=শিক্ষকের নোট||Objective=উদ্দেশ্য||Key theme=মূল বিষয়||Recitation target=তিলাওয়াতের লক্ষ্য||Practice prompt=অনুশীলনের নির্দেশনা||Light sample=হালকা নমুনা||Heavy sample=ভারী নমুনা||Coach tip=শিক্ষকের টিপস||Do this=এভাবে করুন||Message=বার্তা||Recitation cue=তিলাওয়াত নির্দেশনা||Rule=নিয়ম||Correction=সংশোধন||When=কখন||I can recognize at least 20 high-frequency Quran words quickly.=আমি দ্রুত কমপক্ষে ২০টি বহুল ব্যবহৃত কুরআনের শব্দ চিনতে পারি।||I can infer general meaning from common root families.=আমি প্রচলিত মূল-পরিবার থেকে সাধারণ অর্থ অনুমান করতে পারি।||I can identify connector particles and their phrase role.=আমি সংযোজক কণাগুলো এবং বাক্যে তাদের ভূমিকা শনাক্ত করতে পারি।||I can break a short ayah into word groups with translation awareness.=আমি অনুবাদ-বোঝাপড়াসহ একটি ছোট আয়াতকে শব্দগুচ্ছে ভাগ করতে পারি।||I can summarize one short surah in simple meaning-based notes.=আমি সহজ অর্থভিত্তিক নোটে একটি ছোট সূরার সারসংক্ষেপ দিতে পারি।||Word-by-Word Learning=শব্দে-শব্দে শেখা||Audio-Assisted Lessons=অডিও-সহায়তায় পাঠ||All levels=সব স্তর||Difference=পার্থক্য||Indicator=ইঙ্গিত||Do=করুন||Avoid=এড়িয়ে চলুন||Duration=সময়কাল||Output=ফলাফল||Target=লক্ষ্য||From alphabet recognition to first reading drills=বর্ণমালা চেনা থেকে প্রথম পাঠ-ড্রিল পর্যন্ত||Master the full Arabic letter foundation used in Quran reading: isolated forms, similar-letter distinction, beginner pronunciation, and practical review drills.=কুরআন পাঠে ব্যবহৃত পূর্ণ আরবি বর্ণভিত্তি আয়ত্ত করুন: পৃথক রূপ, মিলযুক্ত বর্ণের পার্থক্য, প্রাথমিক উচ্চারণ এবং ব্যবহারিক রিভিউ ড্রিল।||Heavy-light clarity, madd, and recitation flow=ভারী-হালকা ধ্বনির স্বচ্ছতা, মাদ্দ ও তিলাওয়াতের প্রবাহ||Build clear Quran pronunciation through contrast training, articulation cues, controlled lengthening, and guided pause-restart drills.=কনট্রাস্ট অনুশীলন, উচ্চারণ নির্দেশনা, নিয়ন্ত্রিত টান এবং বিরতি-শুরু ড্রিলের মাধ্যমে পরিষ্কার কুরআনিক উচ্চারণ গড়ে তুলুন।||Mapped articulation zones and precision drills=উচ্চারণস্থান মানচিত্র ও নিখুঁত ড্রিল||Learn the exact articulation origins of Quran letters through zone mapping, contrast practice, and guided phrase drills.=জোন ম্যাপিং, কনট্রাস্ট অনুশীলন এবং নির্দেশিত ফ্রেজ ড্রিলের মাধ্যমে কুরআনের বর্ণের সুনির্দিষ্ট উচ্চারণস্থান শিখুন।||Rule-by-rule application with guided drills=ধাপে ধাপে নিয়ম প্রয়োগের গাইডেড ড্রিল||Learn and apply core tajweed rules step by step with focused examples, correction drills, and integrated recitation practice.=নির্বাচিত উদাহরণ, সংশোধনী ড্রিল এবং সমন্বিত তিলাওয়াত অনুশীলনের মাধ্যমে মূল তাজবিদ নিয়ম ধাপে ধাপে শিখুন ও প্রয়োগ করুন।||Vocabulary, roots, and ayah meaning mapping=শব্দভান্ডার, মূলধাতু ও আয়াতের অর্থ মানচিত্র||Build practical Quran understanding through high-frequency vocabulary, root-pattern recognition, connector awareness, and phrase-by-phrase meaning drills.=বহুল ব্যবহৃত শব্দভান্ডার, ধাতু-প্যাটার্ন চেনা, সংযোজক বোঝাপড়া এবং ফ্রেজভিত্তিক অর্থ অনুশীলনের মাধ্যমে ব্যবহারিক কুরআন বোঝাপড়া তৈরি করুন।||Salah-ready recitation with memorization flow=সালাত-প্রস্তুত তিলাওয়াত ও মুখস্থের ধারা||Practice essential short surahs through memorization cycles, tajweed targets, meaning-linked recitation, and prayer-ready fluency checks.=মুখস্থ চক্র, তাজবিদ লক্ষ্য, অর্থসংযুক্ত তিলাওয়াত এবং সালাত-প্রস্তুত সাবলীলতার মূল্যায়নের মাধ্যমে প্রয়োজনীয় ছোট সূরা অনুশীলন করুন।||Focused listening, shadowing, and correction loops=মনোযোগী শোনা, শ্যাডো অনুশীলন ও সংশোধন চক্র||Build strong recitation quality through audio-first drills, imitation practice, structured error detection, and confidence-focused feedback cycles.=অডিও-প্রথম ড্রিল, অনুকরণ অনুশীলন, কাঠামোবদ্ধ ভুল শনাক্তকরণ এবং আত্মবিশ্বাসভিত্তিক ফিডব্যাক চক্রের মাধ্যমে তিলাওয়াতের মান শক্তিশালী করুন।||1) High-Frequency Vocabulary Bank=১) বহুল ব্যবহৃত শব্দভান্ডার ব্যাংক||Memorize recurring Quran words so ayah meaning becomes easier to follow in real time.=পুনরাবৃত্ত কুরআনিক শব্দ মুখস্থ করুন, যাতে বাস্তবে আয়াতের অর্থ অনুসরণ করা সহজ হয়।||2) Root Family Mapping=২) মূলধাতু পরিবার মানচিত্র||Recognize core roots so unfamiliar words still reveal approximate meaning.=মূল ধাতু চিনে নিন, যাতে অচেনা শব্দ থেকেও আনুমানিক অর্থ বোঝা যায়।||3) Connector Words and Particle Cues=৩) সংযোজক শব্দ ও পার্টিকল নির্দেশনা||Spot linking words that shape sentence meaning, sequence, emphasis, and direction.=বাক্যের অর্থ, ক্রম, জোর ও দিক নির্ধারণকারী সংযোজক শব্দগুলো শনাক্ত করুন।||4) Phrase Breakdown Lab=৪) ফ্রেজ বিশ্লেষণ ল্যাব||Break phrases into word units, then reconnect them into complete meaning.=ফ্রেজকে শব্দ এককে ভেঙে নিন, তারপর পূর্ণ অর্থে আবার যুক্ত করুন।||5) Ayah Word Map Practice=৫) আয়াত শব্দ-মানচিত্র অনুশীলন||Apply vocabulary and connector awareness to complete ayah passages.=শব্দভান্ডার ও সংযোজক বোঝাপড়া ব্যবহার করে পূর্ণ আয়াতাংশ অনুধাবন করুন।||Follow this flow to move from vocabulary recognition to ayah-level understanding.=এই ধারা অনুসরণ করে শব্দ চিনে নেওয়া থেকে আয়াত-স্তরের বোঝাপড়ায় যান।||6) Revision and Mastery Checklist=৬) রিভিউ ও দক্ষতা চেকলিস্ট||Use this cycle to shift from memorizing isolated words to understanding recitation meaning.=এই চক্র ব্যবহার করে বিচ্ছিন্ন শব্দ মুখস্থ করা থেকে তিলাওয়াতের অর্থ বোঝায় অগ্রসর হোন।||1) Full Alphabet Map (Isolated Forms)=১) পূর্ণ বর্ণমালা মানচিত্র (পৃথক রূপ)||Start by mastering isolated letters. Read each symbol, then say its name and sound value.=পৃথক বর্ণরূপ দিয়ে শুরু করুন। প্রতিটি চিহ্ন পড়ুন, তারপর তার নাম ও ধ্বনি বলুন।||2) Grouped Shape Learning=২) গুচ্ছভিত্তিক আকৃতি শেখা||Learn high-retention groups so you can decode letters quickly during reading.=উচ্চ-ধারণক্ষমতার বর্ণগুচ্ছ শিখুন, যাতে পড়ার সময় দ্রুত বর্ণ চেনা যায়।||3) Similar Letter Comparison Grid=৩) সাদৃশ্যপূর্ণ বর্ণ তুলনা গ্রিড||Use this as your anti-confusion reference. Compare shape and sound before speed.=এটিকে বিভ্রান্তি-রোধী রেফারেন্স হিসেবে ব্যবহার করুন। গতি বাড়ানোর আগে আকৃতি ও ধ্বনি তুলনা করুন।||4) Beginner Pronunciation and Articulation Hints=৪) প্রাথমিক উচ্চারণ ও উচ্চারণস্থানের নির্দেশনা||These cues guide where each sound is produced. Keep tone natural and avoid over-force.=প্রতিটি ধ্বনি কোথা থেকে উচ্চারিত হয় তা বুঝতে এই নির্দেশনা অনুসরণ করুন। স্বর স্বাভাবিক রাখুন এবং অতিরিক্ত চাপ এড়িয়ে চলুন।||5) Harakat and Sukoon Pattern Practice=৫) হারাকাত ও সুকুন ধরণ অনুশীলন||Read each row slowly. Keep vowel quality stable: fatha (a), kasra (i), damma (u), sukoon (no vowel).=প্রতিটি সারি ধীরে পড়ুন। স্বরধ্বনির মান স্থির রাখুন: ফাতহা (a), কাসরা (i), দাম্মা (u), সুকুন (স্বরহীন)।||6) Example-Based Beginner Reading Cards=৬) উদাহরণভিত্তিক প্রাথমিক পাঠ কার্ড||These words reinforce letters, vowels, and stops used in early Quran recitation.=এই শব্দগুলো প্রাথমিক কুরআন তিলাওয়াতে ব্যবহৃত বর্ণ, স্বরচিহ্ন ও থামার নিয়মকে দৃঢ় করে।||7) Guided Review and Mastery Check=৭) নির্দেশিত রিভিউ ও দক্ষতা যাচাই||Use this block as your daily 12-minute revision loop until recognition and pronunciation feel natural.=চেনা ও উচ্চারণ স্বাভাবিক না হওয়া পর্যন্ত প্রতিদিন ১২ মিনিটের এই রিভিউ ব্লকটি অনুশীলন করুন।||Fatha = short a=ফাতহা = ছোট a||Kasra = short i=কাসরা = ছোট i||Damma = short u=দাম্মা = ছোট u||Sukoon = stop/closed=সুকুন = থামা/বন্ধ||I can name and identify all 29 letters in isolated form.=আমি পৃথক রূপে ২৯টি বর্ণের নাম বলতে ও শনাক্ত করতে পারি।||I can separate look-alike letters by dot count and position.=আমি দেখতে একইরকম বর্ণগুলোকে বিন্দুর সংখ্যা ও অবস্থান দিয়ে আলাদা করতে পারি।||I can produce basic throat, tongue, and lip letters with control.=আমি গলা, জিহ্বা ও ঠোঁটের প্রাথমিক বর্ণগুলো নিয়ন্ত্রিতভাবে উচ্চারণ করতে পারি।||I can read fatha, kasra, damma, and sukoon patterns aloud.=আমি ফাতহা, কাসরা, দাম্মা ও সুকুনের ধরণ জোরে পড়তে পারি।||I can read beginner examples without adding extra vowels.=আমি অতিরিক্ত স্বর না যোগ করে প্রাথমিক উদাহরণগুলো পড়তে পারি।||1) Focused Listening Drills=১) মনোযোগী শোনার ড্রিল||Train your ear before speaking so imitation and correction become easier.=কথা বলার আগে কানকে প্রশিক্ষণ দিন, যাতে অনুকরণ ও সংশোধন সহজ হয়।||2) Shadow Recitation Rounds=২) শ্যাডো তিলাওয়াত রাউন্ড||Imitate audio in staged levels so your articulation and timing transfer into solo recitation.=ধাপে ধাপে অডিও অনুকরণ করুন, যাতে উচ্চারণ ও সময়নিয়ন্ত্রণ একক তিলাওয়াতে চলে আসে।||3) Error Spot and Fix Map=৩) ভুল শনাক্তকরণ ও সংশোধন মানচিত্র||Use structured checks to detect recurring mistakes and apply targeted corrections.=পুনরাবৃত্ত ভুল শনাক্ত করে লক্ষ্যভিত্তিক সংশোধন করতে কাঠামোবদ্ধ যাচাই ব্যবহার করুন।||4) Guided Audio Session Plan=৪) নির্দেশিত অডিও সেশন পরিকল্পনা||Use a fixed routine to structure listening, imitation, correction, and final confidence recitation.=শোনা, অনুকরণ, সংশোধন এবং আত্মবিশ্বাসী চূড়ান্ত তিলাওয়াতের জন্য নির্দিষ্ট রুটিন অনুসরণ করুন।||5) Targeted Audio Sample Practice=৫) লক্ষ্যভিত্তিক অডিও স্যাম্পল অনুশীলন||Practice selected ayah sets with clear listening goals and repeat targets.=পরিষ্কার শোনার লক্ষ্য ও পুনরাবৃত্তি টার্গেট রেখে নির্দিষ্ট আয়াত-সেট অনুশীলন করুন।||Follow this sequence to improve listening accuracy, imitation quality, and self-correction.=শোনার নির্ভুলতা, অনুকরণের মান এবং স্ব-সংশোধন উন্নত করতে এই ক্রম অনুসরণ করুন।||Repeat this block to transform assisted listening into independent recitation quality.=সহায়ক শোনা থেকে স্বতন্ত্র তিলাওয়াতের মানে যেতে এই ব্লকটি পুনরাবৃত্তি করুন।||I can complete focused listening before imitation.=আমি অনুকরণ শুরুর আগে মনোযোগী শোনা সম্পন্ন করতে পারি।||I can shadow recite while maintaining phrase timing.=আমি ফ্রেজের সময়মাত্রা ঠিক রেখে শ্যাডো তিলাওয়াত করতে পারি।||I can detect and correct at least two repeating mistakes.=আমি অন্তত দুটি পুনরাবৃত্ত ভুল শনাক্ত করে সংশোধন করতে পারি।||I can recite solo with stable rhythm after audio guidance.=অডিও নির্দেশনার পরে আমি স্থির ছন্দে একক তিলাওয়াত করতে পারি।||I can compare my recording and explain one improvement point.=আমি নিজের রেকর্ডিং তুলনা করে অন্তত একটি উন্নয়নের দিক ব্যাখ্যা করতে পারি।||7) Revision Block and Mastery Checklist=৭) রিভিউ ব্লক ও দক্ষতা চেকলিস্ট||Run this block daily for one week to stabilize your Pronunciation Basics track.=প্রোনানসিয়েশন বেসিকস ট্র্যাক স্থিতিশীল করতে এক সপ্তাহ প্রতিদিন এই ব্লকটি করুন।||I can distinguish heavy and light pairs without hesitation.=আমি দ্বিধা ছাড়াই ভারী ও হালকা জোড়াগুলো আলাদা করতে পারি।||I can keep natural madd at a consistent 2-beat timing.=আমি স্বাভাবিক মাদ্দ ধারাবাহিক ২-বিট সময়মাত্রায় রাখতে পারি।||I can stop without adding an extra vowel sound.=আমি অতিরিক্ত স্বরধ্বনি যোগ না করে থামতে পারি।||I can restart phrases with stable tone and rhythm.=আমি স্থির স্বর ও ছন্দে ফ্রেজ পুনরারম্ভ করতে পারি।||I can complete one short recitation with clear pronunciation.=আমি স্পষ্ট উচ্চারণে একটি ছোট তিলাওয়াত সম্পন্ন করতে পারি।||Use this review block daily to lock articulation precision into regular recitation.=উচ্চারণের নিখুঁততা নিয়মিত তিলাওয়াতে স্থির করতে প্রতিদিন এই রিভিউ ব্লকটি ব্যবহার করুন।||I can identify each major makhraj zone and its core letters.=আমি প্রতিটি প্রধান মাখরাজ জোন ও তার মূল বর্ণগুলো শনাক্ত করতে পারি।||I can recite throat letters with distinct sound depth.=আমি গলার বর্ণগুলো স্বতন্ত্র ধ্বনির গভীরতাসহ তিলাওয়াত করতে পারি।||I can maintain separation in key confusion pairs.=আমি গুরুত্বপূর্ণ বিভ্রান্তিকর জোড়াগুলোতে স্পষ্ট পার্থক্য বজায় রাখতে পারি।||I can keep lip letters and ghunnah controlled in flow.=আমি তিলাওয়াতের প্রবাহে ঠোঁটের বর্ণ ও গুন্নাহ নিয়ন্ত্রিত রাখতে পারি।||I can apply makharij cues in at least one short surah recitation.=আমি অন্তত একটি ছোট সূরার তিলাওয়াতে মাখারিজ নির্দেশনা প্রয়োগ করতে পারি।||Use this routine repeatedly until rule application becomes consistent in live recitation.=সরাসরি তিলাওয়াতে নিয়ম প্রয়োগ ধারাবাহিক না হওয়া পর্যন্ত এই রুটিন বারবার অনুশীলন করুন।||I can identify the four noon/tanween rules from examples.=আমি উদাহরণ থেকে নূন/তানউইনের চারটি নিয়ম শনাক্ত করতে পারি।||I can apply meem saakin rules with correct lip and ghunnah control.=আমি সঠিক ঠোঁট ও গুন্নাহ নিয়ন্ত্রণসহ মীম সাকিনের নিয়ম প্রয়োগ করতে পারি।||I can produce qalqalah bounce without adding extra vowels.=আমি অতিরিক্ত স্বর যোগ না করে সঠিক কালকালাহ কম্পন দিতে পারি।||I can maintain madd counts and planned waqf points.=আমি মাদ্দের গণনা ও পরিকল্পিত ওয়াক্‌ফ পয়েন্ট বজায় রাখতে পারি।||I can recite a short surah with visible tajweed awareness.=আমি দৃশ্যমান তাজবিদ সচেতনতা নিয়ে একটি ছোট সূরা তিলাওয়াত করতে পারি।||Use this revision loop to turn short surah memorization into long-term confidence.=এই রিভিশন লুপ ব্যবহার করে ছোট সূরা মুখস্থকে দীর্ঘমেয়াদি আত্মবিশ্বাসে রূপ দিন।||I can recite at least 4 short surahs without looking at the text.=আমি লেখা না দেখে অন্তত ৪টি ছোট সূরা তিলাওয়াত করতে পারি।||I can maintain steady pace suitable for salah recitation.=আমি সালাতের উপযোগী স্থির গতি বজায় রাখতে পারি।||I can apply key tajweed targets inside each short surah.=আমি প্রতিটি ছোট সূরায় গুরুত্বপূর্ণ তাজবিদ লক্ষ্য প্রয়োগ করতে পারি।||I can stop and restart at meaningful phrase boundaries.=আমি অর্থবহ ফ্রেজ সীমায় থামতে ও পুনরারম্ভ করতে পারি।||I can summarize the core message of each practiced surah.=আমি অনুশীলিত প্রতিটি সূরার মূল বার্তা সংক্ষেপে বলতে পারি।';
}

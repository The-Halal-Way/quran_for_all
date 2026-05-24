import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Quran For All'**
  String get appName;

  /// No description provided for @homeDashboardTab.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeDashboardTab;

  /// No description provided for @homeReadQuranTab.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get homeReadQuranTab;

  /// No description provided for @homeLearnQuranTab.
  ///
  /// In en, this message translates to:
  /// **'Learn Quran'**
  String get homeLearnQuranTab;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageBangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get languageBangla;

  /// No description provided for @learnQuranPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Quran'**
  String get learnQuranPageTitle;

  /// No description provided for @learnQuranTracksTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Tracks'**
  String get learnQuranTracksTitle;

  /// No description provided for @learnQuranTracksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow these sections in order or focus on the area you want to improve today.'**
  String get learnQuranTracksSubtitle;

  /// No description provided for @learnHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Quran'**
  String get learnHeaderTitle;

  /// No description provided for @learnHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Structured lessons for letters, tajweed, and recitation confidence.'**
  String get learnHeaderSubtitle;

  /// No description provided for @learnHeaderLessonProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String learnHeaderLessonProgress(int completed, int total);

  /// No description provided for @learnHeaderModulesLabel.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get learnHeaderModulesLabel;

  /// No description provided for @learnHeaderStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get learnHeaderStreakLabel;

  /// No description provided for @learnHeaderStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String learnHeaderStreakDays(int days);

  /// No description provided for @learnModuleStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learnModuleStatusCompleted;

  /// No description provided for @learnModuleStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get learnModuleStatusNotStarted;

  /// No description provided for @learnModuleStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get learnModuleStatusInProgress;

  /// No description provided for @learnMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String learnMinutesShort(int minutes);

  /// No description provided for @learnCompletedFraction.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total}'**
  String learnCompletedFraction(int completed, int total);

  /// No description provided for @learnNextContinuePathTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your path'**
  String get learnNextContinuePathTitle;

  /// No description provided for @learnNextAllLessonsCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'All lessons completed'**
  String get learnNextAllLessonsCompletedTitle;

  /// No description provided for @learnNextAllLessonsCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Excellent work. Revisit any module to reinforce your learning.'**
  String get learnNextAllLessonsCompletedBody;

  /// No description provided for @learnNextStartLessonButton.
  ///
  /// In en, this message translates to:
  /// **'Start Next Lesson'**
  String get learnNextStartLessonButton;

  /// No description provided for @learnNextReviewModulesButton.
  ///
  /// In en, this message translates to:
  /// **'Review Modules'**
  String get learnNextReviewModulesButton;

  /// No description provided for @learnLessonTooltipPauseAudio.
  ///
  /// In en, this message translates to:
  /// **'Pause lesson sample audio'**
  String get learnLessonTooltipPauseAudio;

  /// No description provided for @learnLessonTooltipPlayAudio.
  ///
  /// In en, this message translates to:
  /// **'Play lesson sample audio'**
  String get learnLessonTooltipPlayAudio;

  /// No description provided for @learnLessonAudioGuided.
  ///
  /// In en, this message translates to:
  /// **'Audio guided'**
  String get learnLessonAudioGuided;

  /// No description provided for @learnLessonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get learnLessonDone;

  /// No description provided for @learnLessonDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String learnLessonDurationMinutes(int minutes);

  /// No description provided for @learnModuleLessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String learnModuleLessonsCompleted(int completed, int total);

  /// No description provided for @learnVmErrorLoadProgress.
  ///
  /// In en, this message translates to:
  /// **'Unable to load learning progress right now.'**
  String get learnVmErrorLoadProgress;

  /// No description provided for @learnVmErrorSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Unable to save progress. Please try again.'**
  String get learnVmErrorSaveProgress;

  /// No description provided for @learnVmAudioMissingSample.
  ///
  /// In en, this message translates to:
  /// **'No audio sample is attached to this lesson yet.'**
  String get learnVmAudioMissingSample;

  /// No description provided for @learnVmAudioSampleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Could not find the sample ayah audio for this lesson.'**
  String get learnVmAudioSampleNotFound;

  /// No description provided for @learnVmAudioPlayFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to play lesson audio right now.'**
  String get learnVmAudioPlayFailed;

  /// No description provided for @duahDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Du\'a'**
  String get duahDailyTitle;

  /// No description provided for @duahDailySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Supplications for every moment'**
  String get duahDailySubtitle;

  /// No description provided for @duahPowerfulTitle.
  ///
  /// In en, this message translates to:
  /// **'Powerful Du\'as'**
  String get duahPowerfulTitle;

  /// No description provided for @duahLanguageToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get duahLanguageToggleTooltip;

  /// No description provided for @duahLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get duahLevelBeginner;

  /// No description provided for @duahLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get duahLevelIntermediate;

  /// No description provided for @duahLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get duahLevelAdvanced;

  /// No description provided for @duahLevelBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Short, easy-to-memorize du\'as for everyday moments. Perfect to start your journey.'**
  String get duahLevelBeginnerDesc;

  /// No description provided for @duahLevelIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Fuller wordings with richer meaning. Ideal once the basics feel natural.'**
  String get duahLevelIntermediateDesc;

  /// No description provided for @duahLevelAdvancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete authentic du\'as including optional additions and all daily situations.'**
  String get duahLevelAdvancedDesc;

  /// No description provided for @duahCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} du\'as'**
  String duahCountLabel(int count);

  /// No description provided for @duahShowVariants.
  ///
  /// In en, this message translates to:
  /// **'Show variants'**
  String get duahShowVariants;

  /// No description provided for @duahHideVariants.
  ///
  /// In en, this message translates to:
  /// **'Hide variants'**
  String get duahHideVariants;

  /// No description provided for @duahCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get duahCopied;

  /// No description provided for @duahCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get duahCopy;

  /// No description provided for @duahPowerfulImportantNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Important note'**
  String get duahPowerfulImportantNoteTitle;

  /// No description provided for @duahPowerfulImportantNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Du\'a is answered in the way Allah wills, at the time He wills, and in the form He wills. These are authentic and deeply beloved supplications from Qur\'anic and Prophetic sources.'**
  String get duahPowerfulImportantNoteBody;

  /// No description provided for @duahPowerfulBestFive.
  ///
  /// In en, this message translates to:
  /// **'Best 5 to memorize first'**
  String get duahPowerfulBestFive;

  /// No description provided for @duahSituationAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get duahSituationAll;

  /// No description provided for @duahSituationDistress.
  ///
  /// In en, this message translates to:
  /// **'Distress'**
  String get duahSituationDistress;

  /// No description provided for @duahSituationForgiveness.
  ///
  /// In en, this message translates to:
  /// **'Forgiveness'**
  String get duahSituationForgiveness;

  /// No description provided for @duahSituationGuidance.
  ///
  /// In en, this message translates to:
  /// **'Guidance'**
  String get duahSituationGuidance;

  /// No description provided for @duahSituationProvision.
  ///
  /// In en, this message translates to:
  /// **'Provision'**
  String get duahSituationProvision;

  /// No description provided for @duahSituationProtection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get duahSituationProtection;

  /// No description provided for @duahSituationFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get duahSituationFamily;

  /// No description provided for @duahSituationKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge'**
  String get duahSituationKnowledge;

  /// No description provided for @duahCountOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} du\'as of {total}'**
  String duahCountOfTotal(int count, int total);

  /// No description provided for @duahTapToShowPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Tap to show pronunciation'**
  String get duahTapToShowPronunciation;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashboardGreetingEvening;

  /// No description provided for @dashboardSectionPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get dashboardSectionPrayerTimes;

  /// No description provided for @dashboardActionFullPrayerView.
  ///
  /// In en, this message translates to:
  /// **'Full Prayer View'**
  String get dashboardActionFullPrayerView;

  /// No description provided for @dashboardActionQiblaCompass.
  ///
  /// In en, this message translates to:
  /// **'Qibla Compass'**
  String get dashboardActionQiblaCompass;

  /// No description provided for @dashboardSectionDua.
  ///
  /// In en, this message translates to:
  /// **'Du\'a'**
  String get dashboardSectionDua;

  /// No description provided for @dashboardActionDailyDua.
  ///
  /// In en, this message translates to:
  /// **'Daily Du\'a'**
  String get dashboardActionDailyDua;

  /// No description provided for @dashboardActionDailyDuaSub.
  ///
  /// In en, this message translates to:
  /// **'Morning & evening'**
  String get dashboardActionDailyDuaSub;

  /// No description provided for @dashboardActionPowerfulDua.
  ///
  /// In en, this message translates to:
  /// **'Powerful Du\'a'**
  String get dashboardActionPowerfulDua;

  /// No description provided for @dashboardActionPowerfulDuaSub.
  ///
  /// In en, this message translates to:
  /// **'Curated supplications'**
  String get dashboardActionPowerfulDuaSub;

  /// No description provided for @dashboardSectionHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get dashboardSectionHadith;

  /// No description provided for @dashboardContinueReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get dashboardContinueReadingTitle;

  /// No description provided for @dashboardContinueReadingStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start where you left off'**
  String get dashboardContinueReadingStartSubtitle;

  /// No description provided for @dashboardContinueReadingStartDetail.
  ///
  /// In en, this message translates to:
  /// **'Open your recent surah and continue'**
  String get dashboardContinueReadingStartDetail;

  /// No description provided for @dashboardContinueReadingAyahDetail.
  ///
  /// In en, this message translates to:
  /// **'Ayah {ayahNumber} · {surahName}'**
  String dashboardContinueReadingAyahDetail(int ayahNumber, String surahName);

  /// No description provided for @dashboardQuranLabel.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get dashboardQuranLabel;

  /// No description provided for @dashboardContinueLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get dashboardContinueLearningTitle;

  /// No description provided for @dashboardContinueLearningStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get dashboardContinueLearningStartSubtitle;

  /// No description provided for @dashboardContinueLearningStartDetail.
  ///
  /// In en, this message translates to:
  /// **'Open learning tracks'**
  String get dashboardContinueLearningStartDetail;

  /// No description provided for @dashboardContinueLearningModuleDetail.
  ///
  /// In en, this message translates to:
  /// **'{moduleTitle} · {lessonCount} lessons'**
  String dashboardContinueLearningModuleDetail(String moduleTitle, int lessonCount);

  /// No description provided for @dashboardRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dashboardRetry;

  /// No description provided for @dashboardNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get dashboardNextPrayer;

  /// No description provided for @dashboardNextShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get dashboardNextShortLabel;

  /// No description provided for @dashboardPrayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get dashboardPrayerFajr;

  /// No description provided for @dashboardPrayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get dashboardPrayerSunrise;

  /// No description provided for @dashboardPrayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dashboardPrayerDhuhr;

  /// No description provided for @dashboardPrayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get dashboardPrayerAsr;

  /// No description provided for @dashboardPrayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get dashboardPrayerMaghrib;

  /// No description provided for @dashboardPrayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get dashboardPrayerIsha;

  /// No description provided for @dashboardHadithAnNawawiTitle.
  ///
  /// In en, this message translates to:
  /// **'Forty Hadith An-Nawawi'**
  String get dashboardHadithAnNawawiTitle;

  /// No description provided for @dashboardHadithAnNawawiDescription.
  ///
  /// In en, this message translates to:
  /// **'The classical collection by Imam An-Nawawi'**
  String get dashboardHadithAnNawawiDescription;

  /// No description provided for @dashboardHadithShortTitle.
  ///
  /// In en, this message translates to:
  /// **'Forty Short Hadith'**
  String get dashboardHadithShortTitle;

  /// No description provided for @dashboardHadithShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short hadith for easy memorization & practice'**
  String get dashboardHadithShortDescription;

  /// No description provided for @prayerViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Details'**
  String get prayerViewTitle;

  /// No description provided for @prayerViewAppBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guidance for this salah window'**
  String get prayerViewAppBarSubtitle;

  /// No description provided for @prayerViewRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh prayer times'**
  String get prayerViewRefreshTooltip;

  /// No description provided for @prayerViewLanguageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get prayerViewLanguageTooltip;

  /// No description provided for @prayerViewCurrentFocus.
  ///
  /// In en, this message translates to:
  /// **'Current focus'**
  String get prayerViewCurrentFocus;

  /// No description provided for @prayerViewLoadedFromLocation.
  ///
  /// In en, this message translates to:
  /// **'Location time'**
  String get prayerViewLoadedFromLocation;

  /// No description provided for @prayerViewTimeFallback.
  ///
  /// In en, this message translates to:
  /// **'Guide mode'**
  String get prayerViewTimeFallback;

  /// No description provided for @prayerViewHeroNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Time to prepare'**
  String get prayerViewHeroNextLabel;

  /// No description provided for @prayerViewNoTime.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get prayerViewNoTime;

  /// No description provided for @prayerViewPermissionHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer times need location'**
  String get prayerViewPermissionHelpTitle;

  /// No description provided for @prayerViewPermissionHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Enable location permission to calculate local prayer times. The guidance below still stays available.'**
  String get prayerViewPermissionHelpBody;

  /// No description provided for @prayerViewTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prayer Rhythm'**
  String get prayerViewTimelineTitle;

  /// No description provided for @prayerViewTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the full day, spot the next prayer, and keep the current focus visible.'**
  String get prayerViewTimelineSubtitle;

  /// No description provided for @prayerViewNowTitle.
  ///
  /// In en, this message translates to:
  /// **'What to follow now'**
  String get prayerViewNowTitle;

  /// No description provided for @prayerViewNowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A practical next move for the current prayer window.'**
  String get prayerViewNowSubtitle;

  /// No description provided for @prayerViewSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer suggestions'**
  String get prayerViewSuggestionsTitle;

  /// No description provided for @prayerViewSuggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small actions that make this salah feel calmer and more intentional.'**
  String get prayerViewSuggestionsSubtitle;

  /// No description provided for @prayerViewHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How to pray'**
  String get prayerViewHowTitle;

  /// No description provided for @prayerViewHowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A simple flow for the core movements and presence of salah.'**
  String get prayerViewHowSubtitle;

  /// No description provided for @prayerViewBestPracticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Best practices'**
  String get prayerViewBestPracticesTitle;

  /// No description provided for @prayerViewBestPracticesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focused habits tailored to the prayer currently in view.'**
  String get prayerViewBestPracticesSubtitle;

  /// No description provided for @prayerViewFiqhNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice note'**
  String get prayerViewFiqhNoteTitle;

  /// No description provided for @prayerViewFiqhNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Details can vary by madhhab and local teaching. Use this as friendly guidance and follow a trusted scholar or imam for fiqh-specific rulings.'**
  String get prayerViewFiqhNoteBody;

  /// No description provided for @prayerViewFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get prayerViewFocus;

  /// No description provided for @prayerViewNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get prayerViewNext;

  /// No description provided for @prayerViewPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get prayerViewPassed;

  /// No description provided for @prayerViewSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get prayerViewSoon;

  /// No description provided for @prayerHowIntentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Intention & readiness'**
  String get prayerHowIntentionTitle;

  /// No description provided for @prayerHowIntentionBody.
  ///
  /// In en, this message translates to:
  /// **'Make wudu, face the qibla, and settle your intention in the heart before you begin.'**
  String get prayerHowIntentionBody;

  /// No description provided for @prayerHowQiyamTitle.
  ///
  /// In en, this message translates to:
  /// **'Qiyam'**
  String get prayerHowQiyamTitle;

  /// No description provided for @prayerHowQiyamBody.
  ///
  /// In en, this message translates to:
  /// **'Stand calmly, say the opening takbir, recite Al-Fatihah, then recite what is easy from the Quran.'**
  String get prayerHowQiyamBody;

  /// No description provided for @prayerHowRukuTitle.
  ///
  /// In en, this message translates to:
  /// **'Ruku'**
  String get prayerHowRukuTitle;

  /// No description provided for @prayerHowRukuBody.
  ///
  /// In en, this message translates to:
  /// **'Bow with the back settled, glorify Allah, then rise with calm before going down.'**
  String get prayerHowRukuBody;

  /// No description provided for @prayerHowSujoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Sujood'**
  String get prayerHowSujoodTitle;

  /// No description provided for @prayerHowSujoodBody.
  ///
  /// In en, this message translates to:
  /// **'Prostrate with humility, pause without rushing, then sit briefly and complete the second prostration.'**
  String get prayerHowSujoodBody;

  /// No description provided for @prayerHowTashahhudTitle.
  ///
  /// In en, this message translates to:
  /// **'Tashahhud'**
  String get prayerHowTashahhudTitle;

  /// No description provided for @prayerHowTashahhudBody.
  ///
  /// In en, this message translates to:
  /// **'In the final sitting, recite tashahhud and send salawat upon the Prophet, peace be upon him.'**
  String get prayerHowTashahhudBody;

  /// No description provided for @prayerHowSalamTitle.
  ///
  /// In en, this message translates to:
  /// **'Salam'**
  String get prayerHowSalamTitle;

  /// No description provided for @prayerHowSalamBody.
  ///
  /// In en, this message translates to:
  /// **'End the prayer with salam, then remain present for short dhikr and du\'a.'**
  String get prayerHowSalamBody;

  /// No description provided for @prayerFocusFajrTitle.
  ///
  /// In en, this message translates to:
  /// **'Fajr Window'**
  String get prayerFocusFajrTitle;

  /// No description provided for @prayerFocusFajrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Begin the day before the world gets loud.'**
  String get prayerFocusFajrSubtitle;

  /// No description provided for @prayerFocusSunriseTitle.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Pause'**
  String get prayerFocusSunriseTitle;

  /// No description provided for @prayerFocusSunriseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quiet transition after Fajr; wait before optional Duha.'**
  String get prayerFocusSunriseSubtitle;

  /// No description provided for @prayerFocusDhuhrTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr Reset'**
  String get prayerFocusDhuhrTitle;

  /// No description provided for @prayerFocusDhuhrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let the middle of the day become a clean spiritual reset.'**
  String get prayerFocusDhuhrSubtitle;

  /// No description provided for @prayerFocusAsrTitle.
  ///
  /// In en, this message translates to:
  /// **'Asr Guard'**
  String get prayerFocusAsrTitle;

  /// No description provided for @prayerFocusAsrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect the late afternoon before tasks scatter your attention.'**
  String get prayerFocusAsrSubtitle;

  /// No description provided for @prayerFocusMaghribTitle.
  ///
  /// In en, this message translates to:
  /// **'Maghrib Return'**
  String get prayerFocusMaghribTitle;

  /// No description provided for @prayerFocusMaghribSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move quickly from sunset into remembrance and gratitude.'**
  String get prayerFocusMaghribSubtitle;

  /// No description provided for @prayerFocusIshaTitle.
  ///
  /// In en, this message translates to:
  /// **'Isha Closure'**
  String get prayerFocusIshaTitle;

  /// No description provided for @prayerFocusIshaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Close the day with calm, repentance, and preparation for Fajr.'**
  String get prayerFocusIshaSubtitle;

  /// No description provided for @prayerNowFajrTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect the dawn'**
  String get prayerNowFajrTitle;

  /// No description provided for @prayerNowFajrBody.
  ///
  /// In en, this message translates to:
  /// **'Before sunrise, protect the Fajr window. If you have not prayed, make wudu and pray now; if you have, stay with morning adhkar or Quran.'**
  String get prayerNowFajrBody;

  /// No description provided for @prayerNowSunriseTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause and remember'**
  String get prayerNowSunriseTitle;

  /// No description provided for @prayerNowSunriseBody.
  ///
  /// In en, this message translates to:
  /// **'At exact sunrise avoid starting voluntary prayer; keep morning dhikr and wait until the sun has risen before Duha.'**
  String get prayerNowSunriseBody;

  /// No description provided for @prayerNowDhuhrTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the middle of the day'**
  String get prayerNowDhuhrTitle;

  /// No description provided for @prayerNowDhuhrBody.
  ///
  /// In en, this message translates to:
  /// **'Step away from work, renew wudu, and give the fard prayer an unhurried pocket of attention.'**
  String get prayerNowDhuhrBody;

  /// No description provided for @prayerNowAsrTitle.
  ///
  /// In en, this message translates to:
  /// **'Guard the late afternoon'**
  String get prayerNowAsrTitle;

  /// No description provided for @prayerNowAsrBody.
  ///
  /// In en, this message translates to:
  /// **'Make Asr visible before the day becomes crowded. Pray with steady pace and leave a short moment for dhikr afterward.'**
  String get prayerNowAsrBody;

  /// No description provided for @prayerNowMaghribTitle.
  ///
  /// In en, this message translates to:
  /// **'Move promptly'**
  String get prayerNowMaghribTitle;

  /// No description provided for @prayerNowMaghribBody.
  ///
  /// In en, this message translates to:
  /// **'When Maghrib enters, shift quickly from sunset routines into salah, then return to family, food, or travel with a lighter heart.'**
  String get prayerNowMaghribBody;

  /// No description provided for @prayerNowIshaTitle.
  ///
  /// In en, this message translates to:
  /// **'Close the day cleanly'**
  String get prayerNowIshaTitle;

  /// No description provided for @prayerNowIshaBody.
  ///
  /// In en, this message translates to:
  /// **'Pray Isha before sleepiness takes over. Pair it with repentance, gratitude, and a simple plan for waking for Fajr.'**
  String get prayerNowIshaBody;

  /// No description provided for @prayerSuggestionsFajrRaw.
  ///
  /// In en, this message translates to:
  /// **'Pray the two raka\'at Sunnah before the fard when you are able.||Keep the recitation calm and bright, even if it is short.||After salah, spend a few minutes with morning adhkar or a small Quran portion.'**
  String get prayerSuggestionsFajrRaw;

  /// No description provided for @prayerSuggestionsSunriseRaw.
  ///
  /// In en, this message translates to:
  /// **'Continue morning adhkar while the sun rises.||Wait until the disliked sunrise moment passes before optional Duha.||Use the quiet transition to plan the next prayer instead of drifting.'**
  String get prayerSuggestionsSunriseRaw;

  /// No description provided for @prayerSuggestionsDhuhrRaw.
  ///
  /// In en, this message translates to:
  /// **'Use the adhan as a hard pause from work or study.||Choose a quiet place before the day becomes crowded again.||Pair the prayer with a small gratitude check before returning to tasks.'**
  String get prayerSuggestionsDhuhrRaw;

  /// No description provided for @prayerSuggestionsAsrRaw.
  ///
  /// In en, this message translates to:
  /// **'Plan Asr before the late-afternoon rush begins.||Keep the pace steady rather than compressed.||Use one minute after salam to ask Allah for protection and consistency.'**
  String get prayerSuggestionsAsrRaw;

  /// No description provided for @prayerSuggestionsMaghribRaw.
  ///
  /// In en, this message translates to:
  /// **'Pray soon after adhan because the window feels short in daily life.||Keep food, family, and commute transitions from swallowing the prayer.||Follow with evening adhkar when your routine allows.'**
  String get prayerSuggestionsMaghribRaw;

  /// No description provided for @prayerSuggestionsIshaRaw.
  ///
  /// In en, this message translates to:
  /// **'Pray before sleepiness makes focus heavy.||Prepare for Witr according to your practice after Isha.||Set up tomorrow\'s Fajr before bed: alarm, wudu plan, and sleep intention.'**
  String get prayerSuggestionsIshaRaw;

  /// No description provided for @prayerBestPracticesFajrRaw.
  ///
  /// In en, this message translates to:
  /// **'Sleep with Fajr in mind, not as an afterthought.||Avoid rushing the first prayer of the day; let it set the tone.||Use the stillness after Fajr for Quran, adhkar, or one sincere du\'a.'**
  String get prayerBestPracticesFajrRaw;

  /// No description provided for @prayerBestPracticesSunriseRaw.
  ///
  /// In en, this message translates to:
  /// **'Do not treat sunrise as an obligatory prayer; it is a transition marker.||Stay away from voluntary prayer at the exact sunrise moment.||Return to optional worship after the sun has risen and the time is clear.'**
  String get prayerBestPracticesSunriseRaw;

  /// No description provided for @prayerBestPracticesDhuhrRaw.
  ///
  /// In en, this message translates to:
  /// **'Put Dhuhr on the calendar before the workday takes over.||Stand without carrying the whole task list into salah.||If you pray Sunnah prayers, place them around the fard according to your learned practice.'**
  String get prayerBestPracticesDhuhrRaw;

  /// No description provided for @prayerBestPracticesAsrRaw.
  ///
  /// In en, this message translates to:
  /// **'Guard Asr from being pushed to the edge of the time.||Lower the pace before takbir so the prayer does not feel like a race.||Use Asr as an accountability checkpoint for the rest of the day.'**
  String get prayerBestPracticesAsrRaw;

  /// No description provided for @prayerBestPracticesMaghribRaw.
  ///
  /// In en, this message translates to:
  /// **'Respond quickly when Maghrib enters.||Keep sunset meals and gatherings from delaying the prayer.||Let Maghrib open your evening adhkar and family calm.'**
  String get prayerBestPracticesMaghribRaw;

  /// No description provided for @prayerBestPracticesIshaRaw.
  ///
  /// In en, this message translates to:
  /// **'Pray before exhaustion dulls attention.||Keep Witr visible in the night routine according to your practice.||Prepare the body and room for Fajr before sleeping.'**
  String get prayerBestPracticesIshaRaw;

  /// No description provided for @learnQuranTextMapRaw.
  ///
  /// In en, this message translates to:
  /// **''**
  String get learnQuranTextMapRaw;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

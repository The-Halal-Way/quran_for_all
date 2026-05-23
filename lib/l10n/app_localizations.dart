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

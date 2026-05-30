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

  /// No description provided for @homePrayerTab.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get homePrayerTab;

  /// No description provided for @homeQuranTab.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get homeQuranTab;

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

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Personalize your recitation and reading experience.'**
  String get settingsIntro;

  /// No description provided for @settingsReadingPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Preferences'**
  String get settingsReadingPreferencesTitle;

  /// No description provided for @settingsShowPronunciationTitle.
  ///
  /// In en, this message translates to:
  /// **'Show pronunciation'**
  String get settingsShowPronunciationTitle;

  /// No description provided for @settingsShowPronunciationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display transliteration under Arabic ayah.'**
  String get settingsShowPronunciationSubtitle;

  /// No description provided for @settingsShowTranslationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Show translations'**
  String get settingsShowTranslationsTitle;

  /// No description provided for @settingsShowTranslationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display meaning in your selected language.'**
  String get settingsShowTranslationsSubtitle;

  /// No description provided for @settingsLanguagePreferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Language preference'**
  String get settingsLanguagePreferenceLabel;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline mode is enabled'**
  String get settingsOfflineTitle;

  /// No description provided for @settingsOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Quran text, translations, and tafsir are stored locally after setup. Audio is cached after first play.'**
  String get settingsOfflineBody;

  /// No description provided for @splashStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing local Quran database...'**
  String get splashStatusPreparing;

  /// No description provided for @splashStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get splashStatusReady;

  /// No description provided for @splashStatusOfflineFallback.
  ///
  /// In en, this message translates to:
  /// **'Ready with saved Quran data. Some newer content may sync later.'**
  String get splashStatusOfflineFallback;

  /// No description provided for @splashRetrySetup.
  ///
  /// In en, this message translates to:
  /// **'Retry setup'**
  String get splashRetrySetup;

  /// No description provided for @splashSetupFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup needs internet'**
  String get splashSetupFailedTitle;

  /// No description provided for @splashSetupFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Quran For All needs a network connection the first time it prepares the local Quran database. Check your internet connection and try again.'**
  String get splashSetupFailedBody;

  /// No description provided for @splashSetupFailedTip.
  ///
  /// In en, this message translates to:
  /// **'After setup, Quran text, translations, tafsir, bookmarks, and reading progress work from local storage.'**
  String get splashSetupFailedTip;

  /// No description provided for @readQuranTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get readQuranTitle;

  /// No description provided for @readQuranSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quran For All'**
  String get readQuranSubtitle;

  /// No description provided for @readQuranSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get readQuranSearchTooltip;

  /// No description provided for @readQuranBookmarksTooltip.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get readQuranBookmarksTooltip;

  /// No description provided for @readQuranAllSurahsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Surahs'**
  String get readQuranAllSurahsTitle;

  /// No description provided for @readQuranTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get readQuranTotalLabel;

  /// No description provided for @readQuranAyahLabel.
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get readQuranAyahLabel;

  /// No description provided for @readQuranSurahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get readQuranSurahLabel;

  /// No description provided for @readQuranJuzLabel.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get readQuranJuzLabel;

  /// No description provided for @readQuranAyahsLabel.
  ///
  /// In en, this message translates to:
  /// **'ayahs'**
  String get readQuranAyahsLabel;

  /// No description provided for @readQuranSurahsLabel.
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get readQuranSurahsLabel;

  /// No description provided for @readQuranContinueReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get readQuranContinueReadingTitle;

  /// No description provided for @readQuranBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Read. Reflect. Remember.'**
  String get readQuranBannerTitle;

  /// No description provided for @readQuranBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Quran with Bangla and English support.'**
  String get readQuranBannerSubtitle;

  /// No description provided for @readQuranOfflineReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Offline Ready'**
  String get readQuranOfflineReadyLabel;

  /// No description provided for @readQuranBannerSearchButton.
  ///
  /// In en, this message translates to:
  /// **'Search Surah, Ayah, Juz'**
  String get readQuranBannerSearchButton;

  /// No description provided for @readQuranSaveAyahBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save ayah bookmark'**
  String get readQuranSaveAyahBookmarkTooltip;

  /// No description provided for @readQuranRemoveAyahBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove ayah bookmark'**
  String get readQuranRemoveAyahBookmarkTooltip;

  /// No description provided for @readQuranSaveSurahBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save surah bookmark'**
  String get readQuranSaveSurahBookmarkTooltip;

  /// No description provided for @readQuranRemoveSurahBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove surah bookmark'**
  String get readQuranRemoveSurahBookmarkTooltip;

  /// No description provided for @readQuranMarkAyahLastReadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark ayah as last read'**
  String get readQuranMarkAyahLastReadTooltip;

  /// No description provided for @readQuranCurrentLastReadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Current last read ayah'**
  String get readQuranCurrentLastReadTooltip;

  /// No description provided for @readQuranPlayAyahAudioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Play ayah audio'**
  String get readQuranPlayAyahAudioTooltip;

  /// No description provided for @readQuranStopAyahAudioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop ayah audio'**
  String get readQuranStopAyahAudioTooltip;

  /// No description provided for @readQuranReadTafsirTooltip.
  ///
  /// In en, this message translates to:
  /// **'Read tafsir'**
  String get readQuranReadTafsirTooltip;

  /// No description provided for @readQuranTafsirTitle.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get readQuranTafsirTitle;

  /// No description provided for @readQuranNoTafsirBody.
  ///
  /// In en, this message translates to:
  /// **'No tafsir available for this ayah yet.'**
  String get readQuranNoTafsirBody;

  /// No description provided for @readQuranMeccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get readQuranMeccan;

  /// No description provided for @readQuranMedinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get readQuranMedinan;

  /// No description provided for @readQuranCouldNotLoadSurahTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load surah'**
  String get readQuranCouldNotLoadSurahTitle;

  /// No description provided for @readQuranUnablePlayAyahAudio.
  ///
  /// In en, this message translates to:
  /// **'Unable to play this ayah audio right now.'**
  String get readQuranUnablePlayAyahAudio;

  /// No description provided for @readQuranUnablePlayFullSurahAudio.
  ///
  /// In en, this message translates to:
  /// **'Unable to play full surah audio right now.'**
  String get readQuranUnablePlayFullSurahAudio;

  /// No description provided for @readQuranAudioPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required for audio controls.'**
  String get readQuranAudioPermissionRequired;

  /// No description provided for @readQuranGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to settings'**
  String get readQuranGoToSettings;

  /// No description provided for @readQuranExpandCard.
  ///
  /// In en, this message translates to:
  /// **'Expand card'**
  String get readQuranExpandCard;

  /// No description provided for @readQuranShrinkCard.
  ///
  /// In en, this message translates to:
  /// **'Shrink card'**
  String get readQuranShrinkCard;

  /// No description provided for @readQuranReadingOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading options'**
  String get readQuranReadingOptionsTitle;

  /// No description provided for @readQuranReadingOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation and translation visibility'**
  String get readQuranReadingOptionsSubtitle;

  /// No description provided for @readQuranReadingModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reading mode'**
  String get readQuranReadingModeLabel;

  /// No description provided for @readQuranDetailsMode.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get readQuranDetailsMode;

  /// No description provided for @readQuranRegularMode.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get readQuranRegularMode;

  /// No description provided for @readQuranDetailsView.
  ///
  /// In en, this message translates to:
  /// **'Details view'**
  String get readQuranDetailsView;

  /// No description provided for @readQuranRegularView.
  ///
  /// In en, this message translates to:
  /// **'Regular view'**
  String get readQuranRegularView;

  /// No description provided for @readQuranPlayFullSurah.
  ///
  /// In en, this message translates to:
  /// **'Play Full Surah'**
  String get readQuranPlayFullSurah;

  /// No description provided for @readQuranStopSurahAudio.
  ///
  /// In en, this message translates to:
  /// **'Stop Surah Audio'**
  String get readQuranStopSurahAudio;

  /// No description provided for @readQuranSearchInsideSurahTitle.
  ///
  /// In en, this message translates to:
  /// **'Search inside this surah'**
  String get readQuranSearchInsideSurahTitle;

  /// No description provided for @readQuranSearchInsideSurahHint.
  ///
  /// In en, this message translates to:
  /// **'Try ayah number, Arabic text, or translation keyword'**
  String get readQuranSearchInsideSurahHint;

  /// No description provided for @readQuranStartTypingSurahSearch.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search in this surah.'**
  String get readQuranStartTypingSurahSearch;

  /// No description provided for @readQuranSearchAyahsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Ayahs'**
  String get readQuranSearchAyahsTitle;

  /// No description provided for @readQuranSearchAyahsBody.
  ///
  /// In en, this message translates to:
  /// **'Type text or ayah number to jump quickly.'**
  String get readQuranSearchAyahsBody;

  /// No description provided for @readQuranNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get readQuranNoResultsTitle;

  /// No description provided for @readQuranNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword or ayah number.'**
  String get readQuranNoResultsBody;

  /// No description provided for @readQuranResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Results: {count}'**
  String readQuranResultsCount(int count);

  /// No description provided for @readQuranSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Quran'**
  String get readQuranSearchTitle;

  /// No description provided for @readQuranSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Surah, Ayah, or Juz'**
  String get readQuranSearchEmptyTitle;

  /// No description provided for @readQuranSearchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Use query formats like 1:1, para 2, or any Bangla/English keyword.'**
  String get readQuranSearchEmptyBody;

  /// No description provided for @readQuranSearchFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get readQuranSearchFailedTitle;

  /// No description provided for @readQuranSearchNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a shorter keyword or a direct ayah reference.'**
  String get readQuranSearchNoResultsBody;

  /// No description provided for @readQuranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Try: Al-Baqarah, 2:255, para 1, mercy'**
  String get readQuranSearchHint;

  /// No description provided for @readQuranSearchingLabel.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get readQuranSearchingLabel;

  /// No description provided for @readQuranSearchResultsSummary.
  ///
  /// In en, this message translates to:
  /// **'Results: {count} · \"{query}\"'**
  String readQuranSearchResultsSummary(int count, String query);

  /// No description provided for @readQuranCouldNotOpenSearchResult.
  ///
  /// In en, this message translates to:
  /// **'Could not open this result.'**
  String get readQuranCouldNotOpenSearchResult;

  /// No description provided for @readQuranBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get readQuranBookmarksTitle;

  /// No description provided for @readQuranCouldNotLoadBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load bookmarks'**
  String get readQuranCouldNotLoadBookmarksTitle;

  /// No description provided for @readQuranNoBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get readQuranNoBookmarksTitle;

  /// No description provided for @readQuranNoBookmarksBody.
  ///
  /// In en, this message translates to:
  /// **'Save ayah or surah bookmarks to find them quickly later.'**
  String get readQuranNoBookmarksBody;

  /// No description provided for @readQuranCouldNotOpenBookmark.
  ///
  /// In en, this message translates to:
  /// **'Could not open this bookmark.'**
  String get readQuranCouldNotOpenBookmark;

  /// No description provided for @readQuranSavedBookmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved bookmark'**
  String get readQuranSavedBookmarkLabel;

  /// No description provided for @readQuranAyahBookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Ayah bookmarked successfully.'**
  String get readQuranAyahBookmarkAdded;

  /// No description provided for @readQuranAyahBookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Ayah bookmark removed.'**
  String get readQuranAyahBookmarkRemoved;

  /// No description provided for @readQuranCouldNotUpdateAyahBookmark.
  ///
  /// In en, this message translates to:
  /// **'Could not update ayah bookmark right now.'**
  String get readQuranCouldNotUpdateAyahBookmark;

  /// No description provided for @readQuranMarkedLastRead.
  ///
  /// In en, this message translates to:
  /// **'Marked as last read.'**
  String get readQuranMarkedLastRead;

  /// No description provided for @readQuranCouldNotMarkLastRead.
  ///
  /// In en, this message translates to:
  /// **'Could not mark this ayah as last read.'**
  String get readQuranCouldNotMarkLastRead;

  /// No description provided for @readQuranVmSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed. Please try again.'**
  String get readQuranVmSearchFailed;

  /// No description provided for @readQuranVmNoSurahSelected.
  ///
  /// In en, this message translates to:
  /// **'No surah selected.'**
  String get readQuranVmNoSurahSelected;

  /// No description provided for @readQuranVmUnableLoadAyahs.
  ///
  /// In en, this message translates to:
  /// **'Unable to load ayahs for this surah.'**
  String get readQuranVmUnableLoadAyahs;

  /// No description provided for @readQuranVmUnableLoadBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Unable to load bookmarks right now.'**
  String get readQuranVmUnableLoadBookmarks;

  /// No description provided for @quranHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quranHubTitle;

  /// No description provided for @quranHubHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'The Book that guides'**
  String get quranHubHeroEyebrow;

  /// No description provided for @quranHubHeroArabic.
  ///
  /// In en, this message translates to:
  /// **'الْقُرْآن'**
  String get quranHubHeroArabic;

  /// No description provided for @quranHubHeroBody.
  ///
  /// In en, this message translates to:
  /// **'A single home for reading, learning, reflecting, and returning to Allah\'s words with a calmer heart.'**
  String get quranHubHeroBody;

  /// No description provided for @quranHubStatOfflineValue.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get quranHubStatOfflineValue;

  /// No description provided for @quranHubStatOfflineLabel.
  ///
  /// In en, this message translates to:
  /// **'Text ready'**
  String get quranHubStatOfflineLabel;

  /// No description provided for @quranHubStatLanguagesValue.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get quranHubStatLanguagesValue;

  /// No description provided for @quranHubStatLanguagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get quranHubStatLanguagesLabel;

  /// No description provided for @quranHubSectionChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your Quran path'**
  String get quranHubSectionChooseTitle;

  /// No description provided for @quranHubSectionChooseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move straight into recitation, or slow down and build stronger Quran skills.'**
  String get quranHubSectionChooseSubtitle;

  /// No description provided for @quranHubReadTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get quranHubReadTitle;

  /// No description provided for @quranHubReadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the mushaf, search ayahs, save bookmarks, and continue from your last read.'**
  String get quranHubReadSubtitle;

  /// No description provided for @quranHubReadAction.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get quranHubReadAction;

  /// No description provided for @quranHubReadFreshStart.
  ///
  /// In en, this message translates to:
  /// **'Begin from any surah'**
  String get quranHubReadFreshStart;

  /// No description provided for @quranHubReadContinueDetail.
  ///
  /// In en, this message translates to:
  /// **'Last read: {surahName}, Ayah {ayahNumber}'**
  String quranHubReadContinueDetail(String surahName, int ayahNumber);

  /// No description provided for @quranHubLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Quran'**
  String get quranHubLearnTitle;

  /// No description provided for @quranHubLearnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build pronunciation, tajweed, word meaning, and salah-ready recitation step by step.'**
  String get quranHubLearnSubtitle;

  /// No description provided for @quranHubLearnAction.
  ///
  /// In en, this message translates to:
  /// **'Start learning'**
  String get quranHubLearnAction;

  /// No description provided for @quranHubLearningFreshStart.
  ///
  /// In en, this message translates to:
  /// **'Begin with the first guided lesson'**
  String get quranHubLearningFreshStart;

  /// No description provided for @quranHubHadithTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith about the Quran'**
  String get quranHubHadithTitle;

  /// No description provided for @quranHubHadithSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short reminders that keep reading and learning connected to reward, mercy, and practice.'**
  String get quranHubHadithSubtitle;

  /// No description provided for @quranHubHadithBestTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn and teach'**
  String get quranHubHadithBestTitle;

  /// No description provided for @quranHubHadithBestBody.
  ///
  /// In en, this message translates to:
  /// **'The Prophet ﷺ taught that the best people are those who learn the Quran and teach it.'**
  String get quranHubHadithBestBody;

  /// No description provided for @quranHubHadithBestSource.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari 5027'**
  String get quranHubHadithBestSource;

  /// No description provided for @quranHubHadithIntercessorTitle.
  ///
  /// In en, this message translates to:
  /// **'A companion on that Day'**
  String get quranHubHadithIntercessorTitle;

  /// No description provided for @quranHubHadithIntercessorBody.
  ///
  /// In en, this message translates to:
  /// **'The Quran will come on the Day of Resurrection as an intercessor for its companions.'**
  String get quranHubHadithIntercessorBody;

  /// No description provided for @quranHubHadithIntercessorSource.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim 804'**
  String get quranHubHadithIntercessorSource;

  /// No description provided for @quranHubHadithEffortTitle.
  ///
  /// In en, this message translates to:
  /// **'Effort is honored'**
  String get quranHubHadithEffortTitle;

  /// No description provided for @quranHubHadithEffortBody.
  ///
  /// In en, this message translates to:
  /// **'The skilled reciter is with noble angels, and the one who recites with difficulty receives two rewards.'**
  String get quranHubHadithEffortBody;

  /// No description provided for @quranHubHadithEffortSource.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari 4937; Sahih Muslim 798'**
  String get quranHubHadithEffortSource;

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

  /// No description provided for @duahCategoryEatingDrinking.
  ///
  /// In en, this message translates to:
  /// **'Eating & Drinking'**
  String get duahCategoryEatingDrinking;

  /// No description provided for @duahCategoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get duahCategoryHome;

  /// No description provided for @duahCategoryWashroom.
  ///
  /// In en, this message translates to:
  /// **'Washroom'**
  String get duahCategoryWashroom;

  /// No description provided for @duahCategorySleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get duahCategorySleep;

  /// No description provided for @duahCategoryDailyDhikr.
  ///
  /// In en, this message translates to:
  /// **'Daily Dhikr'**
  String get duahCategoryDailyDhikr;

  /// No description provided for @duahCategoryWudu.
  ///
  /// In en, this message translates to:
  /// **'Wudū\''**
  String get duahCategoryWudu;

  /// No description provided for @duahCategoryMasjid.
  ///
  /// In en, this message translates to:
  /// **'Masjid'**
  String get duahCategoryMasjid;

  /// No description provided for @duahCategorySneezing.
  ///
  /// In en, this message translates to:
  /// **'Sneezing'**
  String get duahCategorySneezing;

  /// No description provided for @duahCategoryDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get duahCategoryDifficulty;

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

  /// No description provided for @duahNintyNineTitle.
  ///
  /// In en, this message translates to:
  /// **'99 Names'**
  String get duahNintyNineTitle;

  /// No description provided for @duahNintyNineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Asma ul Husna'**
  String get duahNintyNineSubtitle;

  /// No description provided for @duahNintyNineNamesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} names'**
  String duahNintyNineNamesCount(int count);

  /// No description provided for @duahNintyNineCategoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} themes'**
  String duahNintyNineCategoryCount(int count);

  /// No description provided for @duahNintyNineVerseLabel.
  ///
  /// In en, this message translates to:
  /// **'Quran reminder'**
  String get duahNintyNineVerseLabel;

  /// No description provided for @duahNintyNineBenefitTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefit'**
  String get duahNintyNineBenefitTitle;

  /// No description provided for @duahNintyNineConclusionTitle.
  ///
  /// In en, this message translates to:
  /// **'Conclusion'**
  String get duahNintyNineConclusionTitle;

  /// No description provided for @duahNintyNineNamesGridTitle.
  ///
  /// In en, this message translates to:
  /// **'Beautiful Names'**
  String get duahNintyNineNamesGridTitle;

  /// No description provided for @duahNintyNineLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading the beautiful names...'**
  String get duahNintyNineLoading;

  /// No description provided for @duahNintyNineLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the names right now.'**
  String get duahNintyNineLoadError;

  /// No description provided for @duahNintyNineLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again in a moment.'**
  String get duahNintyNineLoadErrorBody;

  /// No description provided for @duahNintyNineRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get duahNintyNineRetry;

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

  /// No description provided for @dashboardActionQiblaCompassSub.
  ///
  /// In en, this message translates to:
  /// **'Find qibla direction'**
  String get dashboardActionQiblaCompassSub;

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

  /// No description provided for @dashboardActionNintyNineNames.
  ///
  /// In en, this message translates to:
  /// **'99 Names'**
  String get dashboardActionNintyNineNames;

  /// No description provided for @dashboardActionNintyNineNamesSub.
  ///
  /// In en, this message translates to:
  /// **'Asma ul Husna'**
  String get dashboardActionNintyNineNamesSub;

  /// No description provided for @dashboardSectionOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get dashboardSectionOthers;

  /// No description provided for @dashboardActionTasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh'**
  String get dashboardActionTasbeeh;

  /// No description provided for @dashboardActionTasbeehSub.
  ///
  /// In en, this message translates to:
  /// **'Counter & dhikr'**
  String get dashboardActionTasbeehSub;

  /// No description provided for @dashboardSectionHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get dashboardSectionHadith;

  /// No description provided for @tasbeehTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh Counter'**
  String get tasbeehTitle;

  /// No description provided for @tasbeehSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Count dhikr with focus'**
  String get tasbeehSubtitle;

  /// No description provided for @tasbeehPhraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhikr'**
  String get tasbeehPhraseTitle;

  /// No description provided for @tasbeehPhraseSubhanAllah.
  ///
  /// In en, this message translates to:
  /// **'SubhanAllah'**
  String get tasbeehPhraseSubhanAllah;

  /// No description provided for @tasbeehPhraseAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get tasbeehPhraseAlhamdulillah;

  /// No description provided for @tasbeehPhraseAllahuAkbar.
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar'**
  String get tasbeehPhraseAllahuAkbar;

  /// No description provided for @tasbeehPhraseLaIlahaIllallah.
  ///
  /// In en, this message translates to:
  /// **'La ilaha illallah'**
  String get tasbeehPhraseLaIlahaIllallah;

  /// No description provided for @tasbeehTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get tasbeehTarget;

  /// No description provided for @tasbeehTargetReached.
  ///
  /// In en, this message translates to:
  /// **'Target reached'**
  String get tasbeehTargetReached;

  /// No description provided for @tasbeehCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get tasbeehCurrent;

  /// No description provided for @tasbeehTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get tasbeehTotal;

  /// No description provided for @tasbeehRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get tasbeehRounds;

  /// No description provided for @tasbeehUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get tasbeehUndo;

  /// No description provided for @tasbeehReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tasbeehReset;

  /// No description provided for @tasbeehResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get tasbeehResetAll;

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

  /// No description provided for @dashboardPrayerSehri.
  ///
  /// In en, this message translates to:
  /// **'Sehri'**
  String get dashboardPrayerSehri;

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

  /// No description provided for @prayerViewSehriLast.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get prayerViewSehriLast;

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

  /// No description provided for @prayerTimesPermissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission needed'**
  String get prayerTimesPermissionDeniedTitle;

  /// No description provided for @prayerTimesPermissionDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to calculate prayer times for your area. You can still use the guidance sections without live times.'**
  String get prayerTimesPermissionDeniedBody;

  /// No description provided for @prayerTimesPermissionDeniedForeverTitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked'**
  String get prayerTimesPermissionDeniedForeverTitle;

  /// No description provided for @prayerTimesPermissionDeniedForeverBody.
  ///
  /// In en, this message translates to:
  /// **'Open app settings and allow location access, then refresh prayer times.'**
  String get prayerTimesPermissionDeniedForeverBody;

  /// No description provided for @prayerTimesLocationDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Location services are off'**
  String get prayerTimesLocationDisabledTitle;

  /// No description provided for @prayerTimesLocationDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on device location services, then refresh to calculate local prayer times.'**
  String get prayerTimesLocationDisabledBody;

  /// No description provided for @prayerTimesNetworkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare prayer times'**
  String get prayerTimesNetworkErrorTitle;

  /// No description provided for @prayerTimesNetworkErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and device location settings, then try again.'**
  String get prayerTimesNetworkErrorBody;

  /// No description provided for @compassTitle.
  ///
  /// In en, this message translates to:
  /// **'Compass'**
  String get compassTitle;

  /// No description provided for @compassInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing compass...'**
  String get compassInitializing;

  /// No description provided for @compassRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get compassRetry;

  /// No description provided for @compassNativeActive.
  ///
  /// In en, this message translates to:
  /// **'Native compass active'**
  String get compassNativeActive;

  /// No description provided for @compassHeadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get compassHeadingLabel;

  /// No description provided for @compassQiblaOffsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Qibla offset'**
  String get compassQiblaOffsetLabel;

  /// No description provided for @compassAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get compassAccuracyLabel;

  /// No description provided for @compassNotAvailableShort.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get compassNotAvailableShort;

  /// No description provided for @compassApiAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get compassApiAccuracyLabel;

  /// No description provided for @compassNativeAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'±2°'**
  String get compassNativeAccuracyLabel;

  /// No description provided for @compassFacingMeccaLabel.
  ///
  /// In en, this message translates to:
  /// **'Facing Mecca!'**
  String get compassFacingMeccaLabel;

  /// No description provided for @compassRotateToAlignLabel.
  ///
  /// In en, this message translates to:
  /// **'Rotate to align'**
  String get compassRotateToAlignLabel;

  /// No description provided for @compassApiFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Compass sensor unavailable'**
  String get compassApiFallbackTitle;

  /// No description provided for @compassApiFallbackBody.
  ///
  /// In en, this message translates to:
  /// **'Your device does not expose a native compass sensor. We can calculate the Qibla angle from your location, but live rotation needs a compass-capable device.'**
  String get compassApiFallbackBody;

  /// No description provided for @compassApiFallbackQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla angle: {degrees}°'**
  String compassApiFallbackQibla(String degrees);

  /// No description provided for @compassLocationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission needed'**
  String get compassLocationDeniedTitle;

  /// No description provided for @compassLocationDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Allow location access so Qibla can be calculated from your current position.'**
  String get compassLocationDeniedBody;

  /// No description provided for @compassLocationBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked'**
  String get compassLocationBlockedTitle;

  /// No description provided for @compassLocationBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Open app settings and allow location access, then retry the Qibla compass.'**
  String get compassLocationBlockedBody;

  /// No description provided for @compassLocationDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Location services are off'**
  String get compassLocationDisabledTitle;

  /// No description provided for @compassLocationDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on device location services, then retry the Qibla compass.'**
  String get compassLocationDisabledBody;

  /// No description provided for @compassGenericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Compass could not start'**
  String get compassGenericErrorTitle;

  /// No description provided for @compassGenericErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check location permission, sensor availability, and your connection, then try again.'**
  String get compassGenericErrorBody;

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

  /// No description provided for @prayerForbiddenTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Forbidden Times'**
  String get prayerForbiddenTimesTitle;

  /// No description provided for @prayerForbiddenTimesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short windows where starting voluntary salah should be avoided.'**
  String get prayerForbiddenTimesSubtitle;

  /// No description provided for @prayerForbiddenAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause voluntary prayer here'**
  String get prayerForbiddenAlertTitle;

  /// No description provided for @prayerForbiddenAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Keep dhikr, Quran listening, or quiet reflection, then pray again once the window clears. Fiqh details can vary, so follow a trusted scholar for specific rulings.'**
  String get prayerForbiddenAlertBody;

  /// No description provided for @prayerForbiddenPauseLabel.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get prayerForbiddenPauseLabel;

  /// No description provided for @prayerForbiddenSunriseTitle.
  ///
  /// In en, this message translates to:
  /// **'At sunrise'**
  String get prayerForbiddenSunriseTitle;

  /// No description provided for @prayerForbiddenSunriseBody.
  ///
  /// In en, this message translates to:
  /// **'Avoid beginning voluntary prayer while the sun is rising; wait until it has clearly risen.'**
  String get prayerForbiddenSunriseBody;

  /// No description provided for @prayerForbiddenZenithTitle.
  ///
  /// In en, this message translates to:
  /// **'At zenith'**
  String get prayerForbiddenZenithTitle;

  /// No description provided for @prayerForbiddenZenithBody.
  ///
  /// In en, this message translates to:
  /// **'Pause optional salah when the sun is at its highest point, just before Dhuhr enters.'**
  String get prayerForbiddenZenithBody;

  /// No description provided for @prayerForbiddenSunsetTitle.
  ///
  /// In en, this message translates to:
  /// **'At sunset'**
  String get prayerForbiddenSunsetTitle;

  /// No description provided for @prayerForbiddenSunsetBody.
  ///
  /// In en, this message translates to:
  /// **'Avoid starting voluntary prayer as the sun is setting; pray Maghrib when its time begins.'**
  String get prayerForbiddenSunsetBody;

  /// No description provided for @prayerForbiddenTimeFallback.
  ///
  /// In en, this message translates to:
  /// **'Time unavailable'**
  String get prayerForbiddenTimeFallback;

  /// No description provided for @prayerForbiddenAroundTime.
  ///
  /// In en, this message translates to:
  /// **'Around {time}'**
  String prayerForbiddenAroundTime(String time);

  /// No description provided for @prayerForbiddenBeforeTime.
  ///
  /// In en, this message translates to:
  /// **'Before {time}'**
  String prayerForbiddenBeforeTime(String time);

  /// No description provided for @prayerReferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Guidance Library'**
  String get prayerReferenceTitle;

  /// No description provided for @prayerReferenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the details only when you need them, so the main prayer view stays calm.'**
  String get prayerReferenceSubtitle;

  /// No description provided for @prayerReferenceMovementsActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Salah Movement Guide'**
  String get prayerReferenceMovementsActionTitle;

  /// No description provided for @prayerReferenceMovementsActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See every position with Arabic recitation, pronunciation, and meaning.'**
  String get prayerReferenceMovementsActionSubtitle;

  /// No description provided for @prayerReferenceForbiddenActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Forbidden Times'**
  String get prayerReferenceForbiddenActionTitle;

  /// No description provided for @prayerReferenceForbiddenActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Know when to pause voluntary salah.'**
  String get prayerReferenceForbiddenActionSubtitle;

  /// No description provided for @prayerReferenceNafalActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Nafal Prayers'**
  String get prayerReferenceNafalActionTitle;

  /// No description provided for @prayerReferenceNafalActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud, Ishraq, Duha, and Awwabin in one daily flow.'**
  String get prayerReferenceNafalActionSubtitle;

  /// No description provided for @prayerReferenceJanazaActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Janaja Prayer'**
  String get prayerReferenceJanazaActionTitle;

  /// No description provided for @prayerReferenceJanazaActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A standing mercy prayer with four takbirs and sincere du\'a.'**
  String get prayerReferenceJanazaActionSubtitle;

  /// No description provided for @prayerReferenceTasbeehActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Salatul Tasbeeh'**
  String get prayerReferenceTasbeehActionTitle;

  /// No description provided for @prayerReferenceTasbeehActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the 300-tasbih rhythm across four rak\'ahs.'**
  String get prayerReferenceTasbeehActionSubtitle;

  /// No description provided for @prayerReferenceOpenLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get prayerReferenceOpenLabel;

  /// No description provided for @prayerMovementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Salah Movement Guide'**
  String get prayerMovementsTitle;

  /// No description provided for @prayerMovementsHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Prayer in motion'**
  String get prayerMovementsHeroEyebrow;

  /// No description provided for @prayerMovementsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Pray with clarity, calm, and meaning'**
  String get prayerMovementsHeroTitle;

  /// No description provided for @prayerMovementsHeroBody.
  ///
  /// In en, this message translates to:
  /// **'A visual walkthrough from takbir to dhikr, pairing each posture with the Arabic words, pronunciation, and translation.'**
  String get prayerMovementsHeroBody;

  /// No description provided for @prayerMovementsHeroStepsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} positions'**
  String prayerMovementsHeroStepsCount(int count);

  /// No description provided for @prayerMovementsHeroArabicLabel.
  ///
  /// In en, this message translates to:
  /// **'Arabic + meaning'**
  String get prayerMovementsHeroArabicLabel;

  /// No description provided for @prayerMovementsHeroHadithLabel.
  ///
  /// In en, this message translates to:
  /// **'Hadith notes'**
  String get prayerMovementsHeroHadithLabel;

  /// No description provided for @prayerMovementsSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Movement sequence'**
  String get prayerMovementsSequenceTitle;

  /// No description provided for @prayerMovementsSequenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the flow from opening takbir to post-prayer dhikr, one settled posture at a time.'**
  String get prayerMovementsSequenceSubtitle;

  /// No description provided for @prayerMovementsArabicLabel.
  ///
  /// In en, this message translates to:
  /// **'Arabic to recite'**
  String get prayerMovementsArabicLabel;

  /// No description provided for @prayerMovementsPronunciationLabel.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation'**
  String get prayerMovementsPronunciationLabel;

  /// No description provided for @prayerMovementsTranslationLabel.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get prayerMovementsTranslationLabel;

  /// No description provided for @prayerMovementsNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Practice note'**
  String get prayerMovementsNoteLabel;

  /// No description provided for @prayerMovementsHadithTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith anchors'**
  String get prayerMovementsHadithTitle;

  /// No description provided for @prayerMovementsHadithSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short reminders that keep the demonstration rooted in sunnah, calmness, and presence.'**
  String get prayerMovementsHadithSubtitle;

  /// No description provided for @prayerMovementsHadithSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get prayerMovementsHadithSourceLabel;

  /// No description provided for @prayerMovementsFiqhNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Respectful variation note'**
  String get prayerMovementsFiqhNoteTitle;

  /// No description provided for @prayerMovementsFiqhNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Hand placement, finger movement, and some wordings can vary by madhhab and teacher. Use this as a friendly demonstration and follow trusted local guidance for rulings.'**
  String get prayerMovementsFiqhNoteBody;

  /// No description provided for @prayerNafalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Nafal Prayers'**
  String get prayerNafalTitle;

  /// No description provided for @prayerNafalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A graceful optional-prayer rhythm for morning, daylight, evening, and night.'**
  String get prayerNafalSubtitle;

  /// No description provided for @prayerNafalArabicLabel.
  ///
  /// In en, this message translates to:
  /// **'نفل'**
  String get prayerNafalArabicLabel;

  /// No description provided for @prayerNafalDailyFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily flow'**
  String get prayerNafalDailyFlowLabel;

  /// No description provided for @prayerNafalFlexibleLabel.
  ///
  /// In en, this message translates to:
  /// **'Flexible raka\'ahs'**
  String get prayerNafalFlexibleLabel;

  /// No description provided for @prayerNafalTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get prayerNafalTimeLabel;

  /// No description provided for @prayerNafalRakahLabel.
  ///
  /// In en, this message translates to:
  /// **'Raka\'ahs'**
  String get prayerNafalRakahLabel;

  /// No description provided for @prayerNafalBenefitLabel.
  ///
  /// In en, this message translates to:
  /// **'Benefit'**
  String get prayerNafalBenefitLabel;

  /// No description provided for @prayerNafalHadithReferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Hadith references'**
  String get prayerNafalHadithReferencesLabel;

  /// No description provided for @prayerNafalNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle fiqh note'**
  String get prayerNafalNoteTitle;

  /// No description provided for @prayerNafalNoteBody.
  ///
  /// In en, this message translates to:
  /// **'These are friendly reminders for common nafal windows. Details and rakah counts may vary by madhhab and teacher, so follow trusted local guidance for rulings.'**
  String get prayerNafalNoteBody;

  /// No description provided for @prayerNafalTahajjudTitle.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get prayerNafalTahajjudTitle;

  /// No description provided for @prayerNafalTahajjudBadge.
  ///
  /// In en, this message translates to:
  /// **'Deep night'**
  String get prayerNafalTahajjudBadge;

  /// No description provided for @prayerNafalTahajjudTime.
  ///
  /// In en, this message translates to:
  /// **'Last third of the night before Fajr'**
  String get prayerNafalTahajjudTime;

  /// No description provided for @prayerNafalTahajjudRakah.
  ///
  /// In en, this message translates to:
  /// **'2+'**
  String get prayerNafalTahajjudRakah;

  /// No description provided for @prayerNafalTahajjudBenefit.
  ///
  /// In en, this message translates to:
  /// **'Turns the quiet night into du\'a, repentance, and deeper focus.'**
  String get prayerNafalTahajjudBenefit;

  /// No description provided for @prayerNafalTahajjudBody.
  ///
  /// In en, this message translates to:
  /// **'Wake gently, pray in pairs, and keep the recitation calm. Even two focused raka\'ahs can become the quietest anchor of the day.'**
  String get prayerNafalTahajjudBody;

  /// No description provided for @prayerNafalTahajjudHadith1Source.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim 1163a'**
  String get prayerNafalTahajjudHadith1Source;

  /// No description provided for @prayerNafalTahajjudHadith1Body.
  ///
  /// In en, this message translates to:
  /// **'The best prayer after the obligatory prayer is night prayer.'**
  String get prayerNafalTahajjudHadith1Body;

  /// No description provided for @prayerNafalIshraqTitle.
  ///
  /// In en, this message translates to:
  /// **'Ishraq'**
  String get prayerNafalIshraqTitle;

  /// No description provided for @prayerNafalIshraqBadge.
  ///
  /// In en, this message translates to:
  /// **'After sunrise'**
  String get prayerNafalIshraqBadge;

  /// No description provided for @prayerNafalIshraqTime.
  ///
  /// In en, this message translates to:
  /// **'After sunrise has clearly passed'**
  String get prayerNafalIshraqTime;

  /// No description provided for @prayerNafalIshraqRakah.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get prayerNafalIshraqRakah;

  /// No description provided for @prayerNafalIshraqBenefit.
  ///
  /// In en, this message translates to:
  /// **'Connects Fajr, dhikr, and a hopeful start to the morning.'**
  String get prayerNafalIshraqBenefit;

  /// No description provided for @prayerNafalIshraqBody.
  ///
  /// In en, this message translates to:
  /// **'Wait until the forbidden sunrise window clears, then begin with a light heart and a short, sincere prayer.'**
  String get prayerNafalIshraqBody;

  /// No description provided for @prayerNafalIshraqHadith1Source.
  ///
  /// In en, this message translates to:
  /// **'Jami\' at-Tirmidhi 586'**
  String get prayerNafalIshraqHadith1Source;

  /// No description provided for @prayerNafalIshraqHadith1Body.
  ///
  /// In en, this message translates to:
  /// **'Fajr in congregation, dhikr until sunrise, then two raka\'ahs is reported with Hajj and Umrah reward.'**
  String get prayerNafalIshraqHadith1Body;

  /// No description provided for @prayerNafalDuhaTitle.
  ///
  /// In en, this message translates to:
  /// **'Duha / Chasht'**
  String get prayerNafalDuhaTitle;

  /// No description provided for @prayerNafalDuhaBadge.
  ///
  /// In en, this message translates to:
  /// **'Bright morning'**
  String get prayerNafalDuhaBadge;

  /// No description provided for @prayerNafalDuhaTime.
  ///
  /// In en, this message translates to:
  /// **'Mid-morning until before Dhuhr'**
  String get prayerNafalDuhaTime;

  /// No description provided for @prayerNafalDuhaRakah.
  ///
  /// In en, this message translates to:
  /// **'2-8'**
  String get prayerNafalDuhaRakah;

  /// No description provided for @prayerNafalDuhaBenefit.
  ///
  /// In en, this message translates to:
  /// **'Refreshes gratitude and covers the morning charity due from the body.'**
  String get prayerNafalDuhaBenefit;

  /// No description provided for @prayerNafalDuhaBody.
  ///
  /// In en, this message translates to:
  /// **'Use the morning stretch for gratitude, provision, and renewed energy before the day gets heavy.'**
  String get prayerNafalDuhaBody;

  /// No description provided for @prayerNafalDuhaHadith1Source.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim 720'**
  String get prayerNafalDuhaHadith1Source;

  /// No description provided for @prayerNafalDuhaHadith1Body.
  ///
  /// In en, this message translates to:
  /// **'Two raka\'ahs of Duha suffice for the morning charity due from every joint.'**
  String get prayerNafalDuhaHadith1Body;

  /// No description provided for @prayerNafalDuhaHadith2Source.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari 1178; Sahih Muslim 721a'**
  String get prayerNafalDuhaHadith2Source;

  /// No description provided for @prayerNafalDuhaHadith2Body.
  ///
  /// In en, this message translates to:
  /// **'Abu Hurayrah was advised to keep Duha among regular acts.'**
  String get prayerNafalDuhaHadith2Body;

  /// No description provided for @prayerNafalAwwabinTitle.
  ///
  /// In en, this message translates to:
  /// **'Awwabin'**
  String get prayerNafalAwwabinTitle;

  /// No description provided for @prayerNafalAwwabinBadge.
  ///
  /// In en, this message translates to:
  /// **'Evening return'**
  String get prayerNafalAwwabinBadge;

  /// No description provided for @prayerNafalAwwabinTime.
  ///
  /// In en, this message translates to:
  /// **'After Maghrib sunnah, before Isha'**
  String get prayerNafalAwwabinTime;

  /// No description provided for @prayerNafalAwwabinRakah.
  ///
  /// In en, this message translates to:
  /// **'2-6'**
  String get prayerNafalAwwabinRakah;

  /// No description provided for @prayerNafalAwwabinBenefit.
  ///
  /// In en, this message translates to:
  /// **'Keeps the Maghrib-Isha window alive with short extra raka\'ahs and dhikr.'**
  String get prayerNafalAwwabinBenefit;

  /// No description provided for @prayerNafalAwwabinBody.
  ///
  /// In en, this message translates to:
  /// **'Let the evening soften: return to Allah with short raka\'ahs, dhikr, and a quieter transition toward Isha.'**
  String get prayerNafalAwwabinBody;

  /// No description provided for @prayerNafalAwwabinHadith1Source.
  ///
  /// In en, this message translates to:
  /// **'Jami\' at-Tirmidhi 435; Sunan Ibn Majah 1167'**
  String get prayerNafalAwwabinHadith1Source;

  /// No description provided for @prayerNafalAwwabinHadith1Body.
  ///
  /// In en, this message translates to:
  /// **'Six raka\'ahs after Maghrib are reported; scholars discuss the report\'s strength.'**
  String get prayerNafalAwwabinHadith1Body;

  /// No description provided for @prayerNafalAwwabinHadith2Source.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim 748b'**
  String get prayerNafalAwwabinHadith2Source;

  /// No description provided for @prayerNafalAwwabinHadith2Body.
  ///
  /// In en, this message translates to:
  /// **'The name Salat al-Awwabin is also authentically used for the Duha-time prayer.'**
  String get prayerNafalAwwabinHadith2Body;

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

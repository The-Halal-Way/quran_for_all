import 'package:flutter/widgets.dart';

import 'l10n_extensions.dart';

class ReadQuranMessageKeys {
  const ReadQuranMessageKeys._();

  static const String searchFailedTryAgain = 'read_search_failed_try_again';
  static const String noSurahSelected = 'read_no_surah_selected';
  static const String unableLoadAyahs = 'read_unable_load_ayahs';
  static const String unableLoadBookmarks = 'read_unable_load_bookmarks';
}

String localizeReadQuranMessage(BuildContext context, String key) {
  switch (key) {
    case ReadQuranMessageKeys.searchFailedTryAgain:
      return context.readQuranText('Search failed. Please try again.');
    case ReadQuranMessageKeys.noSurahSelected:
      return context.readQuranText('No surah selected.');
    case ReadQuranMessageKeys.unableLoadAyahs:
      return context.readQuranText('Unable to load ayahs for this surah.');
    case ReadQuranMessageKeys.unableLoadBookmarks:
      return context.readQuranText('Unable to load bookmarks right now.');
    default:
      return context.readQuranText(key);
  }
}

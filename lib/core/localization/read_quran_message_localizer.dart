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
      return context.l10n.readQuranVmSearchFailed;
    case ReadQuranMessageKeys.noSurahSelected:
      return context.l10n.readQuranVmNoSurahSelected;
    case ReadQuranMessageKeys.unableLoadAyahs:
      return context.l10n.readQuranVmUnableLoadAyahs;
    case ReadQuranMessageKeys.unableLoadBookmarks:
      return context.l10n.readQuranVmUnableLoadBookmarks;
    default:
      return context.readQuranText(key);
  }
}

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class QuizLanguage {
  const QuizLanguage._();

  /// Content languages can grow independently of translated app chrome.
  static Locale uiLocale(String language) {
    final code = language.split(RegExp('[-_]')).first;
    return AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => const Locale('en'),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';

import '../enums/app_language.dart';

class LearnQuranTextLocalizer {
  const LearnQuranTextLocalizer._();

  static String _cachedLocale = '';
  static Map<String, String> _cachedMap = const <String, String>{};

  static String translate(BuildContext context, String text) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || text.isEmpty) {
      return text;
    }

    final locale = Localizations.localeOf(context).toLanguageTag();
    _seed(localeTag: locale, mapRaw: l10n.learnQuranTextMapRaw);

    return translateRaw(text);
  }

  static void seedFromLocalizations(AppLocalizations l10n, Locale locale) {
    _seed(localeTag: locale.toLanguageTag(), mapRaw: l10n.learnQuranTextMapRaw);
  }

  static String translateRaw(String text) {
    if (text.isEmpty) {
      return text;
    }

    return _cachedMap[text] ?? text;
  }

  static void _seed({required String localeTag, required String mapRaw}) {
    if (_cachedLocale == localeTag) {
      return;
    }

    _cachedLocale = localeTag;
    _cachedMap = _parseMap(mapRaw);
  }

  static Map<String, String> _parseMap(String rawMap) {
    if (rawMap.trim().isEmpty) {
      return const <String, String>{};
    }

    final map = <String, String>{};
    for (final entry in rawMap.split('||')) {
      final separatorIndex = entry.indexOf('=');
      if (separatorIndex <= 0) {
        continue;
      }

      final key = entry.substring(0, separatorIndex).trim();
      final value = entry.substring(separatorIndex + 1).trim();

      if (key.isNotEmpty) {
        map[key] = value;
      }
    }

    return map;
  }
}

extension L10nBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String appLanguageLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return l10n.languageEnglish;
      case AppLanguage.bangla:
        return l10n.languageBangla;
    }
  }

  String learnText(String text) =>
      LearnQuranTextLocalizer.translate(this, text);
}

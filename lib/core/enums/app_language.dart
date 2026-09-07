import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Languages come from generated ARB locales, so a new translation file also
/// becomes a selectable, persistable app language.
@immutable
class AppLanguage {
  const AppLanguage(this.code);

  static const english = AppLanguage('en');
  static const bangla = AppLanguage('bn');

  final String code;

  static List<AppLanguage> get values => List.unmodifiable([
    english,
    ...AppLocalizations.supportedLocales
        .map((locale) => AppLanguage(locale.toLanguageTag()))
        .where((language) => language != english),
  ]);

  Locale get locale => AppLocalizations.supportedLocales.firstWhere(
    (locale) => locale.toLanguageTag() == code,
    orElse: () => const Locale('en'),
  );

  String get label => lookupAppLocalizations(locale).languageNativeName;

  @override
  bool operator ==(Object other) => other is AppLanguage && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

extension AppLanguageX on AppLanguage {
  static AppLanguage fromCode(String? code) => AppLanguage.values.firstWhere(
    (language) => language.code == code?.replaceAll('_', '-'),
    orElse: () => AppLanguage.english,
  );
}

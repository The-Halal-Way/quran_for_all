enum AppLanguage { english, bangla }

extension AppLanguageX on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.bangla:
        return 'bn';
    }
  }

  String get label {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.bangla:
        return 'Bangla';
    }
  }

  static AppLanguage fromCode(String? code) {
    switch (code) {
      case 'bn':
        return AppLanguage.bangla;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }
}

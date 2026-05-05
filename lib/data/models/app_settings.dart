import '../../core/enums/app_language.dart';

class AppSettings {
  const AppSettings({
    required this.showPronunciation,
    required this.showTranslation,
    required this.language,
  });

  final bool showPronunciation;
  final bool showTranslation;
  final AppLanguage language;

  factory AppSettings.defaults() {
    return const AppSettings(
      showPronunciation: true,
      showTranslation: true,
      language: AppLanguage.english,
    );
  }

  AppSettings copyWith({
    bool? showPronunciation,
    bool? showTranslation,
    AppLanguage? language,
  }) {
    return AppSettings(
      showPronunciation: showPronunciation ?? this.showPronunciation,
      showTranslation: showTranslation ?? this.showTranslation,
      language: language ?? this.language,
    );
  }

  factory AppSettings.fromMap(Map<String, Object?> map) {
    return AppSettings(
      showPronunciation: (map['show_pronunciation'] as bool?) ?? true,
      showTranslation: (map['show_translation'] as bool?) ?? true,
      language: AppLanguageX.fromCode(map['language'] as String?),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'show_pronunciation': showPronunciation,
      'show_translation': showTranslation,
      'language': language.code,
    };
  }
}

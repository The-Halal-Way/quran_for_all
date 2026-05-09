import 'package:flutter/material.dart';

import '../../core/enums/app_language.dart';

class AppSettings {
  const AppSettings({
    required this.showPronunciation,
    required this.showTranslation,
    required this.language,
    required this.themeMode,
  });

  final bool showPronunciation;
  final bool showTranslation;
  final AppLanguage language;
  final ThemeMode themeMode;

  factory AppSettings.defaults() {
    return const AppSettings(
      showPronunciation: true,
      showTranslation: true,
      language: AppLanguage.english,
      themeMode: ThemeMode.system,
    );
  }

  AppSettings copyWith({
    bool? showPronunciation,
    bool? showTranslation,
    AppLanguage? language,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      showPronunciation: showPronunciation ?? this.showPronunciation,
      showTranslation: showTranslation ?? this.showTranslation,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  factory AppSettings.fromMap(Map<String, Object?> map) {
    return AppSettings(
      showPronunciation: (map['show_pronunciation'] as bool?) ?? true,
      showTranslation: (map['show_translation'] as bool?) ?? true,
      language: AppLanguageX.fromCode(map['language'] as String?),
      themeMode: _themeModeFromString(map['theme_mode'] as String?),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'show_pronunciation': showPronunciation,
      'show_translation': showTranslation,
      'language': language.code,
      'theme_mode': themeMode.name,
    };
  }

  static ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

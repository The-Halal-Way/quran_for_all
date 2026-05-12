import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/enums/reading_view_mode.dart';
import '../../data/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../core/enums/app_language.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _keyShowPronunciation = 'show_pronunciation';
  static const _keyShowTranslation = 'show_translation';
  static const _keyReadingViewMode = 'reading_view_mode';
  static const _keyLanguage = 'app_language';
  static const _keyThemeMode = 'theme_mode';

  @override
  Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      showPronunciation: prefs.getBool(_keyShowPronunciation) ?? true,
      showTranslation: prefs.getBool(_keyShowTranslation) ?? true,
      readingViewMode: ReadingViewModeX.fromCode(
        prefs.getString(_keyReadingViewMode),
      ),
      language: AppLanguageX.fromCode(prefs.getString(_keyLanguage)),
      themeMode: _themeModeFromString(prefs.getString(_keyThemeMode)),
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyShowPronunciation, settings.showPronunciation);
    await prefs.setBool(_keyShowTranslation, settings.showTranslation);
    await prefs.setString(_keyReadingViewMode, settings.readingViewMode.code);
    await prefs.setString(_keyLanguage, settings.language.code);
    await prefs.setString(_keyThemeMode, settings.themeMode.name);
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

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../core/enums/app_language.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _keyShowPronunciation = 'show_pronunciation';
  static const _keyShowTranslation = 'show_translation';
  static const _keyLanguage = 'app_language';

  @override
  Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      showPronunciation: prefs.getBool(_keyShowPronunciation) ?? true,
      showTranslation: prefs.getBool(_keyShowTranslation) ?? true,
      language: AppLanguageX.fromCode(prefs.getString(_keyLanguage)),
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyShowPronunciation, settings.showPronunciation);
    await prefs.setBool(_keyShowTranslation, settings.showTranslation);
    await prefs.setString(_keyLanguage, settings.language.code);
  }
}

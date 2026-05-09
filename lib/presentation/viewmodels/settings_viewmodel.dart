import 'package:flutter/material.dart';

import '../../core/enums/app_language.dart';
import '../../data/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._settingsRepository) {
    loadSettings();
  }

  final SettingsRepository _settingsRepository;

  bool _isLoading = true;
  AppSettings _settings = AppSettings.defaults();

  bool get isLoading => _isLoading;
  AppSettings get settings => _settings;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _settingsRepository.getSettings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setShowPronunciation(bool value) async {
    _settings = _settings.copyWith(showPronunciation: value);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }

  Future<void> setShowTranslation(bool value) async {
    _settings = _settings.copyWith(showTranslation: value);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }

  Future<void> setLanguage(AppLanguage language) async {
    _settings = _settings.copyWith(language: language);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();
    await _settingsRepository.saveSettings(_settings);
  }
}

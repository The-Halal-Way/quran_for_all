import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/prayer_times/prayer_home_widget_bridge.dart';
import '../../../domain/entities/prayer_times/prayer_times_models.dart';

class PrayerTimesPreferencesStore {
  static const _keyActiveProfileSignature = 'prayer_times_active_profile';
  static const _keyMethod = 'prayer_times_method';
  static const _keyMadhab = 'prayer_times_madhab';
  static const _keyAdjustments = 'prayer_times_adjustments';
  static const _keyLatitudeAdjustment = 'prayer_times_latitude_adjustment';
  static const _keyMidnightMode = 'prayer_times_midnight_mode';
  static const _keyParamsVersion = 'prayer_times_params_version';
  static const _keyShafaq = 'prayer_times_shafaq';

  Future<String?> getActiveProfileSignature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveProfileSignature);
  }

  Future<void> setActiveProfileSignature(String signature) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveProfileSignature, signature);
  }

  Future<PrayerCalculationConfig> getCalculationConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return PrayerCalculationConfig(
      method: PrayerCalculationMethod.fromName(prefs.getString(_keyMethod)),
      madhab: PrayerMadhab.fromName(prefs.getString(_keyMadhab)),
      adjustments: PrayerAdjustments.fromTuneString(
        prefs.getString(_keyAdjustments),
      ),
      latitudeAdjustmentMethod: PrayerLatitudeAdjustmentMethod.fromName(
        prefs.getString(_keyLatitudeAdjustment),
      ),
      midnightMode: PrayerMidnightMode.fromName(
        prefs.getString(_keyMidnightMode),
      ),
      paramsVersion: prefs.getInt(_keyParamsVersion) ?? 1,
      shafaq: prefs.getString(_keyShafaq) ?? 'general',
    );
  }

  Future<void> writeWidgetSnapshot(PrayerWidgetSnapshot snapshot) async {
    await PrayerHomeWidgetBridge.saveSnapshot(snapshot.toJsonString());
  }

  Future<PrayerWidgetSnapshot?> readWidgetSnapshot() async {
    final raw = await PrayerHomeWidgetBridge.readSnapshot();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return PrayerWidgetSnapshot.fromJsonString(raw);
  }
}

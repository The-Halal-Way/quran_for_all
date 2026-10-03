import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/prayer_times/prayer_home_widget_bridge.dart';
import '../../../core/prayer_times/prayer_widget_calendar.dart';
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

  Future<void> saveCalculationConfig(PrayerCalculationConfig config) async {
    final previous = await getCalculationConfig();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMethod, config.method.name);
    await prefs.setString(_keyMadhab, config.madhab.name);
    await prefs.setString(_keyAdjustments, config.adjustments.apiTuneString);
    await prefs.setString(
      _keyLatitudeAdjustment,
      config.latitudeAdjustmentMethod.name,
    );
    await prefs.setString(_keyMidnightMode, config.midnightMode.name);
    await prefs.setInt(_keyParamsVersion, config.paramsVersion);
    await prefs.setString(_keyShafaq, config.shafaq);
    if (previous.signatureSeed() != config.signatureSeed()) {
      // The existing widget snapshot belongs to another calculation profile.
      // Native widgets show their empty state until fresh times are fetched.
      await PrayerHomeWidgetBridge.saveSnapshot('');
    }
  }

  Future<void> writeWidgetSnapshot(PrayerWidgetSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    final decorated = PrayerWidgetCalendar.decorate(
      snapshot,
      adjustmentDays: prefs.getInt('hijri_date_adjustment') ?? 0,
    );
    await PrayerHomeWidgetBridge.saveSnapshot(decorated.toJsonString());
  }

  Future<void> refreshWidgetCalendar() async {
    final snapshot = await readWidgetSnapshot();
    if (snapshot != null) {
      await writeWidgetSnapshot(snapshot);
    }
  }

  Future<PrayerWidgetSnapshot?> readWidgetSnapshot() async {
    final raw = await PrayerHomeWidgetBridge.readSnapshot();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return PrayerWidgetSnapshot.fromJsonString(raw);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}

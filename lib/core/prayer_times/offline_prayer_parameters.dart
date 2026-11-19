import 'package:adhan_dart/adhan_dart.dart' as adhan;

import '../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../services/hijri_calendar_service.dart';

/// One explicit mapping for every method exposed by the existing settings UI.
class OfflinePrayerParameters {
  const OfflinePrayerParameters._();

  static adhan.CalculationParameters forDate(
    PrayerCalculationConfig config,
    DateTime date,
  ) {
    final params = switch (config.method) {
      PrayerCalculationMethod.karachi =>
        adhan.CalculationMethodParameters.karachi(),
      PrayerCalculationMethod.islamicSocietyOfNorthAmerica =>
        adhan.CalculationMethodParameters.northAmerica(),
      PrayerCalculationMethod.muslimWorldLeague =>
        adhan.CalculationMethodParameters.muslimWorldLeague(),
      PrayerCalculationMethod.ummAlQura =>
        adhan.CalculationMethodParameters.ummAlQura(),
      PrayerCalculationMethod.egyptian =>
        adhan.CalculationMethodParameters.egyptian(),
      PrayerCalculationMethod.gulf =>
        adhan.CalculationMethodParameters.gulfRegion(),
      PrayerCalculationMethod.kuwait =>
        adhan.CalculationMethodParameters.kuwait(),
      PrayerCalculationMethod.qatar =>
        adhan.CalculationMethodParameters.qatar(),
      PrayerCalculationMethod.singapore =>
        adhan.CalculationMethodParameters.singapore(),
      PrayerCalculationMethod.turkey =>
        adhan.CalculationMethodParameters.turkiye(),
      PrayerCalculationMethod.moonsightingCommittee =>
        adhan.CalculationMethodParameters.moonsightingCommittee(),
      // JAKIM is a separate setting, not an alias for Singapore's rounding.
      // https://api.aladhan.com/v1/methods: Fajr 20°, Isha 18°.
      PrayerCalculationMethod.malaysia => adhan.CalculationParameters(
        method: adhan.CalculationMethod.other,
        fajrAngle: 20,
        ishaAngle: 18,
        methodAdjustments: {adhan.Prayer.dhuhr: 1},
      ),
      PrayerCalculationMethod.indonesia =>
        adhan.CalculationMethodParameters.indonesian(),
    };
    params.madhab = config.madhab == PrayerMadhab.hanafi
        ? adhan.Madhab.hanafi
        : adhan.Madhab.shafi;
    params.highLatitudeRule = switch (config.latitudeAdjustmentMethod) {
      PrayerLatitudeAdjustmentMethod.middleOfNight =>
        adhan.HighLatitudeRule.middleOfTheNight,
      PrayerLatitudeAdjustmentMethod.oneSeventh =>
        adhan.HighLatitudeRule.seventhOfTheNight,
      PrayerLatitudeAdjustmentMethod.angleBased =>
        adhan.HighLatitudeRule.twilightAngle,
    };
    params.shafaq = switch (config.shafaq) {
      'ahmer' => adhan.Shafaq.ahmer,
      'abyad' => adhan.Shafaq.abyad,
      _ => adhan.Shafaq.general,
    };
    final a = config.adjustments;
    params.adjustments = {
      adhan.Prayer.fajr: a.fajr,
      adhan.Prayer.sunrise: a.sunrise,
      adhan.Prayer.dhuhr: a.dhuhr,
      adhan.Prayer.asr: a.asr,
      adhan.Prayer.maghrib: a.maghrib,
      adhan.Prayer.isha: a.isha,
    };
    if (config.method == PrayerCalculationMethod.ummAlQura &&
        const HijriCalendarService().fromGregorian(date).month == 9) {
      params.ishaInterval = 120;
    }
    return params;
  }
}

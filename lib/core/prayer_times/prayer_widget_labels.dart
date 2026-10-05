import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Text sent with the prayer snapshot so native home widgets can follow the
/// language selected inside the Flutter app.
class PrayerWidgetLabels {
  const PrayerWidgetLabels({
    required this.localeIdentifier,
    required this.appTitle,
    required this.hijriDatePlaceholder,
    required this.prayerTimes,
    required this.sehriEnd,
    required this.iftar,
    required this.openToSync,
    required this.tapToUpdate,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  static const english = PrayerWidgetLabels(
    localeIdentifier: 'en_US',
    appTitle: 'Muslim & Quran Pro',
    hijriDatePlaceholder: 'Hijri date',
    prayerTimes: 'PRAYER TIMES',
    sehriEnd: 'SEHRI END',
    iftar: 'IFTAR',
    openToSync: "Open the app to update today's times",
    tapToUpdate: 'Tap to update',
    fajr: 'Fajr',
    sunrise: 'Sunrise',
    dhuhr: 'Dhuhr',
    asr: 'Asr',
    maghrib: 'Maghrib',
    isha: 'Isha',
  );

  final String localeIdentifier;
  final String appTitle;
  final String hijriDatePlaceholder;
  final String prayerTimes;
  final String sehriEnd;
  final String iftar;
  final String openToSync;
  final String tapToUpdate;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  static PrayerWidgetLabels forLocale(String? locale) {
    final appLocale = locale?.toLowerCase().startsWith('bn') == true
        ? const Locale('bn')
        : const Locale('en');
    final l10n = lookupAppLocalizations(appLocale);
    return PrayerWidgetLabels(
      localeIdentifier: appLocale.languageCode == 'bn' ? 'bn_BD' : 'en_US',
      appTitle: l10n.prayerWidgetTitle,
      hijriDatePlaceholder: l10n.prayerWidgetHijriPlaceholder,
      prayerTimes: l10n.prayerWidgetSchedule,
      sehriEnd: l10n.prayerWidgetSehriEnd,
      iftar: l10n.prayerWidgetIftar,
      openToSync: l10n.prayerWidgetOpenToSync,
      tapToUpdate: l10n.prayerWidgetTapToUpdate,
      fajr: l10n.prayerWidgetFajr,
      sunrise: l10n.prayerWidgetSunrise,
      dhuhr: l10n.prayerWidgetDhuhr,
      asr: l10n.prayerWidgetAsr,
      maghrib: l10n.prayerWidgetMaghrib,
      isha: l10n.prayerWidgetIsha,
    );
  }

  Map<String, String> toJson() {
    return {
      'localeIdentifier': localeIdentifier,
      'appTitle': appTitle,
      'hijriDatePlaceholder': hijriDatePlaceholder,
      'prayerTimes': prayerTimes,
      'sehriEnd': sehriEnd,
      'iftar': iftar,
      'openToSync': openToSync,
      'tapToUpdate': tapToUpdate,
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }

  factory PrayerWidgetLabels.fromJson(Map<String, Object?>? json) {
    if (json == null) return english;

    final fallback = forLocale(json['localeIdentifier'] as String?);
    String value(String key, String defaultValue) {
      final candidate = json[key];
      return candidate is String && candidate.isNotEmpty
          ? candidate
          : defaultValue;
    }

    return PrayerWidgetLabels(
      localeIdentifier: value('localeIdentifier', fallback.localeIdentifier),
      appTitle: value('appTitle', fallback.appTitle),
      hijriDatePlaceholder: value(
        'hijriDatePlaceholder',
        fallback.hijriDatePlaceholder,
      ),
      prayerTimes: value('prayerTimes', fallback.prayerTimes),
      sehriEnd: value('sehriEnd', fallback.sehriEnd),
      iftar: value('iftar', fallback.iftar),
      openToSync: value('openToSync', fallback.openToSync),
      tapToUpdate: value('tapToUpdate', fallback.tapToUpdate),
      fajr: value('fajr', fallback.fajr),
      sunrise: value('sunrise', fallback.sunrise),
      dhuhr: value('dhuhr', fallback.dhuhr),
      asr: value('asr', fallback.asr),
      maghrib: value('maghrib', fallback.maghrib),
      isha: value('isha', fallback.isha),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class PrayerVisuals {
  const PrayerVisuals._();

  static IconData iconFor(PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerKey.sunrise:
        return Icons.wb_sunny_rounded;
      case PrayerKey.dhuhr:
        return Icons.light_mode_rounded;
      case PrayerKey.asr:
        return Icons.cloud_rounded;
      case PrayerKey.maghrib:
        return Icons.nights_stay_rounded;
      case PrayerKey.isha:
        return Icons.bedtime_rounded;
    }
  }

  static Color accentFor(PrayerKey prayer) {
    switch (prayer) {
      case PrayerKey.fajr:
        return const Color(0xFF64FFDA);
      case PrayerKey.sunrise:
        return const Color(0xFFFFC857);
      case PrayerKey.dhuhr:
        return const Color(0xFF448AFF);
      case PrayerKey.asr:
        return const Color(0xFF00BFA5);
      case PrayerKey.maghrib:
        return const Color(0xFFFF4081);
      case PrayerKey.isha:
        return const Color(0xFFB388FF);
    }
  }
}

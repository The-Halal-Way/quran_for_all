enum PrayerKey { fajr, sunrise, dhuhr, asr, maghrib, isha }

extension PrayerKeyX on PrayerKey {
  String get scheduleKey {
    switch (this) {
      case PrayerKey.fajr:
        return 'Fajr';
      case PrayerKey.sunrise:
        return 'Sunrise';
      case PrayerKey.dhuhr:
        return 'Dhuhr';
      case PrayerKey.asr:
        return 'Asr';
      case PrayerKey.maghrib:
        return 'Maghrib';
      case PrayerKey.isha:
        return 'Isha';
    }
  }

  bool get isPrayer => this != PrayerKey.sunrise;
}

class PrayerTimelineItem {
  const PrayerTimelineItem({
    required this.prayer,
    required this.name,
    required this.time,
    required this.isNext,
    required this.isFocus,
    required this.isPassed,
  });

  final PrayerKey prayer;
  final String name;
  final String time;
  final bool isNext;
  final bool isFocus;
  final bool isPassed;
}

class PrayerGuidanceItem {
  const PrayerGuidanceItem({required this.title, required this.body});

  final String title;
  final String body;
}

class PrayerFocusContent {
  const PrayerFocusContent({
    required this.prayer,
    required this.title,
    required this.subtitle,
    required this.now,
    required this.suggestions,
    required this.bestPractices,
  });

  final PrayerKey prayer;
  final String title;
  final String subtitle;
  final PrayerGuidanceItem now;
  final List<String> suggestions;
  final List<String> bestPractices;
}

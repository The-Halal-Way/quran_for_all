enum PrayerKey { fajr, sunrise, dhuhr, asr, maghrib, isha }

enum SpecialPrayerType { janaza, salatulTasbeeh }

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

class PrayerForbiddenTimeItem {
  const PrayerForbiddenTimeItem({
    required this.title,
    required this.timeLabel,
    required this.body,
  });

  final String title;
  final String timeLabel;
  final String body;
}

class PrayerNafalPrayerItem {
  const PrayerNafalPrayerItem({
    required this.title,
    required this.badge,
    required this.timeLabel,
    required this.rakahLabel,
    required this.benefit,
    required this.body,
    required this.hadithReferences,
  });

  final String title;
  final String badge;
  final String timeLabel;
  final String rakahLabel;
  final String benefit;
  final String body;
  final List<PrayerHadithReference> hadithReferences;
}

class PrayerHadithReference {
  const PrayerHadithReference({required this.source, required this.body});

  final String source;
  final String body;
}

class SpecialPrayerContent {
  const SpecialPrayerContent({
    required this.type,
    required this.title,
    required this.heroEyebrow,
    required this.heroArabic,
    required this.heroBody,
    required this.heroBadge,
    required this.quickFactsTitle,
    required this.quickFactsSubtitle,
    required this.guideTitle,
    required this.guideSubtitle,
    required this.sectionCommentLabel,
    required this.hadithTitle,
    required this.hadithSubtitle,
    required this.note,
    required this.facts,
    required this.sections,
    required this.hadithReferences,
  });

  final SpecialPrayerType type;
  final String title;
  final String heroEyebrow;
  final String heroArabic;
  final String heroBody;
  final String heroBadge;
  final String quickFactsTitle;
  final String quickFactsSubtitle;
  final String guideTitle;
  final String guideSubtitle;
  final String sectionCommentLabel;
  final String hadithTitle;
  final String hadithSubtitle;
  final PrayerGuidanceItem note;
  final List<SpecialPrayerFact> facts;
  final List<SpecialPrayerSection> sections;
  final List<PrayerHadithReference> hadithReferences;
}

class SpecialPrayerFact {
  const SpecialPrayerFact({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;
}

class SpecialPrayerSection {
  const SpecialPrayerSection({
    required this.title,
    required this.body,
    required this.comment,
    required this.points,
  });

  final String title;
  final String body;
  final String comment;
  final List<SpecialPrayerPoint> points;
}

class SpecialPrayerPoint {
  const SpecialPrayerPoint({
    required this.title,
    required this.body,
    this.badge,
    this.arabic,
    this.pronunciation,
    this.translation,
  });

  final String title;
  final String body;
  final String? badge;
  final String? arabic;
  final String? pronunciation;
  final String? translation;
}

class PrayerMovementStep {
  const PrayerMovementStep({
    required this.number,
    required this.title,
    required this.badge,
    required this.body,
    required this.imageAsset,
    required this.arabic,
    required this.pronunciation,
    required this.translation,
    required this.note,
  });

  final int number;
  final String title;
  final String badge;
  final String body;
  final String imageAsset;
  final String arabic;
  final String pronunciation;
  final String translation;
  final String note;
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

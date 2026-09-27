class PrayerMovementSeed {
  const PrayerMovementSeed({
    required this.number,
    required this.title,
    required this.titleBn,
    required this.badge,
    required this.badgeBn,
    required this.body,
    required this.bodyBn,
    required this.imageAsset,
    required this.arabic,
    required this.pronunciation,
    required this.pronunciationBn,
    required this.translation,
    required this.translationBn,
    required this.note,
    required this.noteBn,
  });

  final int number;
  final String title;
  final String titleBn;
  final String badge;
  final String badgeBn;
  final String body;
  final String bodyBn;
  final String imageAsset;
  final String arabic;
  final String pronunciation;
  final String pronunciationBn;
  final String translation;
  final String translationBn;
  final String note;
  final String noteBn;
}

class PrayerMovementHadithSeed {
  const PrayerMovementHadithSeed({
    required this.source,
    required this.body,
    required this.bodyBn,
  });

  final String source;
  final String body;
  final String bodyBn;
}

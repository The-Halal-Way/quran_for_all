enum SunnahDayPhase { morning, daytime, evening }

enum SunnahDuaKind { sunnah, dua, dhikr, quranAyah }

class SunnahHadithReference {
  const SunnahHadithReference({
    required this.collection,
    required this.reference,
    required this.text,
    this.grade,
  });

  final String collection;
  final String reference;
  final String text;
  final String? grade;
}

/// Localized reading content. No Flutter, navigation, or visual dependencies.
class SunnahDuaContent {
  const SunnahDuaContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.practice,
    required this.source,
    this.phase,
    this.kind = SunnahDuaKind.sunnah,
    this.arabic = '',
    this.pronunciation = '',
    this.translation = '',
    this.benefits = const [],
    this.hadithReferences = const [],
    this.authenticityNotes = '',
    this.tags = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> points;
  final String practice;
  final String source;
  final SunnahDayPhase? phase;
  final SunnahDuaKind kind;
  final String arabic;
  final String pronunciation;
  final String translation;
  final List<String> benefits;
  final List<SunnahHadithReference> hadithReferences;
  final String authenticityNotes;
  final List<String> tags;

  String get searchableText =>
      '$title $subtitle ${points.join(' ')} $practice $source $arabic '
      '$pronunciation $translation ${benefits.join(' ')} '
      '${hadithReferences.map((item) => '${item.collection} ${item.reference} ${item.text} ${item.grade ?? ''}').join(' ')} '
      '$authenticityNotes ${tags.join(' ')}';
}

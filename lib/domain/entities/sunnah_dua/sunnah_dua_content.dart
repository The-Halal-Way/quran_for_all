enum SunnahDayPhase { morning, daytime, evening }

enum SunnahDuaKind { sunnah, dua, dhikr }

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

  String get searchableText =>
      '$title $subtitle ${points.join(' ')} $practice $arabic $pronunciation $translation';
}

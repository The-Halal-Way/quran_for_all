import 'islamic_day_rule.dart';

enum IslamicDayCategory { worship, fasting, season, celebration }

enum IslamicDayFasting { none, recommended, obligatory, prohibited }

class IslamicDayText {
  const IslamicDayText({required this.en, required this.bn});

  final String en;
  final String bn;

  String resolve(String locale) => locale.startsWith('bn') ? bn : en;

  factory IslamicDayText.fromJson(Map<String, dynamic> json) =>
      IslamicDayText(en: json['en'] as String, bn: json['bn'] as String);
}

class IslamicDayAction {
  const IslamicDayAction({
    required this.id,
    required this.text,
    this.fasting = false,
  });

  final String id;
  final IslamicDayText text;
  final bool fasting;

  factory IslamicDayAction.fromJson(Map<String, dynamic> json) =>
      IslamicDayAction(
        id: json['id'] as String,
        text: IslamicDayText.fromJson(json['text'] as Map<String, dynamic>),
        fasting: json['fasting'] as bool? ?? false,
      );
}

class IslamicDayHadith {
  const IslamicDayHadith({
    required this.arabic,
    required this.meaning,
    required this.reference,
    required this.url,
    required this.grade,
  });

  final String arabic;
  final IslamicDayText meaning;
  final String reference;
  final String url;
  final String grade;

  factory IslamicDayHadith.fromJson(Map<String, dynamic> json) =>
      IslamicDayHadith(
        arabic: json['arabic'] as String,
        meaning: IslamicDayText.fromJson(
          json['meaning'] as Map<String, dynamic>,
        ),
        reference: json['reference'] as String,
        url: json['url'] as String,
        grade: json['grade'] as String,
      );
}

class IslamicDay {
  const IslamicDay({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rule,
    required this.priority,
    required this.fasting,
    required this.actions,
    required this.avoid,
    required this.hadith,
    required this.notes,
    this.nonPilgrimOnly = false,
    this.actionLabel,
  });

  final String id;
  final IslamicDayText title;
  final IslamicDayText description;
  final IslamicDayCategory category;
  final IslamicDayRule rule;
  final int priority;
  final IslamicDayFasting fasting;
  final List<IslamicDayAction> actions;
  final List<IslamicDayText> avoid;
  final List<IslamicDayHadith> hadith;
  final List<IslamicDayText> notes;
  final bool nonPilgrimOnly;
  final IslamicDayText? actionLabel;

  factory IslamicDay.fromJson(Map<String, dynamic> json) => IslamicDay(
    id: json['id'] as String,
    title: IslamicDayText.fromJson(json['title'] as Map<String, dynamic>),
    description: IslamicDayText.fromJson(
      json['description'] as Map<String, dynamic>,
    ),
    category: IslamicDayCategory.values.byName(json['category'] as String),
    rule: IslamicDayRule.fromJson(json['rule'] as Map<String, dynamic>),
    priority: json['priority'] as int,
    fasting: IslamicDayFasting.values.byName(
      json['fasting'] as String? ?? 'none',
    ),
    actions: List.unmodifiable(
      (json['actions'] as List).map(
        (entry) => IslamicDayAction.fromJson(entry as Map<String, dynamic>),
      ),
    ),
    avoid: List.unmodifiable(
      (json['avoid'] as List).map(
        (entry) => IslamicDayText.fromJson(entry as Map<String, dynamic>),
      ),
    ),
    hadith: List.unmodifiable(
      (json['hadith'] as List).map(
        (entry) => IslamicDayHadith.fromJson(entry as Map<String, dynamic>),
      ),
    ),
    notes: List.unmodifiable(
      (json['notes'] as List? ?? const []).map(
        (entry) => IslamicDayText.fromJson(entry as Map<String, dynamic>),
      ),
    ),
    nonPilgrimOnly: json['nonPilgrimOnly'] as bool? ?? false,
    actionLabel: json['actionLabel'] == null
        ? null
        : IslamicDayText.fromJson(json['actionLabel'] as Map<String, dynamic>),
  );
}

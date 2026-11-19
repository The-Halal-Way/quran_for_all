import 'dua_text.dart';

class DuaPassage {
  DuaPassage(DuaJson json)
    : arabic = duaString(json['arabic']),
      pronunciation = DuaText(json['pronunciation']),
      meaning = DuaText(json['meaning']),
      label = DuaText(json['label']),
      repetitions = duaRepetitionCount(json['repetitions']),
      occasionIds = duaIds(json['occasionIds']),
      referenceOnly = json['forReferenceOnly'] == true,
      quranReference = duaMap(json['quranReference']),
      sourceUrl = duaString(json['sourceUrl']);

  final String arabic, sourceUrl;
  final DuaText pronunciation, meaning, label;
  final int? repetitions;
  final List<String> occasionIds;
  final bool referenceOnly;
  final DuaJson quranReference;
}

class DuaPractice {
  DuaPractice(DuaJson json)
    : occasions = duaIds(json['occasions']),
      repetitions = duaRepetitionCount(json['repetitionsPerOccasion']),
      countsByOccasion = Map.unmodifiable(
        duaMap(
          json['repetitionsByOccasion'],
        ).map((key, value) => MapEntry(key, duaRepetitionCount(value))),
      ),
      occasionLabels = Map.unmodifiable(
        duaMap(
          json['occasionLabels'],
        ).map((key, value) => MapEntry(key, DuaText(value))),
      ),
      when = DuaText(json['when']);

  final List<String> occasions;
  final int? repetitions;
  final Map<String, int?> countsByOccasion;
  final Map<String, DuaText> occasionLabels;
  final DuaText when;
  int? countFor(String? occasion) => countsByOccasion.containsKey(occasion)
      ? countsByOccasion[occasion]
      : repetitions;

  String? preferredOccasionFor(String? categoryId) {
    if (occasions.contains(categoryId)) return categoryId;
    final candidates = switch (categoryId) {
      'sleep' => ['before_sleep', 'bedtime'],
      'food' => ['before_eating', 'after_eating', 'after_meal'],
      'home' => ['entering_home', 'leaving_home'],
      'mosque' => ['entering_mosque', 'leaving_mosque'],
      _ => const <String>[],
    };
    return candidates.where(occasions.contains).firstOrNull ??
        occasions.firstOrNull;
  }
}

class DuaHadithGrading {
  DuaHadithGrading(DuaJson json)
    : status = duaString(json['status']),
      label = DuaText(json['label']),
      by = DuaText(json['by']),
      attribution = DuaText(json['attribution']),
      url = duaString(json['url']),
      opinions = List.unmodifiable(
        duaObjects(json['opinions']).map(DuaHadithGrading.new),
      );

  final String status, url;
  final DuaText label, by, attribution;
  final List<DuaHadithGrading> opinions;
}

class DuaHadith {
  DuaHadith(DuaJson json)
    : collection = DuaText(json['collection']),
      summary = DuaText(json['summary']),
      grading = DuaHadithGrading(duaMap(json['grading'])),
      reportType = duaString(json['reportType']),
      relation = duaString(json['relation']),
      wordingUrl = duaString(json['wordingUrl']),
      locatorType = duaString(json['locatorType']),
      number = duaString(json['number']),
      url = duaString(json['url']);

  final DuaText collection, summary;
  final DuaHadithGrading grading;
  final String number, url, reportType, relation, wordingUrl, locatorType;
  DuaText get grade => grading.label;
}

int? duaRepetitionCount(Object? value) {
  if (value == null) return null;
  if (value is! int || value < 1) {
    throw const FormatException('Invalid dua repetition count');
  }
  return value;
}

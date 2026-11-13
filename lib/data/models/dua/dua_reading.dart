import 'dua_text.dart';

class DuaPassage {
  DuaPassage(DuaJson json)
    : arabic = duaString(json['arabic']),
      pronunciation = DuaText(json['pronunciation']),
      meaning = DuaText(json['meaning']),
      label = DuaText(json['label']),
      repetitions = json['repetitions'] as int?,
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
      repetitions = json['repetitionsPerOccasion'] as int?,
      countsByOccasion = Map.unmodifiable(
        duaMap(json['repetitionsByOccasion']).cast<String, int>(),
      ),
      when = DuaText(json['when']);

  final List<String> occasions;
  final int? repetitions;
  final Map<String, int> countsByOccasion;
  final DuaText when;
  int? countFor(String? occasion) => countsByOccasion[occasion] ?? repetitions;
}

class DuaHadith {
  DuaHadith(DuaJson json)
    : collection = DuaText(json['collection']),
      summary = DuaText(json['summary']),
      grade = DuaText(duaMap(json['grading'])['label']),
      number = duaString(json['number']),
      url = duaString(json['url']);

  final DuaText collection, summary, grade;
  final String number, url;
}

import '../../../core/utils/dua_search.dart';
import 'dua_reading.dart';
import 'dua_text.dart';

class DuaEntry {
  DuaEntry(DuaJson json)
    : id = duaString(json['id']),
      type = duaString(json['type']),
      title = DuaText(json['title']),
      arabic = duaString(json['arabic']),
      pronunciation = DuaText(json['pronunciation']),
      meaning = DuaText(json['meaning']),
      note = DuaText(json['note']),
      sourceNote = DuaText(json['sourceNote']),
      sourceText = DuaText(json['sourceText']),
      categoryIds = duaIds(json['categoryIds']),
      relatedIds = duaIds(json['relatedEntryIds']),
      categoryTitles = Map.unmodifiable(
        duaMap(
          json['categoryDisplayTitles'],
        ).map((key, value) => MapEntry(key, DuaText(value))),
      ),
      practice = DuaPractice(duaMap(json['practice'])),
      segments = List.unmodifiable(
        duaObjects(json['segments']).map(DuaPassage.new),
      ),
      variants = List.unmodifiable(
        duaObjects(json['variants']).map(DuaPassage.new),
      ),
      referenceVariant = json['referenceVariant'] is Map
          ? DuaPassage(duaMap(json['referenceVariant']))
          : null,
      hadith = List.unmodifiable(
        duaObjects(json['relatedHadith']).map(DuaHadith.new),
      ),
      quranReferences = List.unmodifiable(duaObjects(json['quranReferences'])),
      recitation = Map.unmodifiable(duaMap(json['recitation'])),
      context = Map.unmodifiable(duaMap(json['context'])),
      isDefault = json['showInAppByDefault'] != false,
      searchIndex = DuaSearch.index(json) {
    if (id.isEmpty || title.isEmpty || arabic.isEmpty) {
      throw const FormatException('Dua entry is missing reading content');
    }
  }

  final String id, type, arabic, searchIndex;
  final DuaText title, pronunciation, meaning, note, sourceNote, sourceText;
  final List<String> categoryIds, relatedIds;
  final Map<String, DuaText> categoryTitles;
  final DuaPractice practice;
  final List<DuaPassage> segments, variants;
  final DuaPassage? referenceVariant;
  final List<DuaHadith> hadith;
  final List<DuaJson> quranReferences;
  final DuaJson recitation, context;
  final bool isDefault;

  String titleFor(String language, [String? categoryId]) =>
      (categoryTitles[categoryId] ?? title).inLanguage(language);

  List<DuaPassage> passagesFor(String? occasion) {
    final parts = segments
        .where(
          (part) =>
              !part.referenceOnly &&
              (part.occasionIds.isEmpty || part.occasionIds.contains(occasion)),
        )
        .toList(growable: false);
    return parts.isNotEmpty
        ? parts
        : [
            DuaPassage({
              'arabic': arabic,
              'pronunciation': pronunciation.values,
              'meaning': meaning.values,
            }),
          ];
  }
}

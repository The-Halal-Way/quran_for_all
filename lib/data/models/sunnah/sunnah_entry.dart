import '../../../core/utils/dua_search.dart';
import '../dua/dua_text.dart';
import 'sunnah_references.dart';

class SunnahRecitationStep {
  SunnahRecitationStep(DuaJson json)
    : text = DuaText(json['text']),
      repetitions = _repetitions(json['repetitions']),
      duaEntryId = duaString(json['duaEntryId']);

  final DuaText text;
  final int? repetitions;
  final String duaEntryId;
}

class SunnahEntry {
  SunnahEntry(DuaJson json)
    : id = duaString(json['id']),
      type = duaString(json['type']),
      title = DuaText(json['title']),
      practice = DuaText(json['practice']),
      note = DuaText(json['note']),
      occasion = DuaText(json['occasion']),
      categoryIds = duaIds(json['categoryIds']),
      relatedIds = duaIds(json['relatedEntryIds']),
      duaEntryIds = duaIds(json['duaEntryIds']),
      hadith = List.unmodifiable(
        duaObjects(json['hadith']).map(SunnahHadith.new),
      ),
      repetitions = Map.unmodifiable(
        duaMap(
          json['repetitionsByOccasion'],
        ).map((key, value) => MapEntry(key, _repetitions(value))),
      ),
      steps = List.unmodifiable(duaObjects(json['steps']).map(DuaText.new)),
      recitation = List.unmodifiable(
        duaObjects(json['recitationSequence']).map(SunnahRecitationStep.new),
      ),
      quranReferences = List.unmodifiable(
        duaObjects(json['quranReferences']).map(SunnahQuranReference.new),
      ),
      quranReadingLinks = List.unmodifiable(
        duaObjects(json['quranReadingLinks']).map(SunnahQuranReference.new),
      ),
      searchIndex = DuaSearch.index(json) {
    if (id.isEmpty ||
        type.isEmpty ||
        title.isEmpty ||
        practice.isEmpty ||
        categoryIds.isEmpty ||
        hadith.isEmpty) {
      throw const FormatException('Sunnah entry is missing required content');
    }
  }

  final String id, type, searchIndex;
  final DuaText title, practice, note, occasion;
  final List<String> categoryIds, relatedIds, duaEntryIds;
  final List<SunnahHadith> hadith;
  final Map<String, int?> repetitions;
  final List<DuaText> steps;
  final List<SunnahRecitationStep> recitation;
  final List<SunnahQuranReference> quranReferences, quranReadingLinks;

  /// Includes links attached to individual recitation steps, preserving order.
  List<String> get linkedDuaIds => {
    ...duaEntryIds,
    for (final step in recitation)
      if (step.duaEntryId.isNotEmpty) step.duaEntryId,
  }.toList(growable: false);
}

int? _repetitions(Object? value) {
  if (value == null) return null;
  if (value is! int || value < 1) {
    throw const FormatException('Invalid Sunnah repetition count');
  }
  return value;
}

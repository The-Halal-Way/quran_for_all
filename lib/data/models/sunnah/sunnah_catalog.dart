import '../../../core/utils/dua_search.dart';
import '../dua/dua_text.dart';

export '../dua/dua_text.dart' show DuaText;

class SunnahCategory {
  SunnahCategory(DuaJson json)
    : id = duaString(json['id']),
      title = DuaText(json['title']),
      entryIds = duaIds(json['entryIds']) {
    if (id.isEmpty || title.isEmpty || json['entryCount'] != entryIds.length) {
      throw const FormatException('Invalid Sunnah category');
    }
  }

  final String id;
  final DuaText title;
  final List<String> entryIds;
}

class SunnahCategoryGroup {
  SunnahCategoryGroup(DuaJson json)
    : id = duaString(json['id']),
      title = DuaText(json['title']),
      categoryIds = duaIds(json['categoryIds']);

  final String id;
  final DuaText title;
  final List<String> categoryIds;
}

class SunnahHadith {
  SunnahHadith(DuaJson json)
    : collection = DuaText(json['collection']),
      number = duaString(json['number']),
      url = duaString(json['url']),
      summary = DuaText(json['summary']),
      relation = duaString(json['relation']),
      grading = DuaText(duaMap(json['grading'])['label']),
      gradedBy = DuaText(duaMap(json['grading'])['by']);

  final DuaText collection, summary, grading, gradedBy;
  final String number, url, relation;
}

class SunnahRecitationStep {
  SunnahRecitationStep(DuaJson json)
    : text = DuaText(json['text']),
      repetitions = json['repetitions'] is int
          ? json['repetitions'] as int
          : null,
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
        ).map((key, value) => MapEntry(key, value is int ? value : 0)),
      ),
      steps = List.unmodifiable(
        duaObjects(json['steps']).map((item) => DuaText(item)),
      ),
      recitation = List.unmodifiable(
        duaObjects(json['recitationSequence']).map(SunnahRecitationStep.new),
      ),
      quranReferences = List.unmodifiable(duaObjects(json['quranReferences'])),
      quranReadingLinks = List.unmodifiable(
        duaObjects(json['quranReadingLinks']),
      ),
      searchIndex = DuaSearch.index(json) {
    if (id.isEmpty || type.isEmpty || title.isEmpty || practice.isEmpty) {
      throw const FormatException('Sunnah entry is missing required content');
    }
  }

  final String id, type, searchIndex;
  final DuaText title, practice, note, occasion;
  final List<String> categoryIds, relatedIds, duaEntryIds;
  final List<SunnahHadith> hadith;
  final Map<String, int> repetitions;
  final List<DuaText> steps;
  final List<SunnahRecitationStep> recitation;
  final List<DuaJson> quranReferences, quranReadingLinks;
}

class SunnahCatalog {
  SunnahCatalog.fromJson(DuaJson json)
    : title = DuaText(duaMap(json['feature'])['title']),
      description = DuaText(duaMap(json['feature'])['description']),
      sourceNote = DuaText(duaMap(json['feature'])['sourceNote']),
      allId = duaString(duaMap(json['feature'])['allCategoryId']),
      featuredIds = duaIds(duaMap(json['feature'])['featuredCategoryIds']),
      typeLabels = Map.unmodifiable(
        duaMap(
          duaMap(json['feature'])['typeLabels'],
        ).map((key, value) => MapEntry(key, DuaText(value))),
      ),
      categories = List.unmodifiable(
        duaObjects(json['categories']).map(SunnahCategory.new),
      ),
      groups = List.unmodifiable(
        duaObjects(json['categoryGroups']).map(SunnahCategoryGroup.new),
      ),
      entries = _entries(duaObjects(json['entries'])) {
    if (json['schemaVersion'] != 1 ||
        categories.map((item) => item.id).toSet().length != categories.length ||
        !categories.any((item) => item.id == allId)) {
      throw const FormatException('Unsupported Sunnah catalog');
    }
    final categoryIds = categories.map((item) => item.id).toSet();
    for (final category in categories) {
      if (category.entryIds.toSet().length != category.entryIds.length ||
          category.entryIds.any((id) => !entries.containsKey(id))) {
        throw const FormatException('Invalid Sunnah category membership');
      }
    }
    if (groups.any(
          (group) => group.categoryIds.any((id) => !categoryIds.contains(id)),
        ) ||
        entries.values.any(
          (entry) => entry.categoryIds.any((id) => !categoryIds.contains(id)),
        )) {
      throw const FormatException('Unknown Sunnah category');
    }
  }

  final DuaText title, description, sourceNote;
  final String allId;
  final List<String> featuredIds;
  final Map<String, DuaText> typeLabels;
  final List<SunnahCategory> categories;
  final List<SunnahCategoryGroup> groups;
  final Map<String, SunnahEntry> entries;

  SunnahCategory category(String id) =>
      categories.firstWhere((category) => category.id == id);

  static Map<String, SunnahEntry> _entries(List<DuaJson> items) {
    final result = <String, SunnahEntry>{};
    for (final item in items) {
      final entry = SunnahEntry(item);
      if (result.containsKey(entry.id)) {
        throw const FormatException('Duplicate Sunnah ID');
      }
      result[entry.id] = entry;
    }
    return Map.unmodifiable(result);
  }
}

import 'dua_entry.dart';
import 'dua_text.dart';

export 'dua_entry.dart';
export 'dua_reading.dart';
export 'dua_text.dart';

class DuaCategory {
  DuaCategory(DuaJson json)
    : id = duaString(json['id']),
      title = DuaText(json['title']),
      description = DuaText(json['description']),
      entryIds = duaIds(json['entryIds']),
      referenceIds = duaIds(json['referenceEntryIds']) {
    if (id.isEmpty || title.isEmpty || json['entryCount'] != entryIds.length) {
      throw const FormatException('Invalid dua category');
    }
  }
  final String id;
  final DuaText title, description;
  final List<String> entryIds, referenceIds;
}

class DuaCategoryGroup {
  DuaCategoryGroup(DuaJson json)
    : title = DuaText(json['title']),
      categoryIds = duaIds(json['categoryIds']);
  final DuaText title;
  final List<String> categoryIds;
}

class DuaCatalog {
  DuaCatalog.fromJson(DuaJson json)
    : title = DuaText(duaMap(json['feature'])['title']),
      description = DuaText(duaMap(json['feature'])['description']),
      allId = duaString(duaMap(json['feature'])['allCategoryId']),
      categories = List.unmodifiable(
        duaObjects(json['categories']).map(DuaCategory.new),
      ),
      groups = List.unmodifiable(
        duaObjects(json['categoryGroups']).map(DuaCategoryGroup.new),
      ),
      entries = _entries(duaObjects(json['entries'])),
      guide = Map.unmodifiable(duaMap(json['recitationGuide'])),
      sourceNotes = Map.unmodifiable(duaMap(json['sourceNotes'])) {
    if (json['schemaVersion'] != 2 ||
        categories.map((c) => c.id).toSet().length != categories.length ||
        !categories.any((c) => c.id == allId)) {
      throw const FormatException('Unsupported dua catalog');
    }
    final categoryIds = categories.map((category) => category.id).toSet();
    for (final category in categories) {
      if (category.entryIds.toSet().length != category.entryIds.length ||
          [
            ...category.entryIds,
            ...category.referenceIds,
          ].any((id) => !entries.containsKey(id)) ||
          category.entryIds.any((id) => !entries[id]!.isDefault)) {
        throw const FormatException('Invalid dua category membership');
      }
    }
    if (groups.any(
          (group) => group.categoryIds.any((id) => !categoryIds.contains(id)),
        ) ||
        entries.values.any(
          (entry) => entry.categoryIds.any((id) => !categoryIds.contains(id)),
        )) {
      throw const FormatException('Unknown dua category');
    }
  }

  final DuaText title, description;
  final String allId;
  final List<DuaCategory> categories;
  final List<DuaCategoryGroup> groups;
  final Map<String, DuaEntry> entries;
  final DuaJson guide, sourceNotes;

  DuaCategory category(String id) =>
      categories.firstWhere((category) => category.id == id);

  static Map<String, DuaEntry> _entries(List<DuaJson> items) {
    final result = <String, DuaEntry>{};
    for (final item in items) {
      final entry = DuaEntry(item);
      if (result.containsKey(entry.id)) {
        throw const FormatException('Duplicate dua ID');
      }
      result[entry.id] = entry;
    }
    return Map.unmodifiable(result);
  }
}

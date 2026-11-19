import 'dua_entry.dart';
import 'dua_text.dart';

export 'dua_entry.dart';
export 'dua_benefit.dart';
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
    : id = duaString(json['id']),
      title = DuaText(json['title']),
      categoryIds = duaIds(json['categoryIds']);
  final String id;
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
    final mainIds = entries.values
        .where((entry) => entry.isDefault)
        .map((e) => e.id)
        .toSet();
    final referenceIds = entries.keys.toSet().difference(mainIds);
    final integration = duaMap(json['integration']);
    if (title.isEmpty ||
        entries.isEmpty ||
        (integration['entryCount'] != null &&
            integration['entryCount'] != entries.length) ||
        (integration['defaultEntryCount'] != null &&
            integration['defaultEntryCount'] != mainIds.length) ||
        (integration['referenceEntryCount'] != null &&
            integration['referenceEntryCount'] != referenceIds.length)) {
      throw const FormatException('Invalid dua catalog totals');
    }
    for (final category in categories) {
      if (category.entryIds.toSet().length != category.entryIds.length ||
          category.referenceIds.toSet().length !=
              category.referenceIds.length ||
          [
            ...category.entryIds,
            ...category.referenceIds,
          ].any((id) => !entries.containsKey(id)) ||
          category.entryIds.any((id) => !entries[id]!.isDefault) ||
          category.referenceIds.any((id) => entries[id]!.isDefault)) {
        throw const FormatException('Invalid dua category membership');
      }
      if (category.id != allId &&
          [
            ...category.entryIds,
            ...category.referenceIds,
          ].any((id) => !entries[id]!.categoryIds.contains(category.id))) {
        throw const FormatException('Inconsistent dua category index');
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
    final all = category(allId);
    if (all.entryIds.length != mainIds.length ||
        !all.entryIds.toSet().containsAll(mainIds) ||
        all.referenceIds.length != referenceIds.length ||
        !all.referenceIds.toSet().containsAll(referenceIds)) {
      throw const FormatException('All category must include every dua');
    }
    if (groups.map((group) => group.id).toSet().length != groups.length ||
        groups.any(
          (group) =>
              group.id.isEmpty ||
              group.title.isEmpty ||
              group.categoryIds.toSet().length != group.categoryIds.length,
        ) ||
        !groups
            .expand((group) => group.categoryIds)
            .toSet()
            .containsAll(categoryIds)) {
      throw const FormatException('Invalid dua browse groups');
    }
    for (final entry in entries.values) {
      if (entry.relatedIds.any((id) => !entries.containsKey(id)) ||
          entry.categoryIds.toSet().length != entry.categoryIds.length ||
          entry.categoryIds.any(
            (id) =>
                !(entry.isDefault
                        ? category(id).entryIds
                        : category(id).referenceIds)
                    .contains(entry.id),
          ) ||
          entry.practice.countsByOccasion.keys.any(
            (id) => !entry.practice.occasions.contains(id),
          ) ||
          entry.practice.occasionLabels.keys.any(
            (id) => !entry.practice.occasions.contains(id),
          )) {
        throw const FormatException('Invalid dua entry relationship');
      }
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

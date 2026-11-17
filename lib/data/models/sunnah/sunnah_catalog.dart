import '../dua/dua_text.dart';
import 'sunnah_entry.dart';

export '../dua/dua_text.dart' show DuaText;
export 'sunnah_entry.dart';
export 'sunnah_references.dart';

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
    final integration = duaMap(json['integration']);
    if (title.isEmpty ||
        entries.isEmpty ||
        (integration['entryCount'] != null &&
            integration['entryCount'] != entries.length) ||
        (integration['categoryCount'] != null &&
            integration['categoryCount'] != categories.length)) {
      throw const FormatException('Invalid Sunnah catalog totals');
    }
    for (final category in categories) {
      if (category.entryIds.toSet().length != category.entryIds.length ||
          category.entryIds.any((id) => !entries.containsKey(id))) {
        throw const FormatException('Invalid Sunnah category membership');
      }
      if (category.id != allId &&
          category.entryIds.any(
            (id) => !entries[id]!.categoryIds.contains(category.id),
          )) {
        throw const FormatException('Inconsistent Sunnah category index');
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
    final allIds = category(allId).entryIds.toSet();
    if (allIds.length != entries.length || !allIds.containsAll(entries.keys)) {
      throw const FormatException('All category must include every Sunnah');
    }
    if (featuredIds.any((id) => !categoryIds.contains(id)) ||
        groups.map((group) => group.id).toSet().length != groups.length ||
        groups.any(
          (group) =>
              group.id.isEmpty ||
              group.title.isEmpty ||
              group.categoryIds.toSet().length != group.categoryIds.length,
        ) ||
        !groups
            .expand((group) => group.categoryIds)
            .toSet()
            .containsAll(categoryIds.difference({allId}))) {
      throw const FormatException('Invalid Sunnah browse groups');
    }
    for (final entry in entries.values) {
      if (!typeLabels.containsKey(entry.type) ||
          entry.relatedIds.any((id) => !entries.containsKey(id)) ||
          entry.categoryIds.toSet().length != entry.categoryIds.length ||
          entry.categoryIds.any(
            (id) => !category(id).entryIds.contains(entry.id),
          )) {
        throw const FormatException('Invalid Sunnah entry relationship');
      }
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

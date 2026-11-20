import 'ruqyah_text.dart';
import 'ruqyah_guide.dart';

class RuqyahReadingSummary {
  RuqyahReadingSummary.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      title = RuqyahText(json['title']),
      categories = ruqyahIds(json['categories']),
      pack = json['pack'] as String? ?? 'core',
      surah = json['surah'] as int?,
      verseStart = json['verse_start'] as int?,
      verseEnd = json['verse_end'] as int? {
    if (!{'core', 'extended'}.contains(pack) ||
        (surah != null &&
            (surah! < 1 ||
                surah! > 114 ||
                verseStart == null ||
                verseEnd == null ||
                verseStart! < 1 ||
                verseEnd! < verseStart!))) {
      throw const FormatException('Invalid Ruqyah passage metadata.');
    }
  }

  final String id;
  final RuqyahText title;
  final List<String> categories;
  final String pack;
  final int? surah, verseStart, verseEnd;
}

class RuqyahCollectionSummary {
  RuqyahCollectionSummary.fromJson(RuqyahJson json)
    : verseCount = json['verse_count'] as int,
      surahCount = json['surah_count'] as int,
      passageCount = json['passage_count'] as int {
    if (verseCount < 1 ||
        verseCount > 6236 ||
        surahCount < 1 ||
        surahCount > 114 ||
        passageCount < 1 ||
        passageCount > verseCount) {
      throw const FormatException('Invalid Ruqyah collection totals.');
    }
  }
  final int verseCount, surahCount, passageCount;
}

class RuqyahRoutineSummary {
  RuqyahRoutineSummary.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      title = RuqyahText(json['title']),
      description = RuqyahText(json['description']),
      group = ruqyahString(json['group']),
      guideId = ruqyahString(json['guide_id']),
      collection = json['collection'] == null
          ? null
          : RuqyahCollectionSummary.fromJson(ruqyahObject(json['collection'])),
      reported = json['kind'] == 'reported';

  final String id;
  final String group, guideId;
  final RuqyahText title, description;
  final bool reported;
  final RuqyahCollectionSummary? collection;
}

class RuqyahIndex {
  RuqyahIndex.fromJson(RuqyahJson json) {
    checkRuqyahVersion(json);
    readings = List.unmodifiable(
      ruqyahObjects(json['readings']).map(RuqyahReadingSummary.fromJson),
    );
    routines = List.unmodifiable(
      ruqyahObjects(json['routines']).map(RuqyahRoutineSummary.fromJson),
    );
    guideGroups = List.unmodifiable(
      ruqyahObjects(json['guide_groups']).map(RuqyahGuideGroup.fromJson),
    );
    guides = List.unmodifiable(
      ruqyahObjects(json['guides']).map(RuqyahGuideSummary.fromJson),
    );
    featuredGuideIds = ruqyahIds(json['featured_guide_ids']);
    final groupIds = guideGroups.map((e) => e.id).toSet();
    final guideIds = guides.map((e) => e.id).toSet();
    if (readings.isEmpty ||
        routines.isEmpty ||
        guides.isEmpty ||
        guideGroups.isEmpty ||
        groupIds.length != guideGroups.length ||
        guideIds.length != guides.length ||
        guides.any((g) => !groupIds.contains(g.group)) ||
        featuredGuideIds.toSet().length != featuredGuideIds.length ||
        featuredGuideIds.any((id) => !guideIds.contains(id)) ||
        routines.any(
          (r) =>
              !guideIds.contains(r.guideId) ||
              !{'care', 'daily', 'collections'}.contains(r.group) ||
              ((r.group == 'collections') != (r.collection != null)),
        ) ||
        readings.map((e) => e.id).toSet().length != readings.length ||
        routines.map((e) => e.id).toSet().length != routines.length) {
      throw const FormatException('Empty or duplicate Ruqyah index.');
    }
  }

  late final List<RuqyahReadingSummary> readings;
  late final List<RuqyahRoutineSummary> routines;
  late final List<RuqyahGuideGroup> guideGroups;
  late final List<RuqyahGuideSummary> guides;
  late final List<String> featuredGuideIds;
}

import 'ruqyah_text.dart';
import 'ruqyah_guide.dart';

class RuqyahReadingSummary {
  RuqyahReadingSummary.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      title = RuqyahText(json['title']),
      categories = ruqyahIds(json['categories']);

  final String id;
  final RuqyahText title;
  final List<String> categories;
}

class RuqyahRoutineSummary {
  RuqyahRoutineSummary.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      title = RuqyahText(json['title']),
      description = RuqyahText(json['description']),
      group = ruqyahString(json['group']),
      guideId = ruqyahString(json['guide_id']),
      reported = json['kind'] == 'reported';

  final String id;
  final String group, guideId;
  final RuqyahText title, description;
  final bool reported;
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
              !{'care', 'daily'}.contains(r.group),
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

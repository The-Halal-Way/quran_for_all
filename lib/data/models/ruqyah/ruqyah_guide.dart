import '../../../core/utils/dua_search.dart';
import 'ruqyah_text.dart';

String _basis(Object? value) {
  final basis = ruqyahString(value);
  if (!{
    'prophetic_practice',
    'quran_context',
    'scholarly_guidance',
    'app_guidance',
  }.contains(basis)) {
    throw const FormatException('Unknown Ruqyah evidence classification.');
  }
  return basis;
}

class RuqyahGuideGroup {
  RuqyahGuideGroup.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      title = RuqyahText(json['title']);
  final String id;
  final RuqyahText title;
}

class RuqyahGuideSummary {
  RuqyahGuideSummary.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      group = ruqyahString(json['group']),
      title = RuqyahText(json['title']),
      summary = RuqyahText(json['summary']),
      basis = _basis(json['basis']);
  final String id, group, basis;
  final RuqyahText title, summary;
}

class RuqyahGuideSection {
  RuqyahGuideSection.fromJson(RuqyahJson json)
    : title = ruqyahString(json['title']),
      text = ruqyahString(json['text']),
      points = ruqyahIds(json['points']),
      sources = List.unmodifiable(
        ruqyahObjects(json['sources']).map(RuqyahSource.fromJson),
      );
  final String title, text;
  final List<String> points;
  final List<RuqyahSource> sources;
}

class RuqyahGuide {
  RuqyahGuide.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      group = ruqyahString(json['group']),
      title = ruqyahString(json['title']),
      summary = ruqyahString(json['summary']),
      basis = _basis(json['basis']),
      sections = List.unmodifiable(
        ruqyahObjects(json['sections']).map(RuqyahGuideSection.fromJson),
      ),
      sources = List.unmodifiable(
        ruqyahObjects(json['sources']).map(RuqyahSource.fromJson),
      ),
      readingIds = ruqyahIds(json['reading_ids']),
      routineIds = ruqyahIds(json['routine_ids']) {
    if (sections.isEmpty || sources.isEmpty) {
      throw const FormatException('Incomplete Ruqyah guide.');
    }
    searchIndex = DuaSearch.index([
      title,
      summary,
      for (final section in sections)
        [section.title, section.text, section.points],
      for (final source in sources) [source.label.values, source.url],
    ]);
  }
  final String id, group, title, summary, basis;
  final List<RuqyahGuideSection> sections;
  final List<RuqyahSource> sources;
  final List<String> readingIds, routineIds;
  late final String searchIndex;
}

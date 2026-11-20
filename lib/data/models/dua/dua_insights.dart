import 'dua_reading.dart';
import 'dua_text.dart';

/// Editorial explanations stay distinct from source-backed reported virtues.
/// Optional so older packs and small standalone dua fixtures still render.
class DuaInsights {
  DuaInsights(Object? raw)
    : purpose = DuaText(duaMap(raw)['purpose']),
      significance = DuaText(duaMap(duaMap(raw)['significance'])['text']),
      significanceKind = duaString(duaMap(duaMap(raw)['significance'])['kind']),
      background = DuaText(duaMap(duaMap(raw)['background'])['text']),
      backgroundReferences = List.unmodifiable(
        duaObjects(
          duaMap(duaMap(raw)['background'])['references'],
        ).map(DuaInsightReference.new),
      ),
      reportedVirtues = List.unmodifiable(
        duaObjects(duaMap(raw)['reportedVirtues']).map(DuaReportedVirtue.new),
      ),
      evidenceNote = DuaText(duaMap(raw)['evidenceNote']),
      virtueBasis = duaString(duaMap(raw)['virtueBasis']),
      recommendAsRoutine = duaMap(raw)['showAsRoutineRecommendation'] != false {
    if ((reportedVirtues.isNotEmpty &&
            (virtueBasis != 'specific_reports' || !recommendAsRoutine)) ||
        (!significance.isEmpty &&
            significanceKind != 'reflection_on_meaning')) {
      throw const FormatException('Inconsistent dua insight classification');
    }
  }

  final DuaText purpose, significance, background, evidenceNote;
  final String significanceKind, virtueBasis;
  final bool recommendAsRoutine;
  final List<DuaInsightReference> backgroundReferences;
  final List<DuaReportedVirtue> reportedVirtues;
  bool get hasIntroduction =>
      !purpose.isEmpty || !significance.isEmpty || reportedVirtues.isNotEmpty;
}

class DuaInsightReference {
  DuaInsightReference(DuaJson json)
    : label = DuaText(json['label']),
      url = duaString(json['url']),
      kind = duaString(json['kind']),
      grading = DuaHadithGrading(duaMap(json['grading'])) {
    final uri = Uri.tryParse(url);
    if (label.isEmpty ||
        uri == null ||
        uri.host.isEmpty ||
        !const {'http', 'https'}.contains(uri.scheme)) {
      throw const FormatException('Invalid dua insight source');
    }
  }
  final DuaText label;
  final String url, kind;
  final DuaHadithGrading grading;
}

class DuaReportedVirtue {
  DuaReportedVirtue(DuaJson json)
    : text = DuaText(json['text']),
      references = List.unmodifiable(
        duaObjects(json['references']).map(DuaInsightReference.new),
      ) {
    if (json['kind'] != 'reported_virtue' ||
        text.isEmpty ||
        references.isEmpty) {
      throw const FormatException('A reported dua virtue needs its source');
    }
  }
  final DuaText text;
  final List<DuaInsightReference> references;
}

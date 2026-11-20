import 'ruqyah_index.dart';
import 'ruqyah_text.dart';

class RuqyahStep {
  RuqyahStep.fromJson(RuqyahJson json)
    : id = ruqyahString(json['id']),
      readingId = json['reading_id'] as String?,
      count = json['count'] as int?,
      instruction = json['instruction'] == null
          ? null
          : RuqyahText(json['instruction']),
      countSource = json['count_source'] == null
          ? null
          : RuqyahSource.fromJson(ruqyahObject(json['count_source'])) {
    if ((readingId == null && instruction == null) ||
        (count != null &&
            (count! < 1 ||
                count! > 100 ||
                readingId == null ||
                countSource == null))) {
      throw const FormatException('Invalid Ruqyah practice rule.');
    }
  }

  final String id;
  final String? readingId;
  final int? count;
  final RuqyahText? instruction;
  final RuqyahSource? countSource;
}

class RuqyahRoutine {
  RuqyahRoutine.fromJson(RuqyahJson json, Set<String> readingIds)
    : summary = RuqyahRoutineSummary.fromJson(json),
      cycles = json['cycles'] as int,
      cycleSource = json['cycle_source'] == null
          ? null
          : RuqyahSource.fromJson(ruqyahObject(json['cycle_source'])),
      steps = List.unmodifiable(
        ruqyahObjects(json['steps']).map(RuqyahStep.fromJson),
      ) {
    if (steps.isEmpty ||
        cycles < 1 ||
        cycles > 10 ||
        (cycles > 1 && cycleSource == null) ||
        steps.map((e) => e.id).toSet().length != steps.length ||
        steps.any(
          (e) => e.readingId != null && !readingIds.contains(e.readingId),
        )) {
      throw const FormatException('Invalid Ruqyah routine.');
    }
  }

  final RuqyahRoutineSummary summary;
  final int cycles;
  final List<RuqyahStep> steps;
  final RuqyahSource? cycleSource;
  int get length => cycles * steps.length;
  RuqyahStep stepAt(int index) => steps[index % steps.length];
  int cycleAt(int index) => index ~/ steps.length + 1;
}

import 'ruqyah_index.dart';
import 'ruqyah_text.dart';
import 'ruqyah_reading.dart';

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
      ),
      sources = List.unmodifiable(
        ruqyahObjects(json['sources'] ?? []).map(RuqyahSource.fromJson),
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
  final List<RuqyahSource> sources;
  int get length => cycles * steps.length;
  RuqyahStep stepAt(int index) => steps[index % steps.length];
  int cycleAt(int index) => index ~/ steps.length + 1;

  void validateCollection(Map<String, RuqyahReading> readings) {
    final totals = summary.collection;
    if (totals == null) return;
    final passages = steps.map((s) => readings[s.readingId]).toList();
    final verses = passages.expand((r) => r?.verseIds ?? <int>[]).toList();
    if (sources.isEmpty ||
        cycles != 1 ||
        passages.any(
          (r) => r == null || r.verseIds.isEmpty || r.surahNumber == null,
        ) ||
        steps.any((s) => s.count != null) ||
        steps.length != totals.passageCount ||
        verses.length != totals.verseCount ||
        verses.toSet().length != verses.length ||
        passages.map((r) => r!.surahNumber).toSet().length !=
            totals.surahCount) {
      throw const FormatException(
        'Incomplete or overlapping Ruqyah collection.',
      );
    }
  }
}

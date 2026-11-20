import 'ruqyah_text.dart';

class RuqyahProgress {
  const RuqyahProgress({
    required this.routineId,
    required this.readingIds,
    required this.index,
    required this.counts,
    required this.completed,
    required this.length,
    this.sequence,
  });

  final String? routineId;
  final String? sequence;
  final List<String> readingIds;
  final int index, length;
  final Map<int, int> counts;
  final Set<int> completed;

  static RuqyahProgress? tryParse(Object? raw) {
    try {
      final json = ruqyahObject(raw);
      if (json['version'] != 1) return null;
      final length = json['length'] as int;
      final index = json['index'] as int;
      final routine = json['routine_id'] as String?;
      final ids = ruqyahIds(json['reading_ids']);
      final counts = ruqyahObject(
        json['counts'],
      ).map((key, value) => MapEntry(int.parse(key), value as int));
      final completed = (json['completed'] as List).cast<int>().toSet();
      if (length < 1 ||
          length > 200 ||
          index < 0 ||
          index >= length ||
          (routine == null && ids.isEmpty) ||
          counts.entries.any(
            (e) => e.key < 0 || e.key >= length || e.value < 0 || e.value > 100,
          ) ||
          completed.any((e) => e < 0 || e >= length)) {
        return null;
      }
      return RuqyahProgress(
        routineId: routine,
        readingIds: ids,
        index: index,
        counts: Map.unmodifiable(counts),
        completed: Set.unmodifiable(completed),
        length: length,
        sequence: json['sequence'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  RuqyahJson toJson() => {
    'version': 1,
    'routine_id': routineId,
    'reading_ids': readingIds,
    'index': index,
    'length': length,
    'sequence': sequence,
    'counts': counts.map((key, value) => MapEntry('$key', value)),
    'completed': completed.toList()..sort(),
  };
}

class RuqyahReaderPreferences {
  const RuqyahReaderPreferences({
    this.pronunciation = true,
    this.meaning = true,
    this.fontSize = 28,
  });
  final bool pronunciation, meaning;
  final double fontSize;

  factory RuqyahReaderPreferences.fromJson(Object? raw) {
    if (raw is! Map) return const RuqyahReaderPreferences();
    return RuqyahReaderPreferences(
      pronunciation: raw['pronunciation'] is bool
          ? raw['pronunciation'] as bool
          : true,
      meaning: raw['meaning'] is bool ? raw['meaning'] as bool : true,
      fontSize: raw['font_size'] is num
          ? (raw['font_size'] as num).toDouble().clamp(24, 40)
          : 28,
    );
  }

  Map<String, Object> toJson() => {
    'pronunciation': pronunciation,
    'meaning': meaning,
    'font_size': fontSize,
  };
}

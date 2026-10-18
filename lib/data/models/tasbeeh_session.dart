import '../../domain/entities/tasbeeh/tasbeeh_phrase.dart';

/// Progress shared by legacy saves and individual dhikr sessions.
class TasbeehProgress {
  const TasbeehProgress({
    required this.counts,
    required this.targets,
    this.selectedPhrase,
    this.customPhrases = const [],
    this.autoNext = false,
  });

  final Map<String, int> counts;
  final Map<String, int> targets;
  final String? selectedPhrase;
  final List<TasbeehPhrase> customPhrases;
  final bool autoNext;

  Map<String, dynamic> toMap() => {
    'counts': counts,
    'targets': targets,
    'selectedPhrase': selectedPhrase,
    'customPhrases': customPhrases.map((phrase) => phrase.toMap()).toList(),
    'autoNext': autoNext,
  };

  factory TasbeehProgress.fromMap(Map<String, dynamic> map) => TasbeehProgress(
    counts: _readIntMap(map['counts']),
    targets: _readIntMap(map['targets']),
    selectedPhrase: map['selectedPhrase'] is String
        ? map['selectedPhrase'] as String
        : null,
    customPhrases: _readCustomPhrases(map['customPhrases']),
    autoNext: map['autoNext'] == true,
  );

  static Map<String, int> _readIntMap(Object? value) {
    if (value is! Map<String, dynamic>) return const {};
    return Map.unmodifiable(
      value.map((key, count) {
        final parsed = count is num
            ? count.toInt()
            : int.tryParse('$count') ?? 0;
        return MapEntry(key, parsed);
      }),
    );
  }

  static List<TasbeehPhrase> _readCustomPhrases(Object? value) {
    if (value is! List) return const [];
    return List.unmodifiable([
      for (final entry in value)
        if (entry is Map<String, dynamic>) ?TasbeehPhrase.customFromMap(entry),
    ]);
  }
}

class TasbeehSession {
  const TasbeehSession({
    required this.id,
    required this.name,
    required this.progress,
  });

  static const defaultId = 'default';
  static const maxNameLength = 60;

  final String id;
  final String name;
  final TasbeehProgress progress;

  bool get isDefault => id == defaultId;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'progress': progress.toMap(),
  };

  static TasbeehSession? fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];
    final progress = map['progress'];
    if (id is! String ||
        (id != defaultId && !id.startsWith('session_')) ||
        name is! String ||
        (id != defaultId && name.trim().isEmpty) ||
        name.trim().length > maxNameLength ||
        progress is! Map<String, dynamic>) {
      return null;
    }
    return TasbeehSession(
      id: id,
      name: name.trim(),
      progress: TasbeehProgress.fromMap(progress),
    );
  }
}

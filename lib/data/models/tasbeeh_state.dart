class TasbeehSavedState {
  const TasbeehSavedState({
    required this.counts,
    required this.targets,
    this.selectedPhrase,
  });

  final Map<String, int> counts;
  final Map<String, int> targets;
  final String? selectedPhrase;

  Map<String, dynamic> toMap() => {
    'counts': counts,
    'targets': targets,
    'selectedPhrase': selectedPhrase,
  };

  factory TasbeehSavedState.fromMap(Map<String, dynamic> map) {
    return TasbeehSavedState(
      counts: _readIntMap(map['counts']),
      targets: _readIntMap(map['targets']),
      selectedPhrase: map['selectedPhrase'] as String?,
    );
  }

  static Map<String, int> _readIntMap(Object? value) {
    if (value is! Map<String, dynamic>) return const {};
    return value.map((key, count) {
      final parsed = count is num ? count.toInt() : int.tryParse('$count') ?? 0;
      return MapEntry(key, parsed);
    });
  }
}

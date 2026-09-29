enum TasbeehPhraseKey {
  subhanAllah,
  alhamdulillah,
  allahuAkbar,
  laIlahaIllallah,
}

class TasbeehPhrase {
  const TasbeehPhrase({
    required this.id,
    required this.arabic,
    this.name = '',
    this.meaning = '',
    this.builtInKey,
  });

  static const maxNameLength = 60;
  static const maxTarget = 999999;

  final String id;
  final String name;
  final String arabic;
  final String meaning;
  final TasbeehPhraseKey? builtInKey;

  bool get isBuiltIn => builtInKey != null;

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'arabic': arabic,
    'meaning': meaning,
  };

  static bool validContent(String name, String arabic) =>
      name.trim().isNotEmpty && name.trim().length <= maxNameLength;

  static bool validTarget(int target) => target > 0 && target <= maxTarget;

  static TasbeehPhrase? customFromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];
    final arabic = map['arabic'] ?? '';
    final meaning = map['meaning'] ?? '';
    if (id is! String ||
        !id.startsWith('custom_') ||
        name is! String ||
        arabic is! String ||
        meaning is! String ||
        !validContent(name, arabic)) {
      return null;
    }
    return TasbeehPhrase(
      id: id,
      name: name.trim(),
      arabic: arabic.trim(),
      meaning: meaning.trim(),
    );
  }
}

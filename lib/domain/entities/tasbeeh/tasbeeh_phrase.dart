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
    this.builtInKey,
  });

  static const maxNameLength = 60;
  static const maxArabicLength = 240;
  static const maxTarget = 999999;

  final String id;
  final String name;
  final String arabic;
  final TasbeehPhraseKey? builtInKey;

  bool get isBuiltIn => builtInKey != null;

  Map<String, Object?> toMap() => {'id': id, 'name': name, 'arabic': arabic};

  static bool validContent(String name, String arabic) =>
      name.trim().isNotEmpty &&
      name.trim().length <= maxNameLength &&
      arabic.trim().length <= maxArabicLength;

  static bool validTarget(int target) => target > 0 && target <= maxTarget;

  static TasbeehPhrase? customFromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];
    final arabic = map['arabic'] ?? '';
    if (id is! String ||
        !id.startsWith('custom_') ||
        name is! String ||
        arabic is! String ||
        !validContent(name, arabic)) {
      return null;
    }
    return TasbeehPhrase(id: id, name: name.trim(), arabic: arabic.trim());
  }
}

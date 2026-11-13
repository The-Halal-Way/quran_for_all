/// Arabic marks are ignored without removing Bengali vowel signs.
class DuaSearch {
  const DuaSearch._();

  static String normalize(String value) {
    var result = value
        .toLowerCase()
        .replaceAll(RegExp(r'[\u0640\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
        .replaceAll(RegExp('[أإآٱ]'), 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('’', "'")
        .replaceAll('ʿ', "'")
        .replaceAll('ʾ', "'");
    const folds = {
      'ā': 'a',
      'ī': 'i',
      'ū': 'u',
      'ḥ': 'h',
      'ṣ': 's',
      'ḍ': 'd',
      'ṭ': 't',
      'ẓ': 'z',
    };
    for (final entry in folds.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    const digits = '০১২৩৪৫৬৭৮৯٠١٢٣٤٥٦٧٨٩';
    for (var i = 0; i < digits.length; i++) {
      result = result.replaceAll(digits[i], '${i % 10}');
    }
    return result.trim();
  }

  static String index(Object? value) {
    final buffer = StringBuffer();
    void visit(Object? item) {
      if (item is Map) {
        item.values.forEach(visit);
      } else if (item is List) {
        item.forEach(visit);
      } else if (item is String || item is num) {
        buffer.write('$item ');
      }
    }

    visit(value);
    return normalize(buffer.toString());
  }

  static bool matches(String index, String normalizedQuery) =>
      normalizedQuery.split(RegExp(r'\s+')).every(index.contains);
}

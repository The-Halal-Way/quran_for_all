class StringUtils {
  const StringUtils._();

  static final RegExp _arabicMarks = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u08D3-\u08FF\u0640\u200C-\u200F]',
  );
  static final RegExp _searchTokens = RegExp(
    r'[A-Za-z0-9\u0621-\u063A\u0641-\u064A\u0660-\u0669\u0671-\u06D3\u06FA-\u06FC\u0980-\u09FF]+',
  );

  /// A search-only form of Arabic. The stored and displayed Quran text stays
  /// exactly as supplied by its edition.
  static String normalizeArabicForSearch(String input) {
    return input
        .replaceAll(_arabicMarks, '')
        .replaceAll(RegExp(r'[أإآٱٲٳٵ]'), 'ا')
        .replaceAll(RegExp(r'[ىیېےئ]'), 'ي')
        .replaceAll('ؤ', 'و');
  }

  static String sanitizeFtsQuery(String input) {
    final normalized = normalizeArabicForSearch(input).toLowerCase();
    final tokens = _searchTokens
        .allMatches(normalized)
        .map((match) => match.group(0)!)
        .toList();

    if (tokens.isEmpty) {
      return '';
    }

    return tokens.map((token) => '$token*').join(' ');
  }

  static String compactWhitespace(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}

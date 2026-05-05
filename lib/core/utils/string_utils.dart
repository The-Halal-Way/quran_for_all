class StringUtils {
  const StringUtils._();

  static String sanitizeFtsQuery(String input) {
    final tokens = input
        .trim()
        .split(RegExp(r'\\s+'))
        .map(
          (token) => token
              .replaceAll(
                RegExp(r'[^a-zA-Z0-9\\u0600-\\u06FF\\u0980-\\u09FF]'),
                '',
              )
              .toLowerCase(),
        )
        .where((token) => token.isNotEmpty)
        .toList();

    if (tokens.isEmpty) {
      return '';
    }

    return tokens.map((token) => '$token*').join(' ');
  }

  static String compactWhitespace(String value) {
    return value.trim().replaceAll(RegExp(r'\\s+'), ' ');
  }
}

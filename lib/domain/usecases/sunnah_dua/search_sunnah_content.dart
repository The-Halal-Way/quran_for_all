import '../../entities/sunnah_dua/sunnah_dua_content.dart';

class SearchSunnahContent {
  const SearchSunnahContent();

  List<SunnahDuaContent> call(List<SunnahDuaContent> items, String query) =>
      List.unmodifiable(
        items.where((item) => matches(item.searchableText, query)),
      );

  /// All query words must match; keep Bengali vowel signs, but ignore Arabic
  /// recitation marks so unvocalized Arabic also finds vocalized text.
  static bool matches(String text, String query) {
    final haystack = _normalize(text);
    return _normalize(query).split(RegExp(r'\s+')).every(haystack.contains);
  }

  static String _normalize(String text) => text
      .toLowerCase()
      .replaceAll(RegExp(r'[\u0640\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
      .replaceAll(RegExp('[’‘ʿʾ]'), "'")
      .trim();
}

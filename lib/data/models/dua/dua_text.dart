typedef DuaJson = Map<String, dynamic>;

DuaJson duaMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

List<DuaJson> duaObjects(Object? value) => value is List
    ? value
          .map((item) {
            if (item is! Map) throw const FormatException('Invalid dua object');
            return duaMap(item);
          })
          .toList(growable: false)
    : const [];

List<String> duaIds(Object? value) => value is List
    ? List.unmodifiable(value.map((item) => item as String))
    : const [];

String duaString(Object? value) => value is String ? value : '';

class DuaText {
  DuaText(Object? raw)
    : values = Map.unmodifiable(duaMap(raw).cast<String, String>());
  final Map<String, String> values;

  String inLanguage(String language) {
    final code = language.toLowerCase().split(RegExp('[-_]')).first;
    return values[code] ?? values['en'] ?? values.values.firstOrNull ?? '';
  }

  bool get isEmpty => values.values.every((text) => text.trim().isEmpty);
}

List<String> duaLocalizedLines(Object? raw, String language) {
  final values = duaMap(raw);
  final code = language.split(RegExp('[-_]')).first;
  return duaIds(values[code] ?? values['en']);
}

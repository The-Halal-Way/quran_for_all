typedef RuqyahJson = Map<String, dynamic>;

RuqyahJson ruqyahObject(Object? value) {
  if (value is! Map) throw const FormatException('Expected a Ruqyah object.');
  return Map<String, dynamic>.from(value);
}

String ruqyahString(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    throw const FormatException('Missing Ruqyah text.');
  }
  return value;
}

List<RuqyahJson> ruqyahObjects(Object? value) {
  if (value is! List) throw const FormatException('Missing Ruqyah list.');
  return value.map(ruqyahObject).toList(growable: false);
}

List<String> ruqyahIds(Object? value) {
  if (value is! List) throw const FormatException('Missing Ruqyah IDs.');
  return List.unmodifiable(value.map(ruqyahString));
}

void checkRuqyahVersion(RuqyahJson json) {
  if (json['version'] != 1) {
    throw const FormatException('Unsupported Ruqyah content version.');
  }
}

class RuqyahText {
  RuqyahText(Object? raw)
    : values = Map.unmodifiable(
        ruqyahObject(
          raw,
        ).map((key, value) => MapEntry(key, ruqyahString(value))),
      ) {
    if (!values.containsKey('en') || !values.containsKey('bn')) {
      throw const FormatException('Missing Ruqyah translation.');
    }
  }

  final Map<String, String> values;
  String inLanguage(String language) => values[language] ?? values['en']!;
}

class RuqyahSource {
  RuqyahSource.fromJson(RuqyahJson json)
    : label = RuqyahText(json['label']),
      kind = json['kind'] == null ? 'reference' : ruqyahString(json['kind']),
      grade = json['grade'] == null ? null : RuqyahText(json['grade']),
      url = ruqyahString(json['url']) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw const FormatException('Invalid Ruqyah source URL.');
    }
  }

  final RuqyahText label;
  final RuqyahText? grade;
  final String url, kind;
}

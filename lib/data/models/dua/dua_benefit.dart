import 'dua_text.dart';

/// Separates a narrated virtue from context or reflection on the wording.
class DuaBenefit {
  DuaBenefit(DuaJson json)
    : text = DuaText(json['text']),
      kind = duaString(json['kind']),
      sourceLabel = DuaText(json['sourceLabel']),
      sourceUrl = duaString(json['sourceUrl']) {
    final uri = Uri.tryParse(sourceUrl);
    if (text.isEmpty ||
        !const {
          'reported_virtue',
          'reported_context',
          'reflection',
        }.contains(kind) ||
        sourceLabel.isEmpty ||
        uri == null ||
        uri.host.isEmpty ||
        !const {'https', 'http'}.contains(uri.scheme)) {
      throw const FormatException('Invalid dua benefit or source');
    }
  }
  final DuaText text, sourceLabel;
  final String kind, sourceUrl;
}

import '../../../core/utils/dua_search.dart';
import 'ruqyah_index.dart';
import 'ruqyah_text.dart';
export 'ruqyah_guide.dart';

class RuqyahReadingDetails {
  RuqyahReadingDetails.fromJson(RuqyahJson json)
    : audience = ruqyahString(json['audience']),
      background = ruqyahString(json['background']),
      method = ruqyahString(json['method']);
  final String audience, background, method;
}

class RuqyahReading {
  RuqyahReading({
    required this.summary,
    required RuqyahJson json,
    required RuqyahJson translation,
  }) : arabic = ruqyahString(json['arabic']),
       pronunciation = ruqyahString(translation['pronunciation']),
       meaning = ruqyahString(translation['meaning']),
       context = ruqyahString(translation['context']),
       details = RuqyahReadingDetails.fromJson(
         ruqyahObject(translation['details']),
       ),
       sources = List.unmodifiable(
         ruqyahObjects(json['sources']).map(RuqyahSource.fromJson),
       ),
       verseIds = List.unmodifiable((json['verse_ids'] as List).cast<int>()) {
    if (json['id'] != summary.id ||
        json['complete'] != true ||
        sources.isEmpty ||
        verseIds.any((id) => id < 1 || id > 6236) ||
        verseIds.toSet().length != verseIds.length) {
      throw const FormatException('Incomplete Ruqyah reading.');
    }
    searchIndex = DuaSearch.index([
      summary.title.values,
      arabic,
      pronunciation,
      meaning,
      context,
      details.audience,
      details.background,
      details.method,
    ]);
  }

  final RuqyahReadingSummary summary;
  String get id => summary.id;
  final String arabic, pronunciation, meaning, context;
  final List<RuqyahSource> sources;
  final List<int> verseIds;
  final RuqyahReadingDetails details;
  late final String searchIndex;
}

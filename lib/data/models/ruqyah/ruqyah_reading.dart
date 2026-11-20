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
       surahNumber = json['surah'] as int? ?? summary.surah,
       verseNumbers = List.unmodifiable(
         json['verse_numbers'] == null
             ? (summary.verseStart == null
                   ? <int>[]
                   : List.generate(
                       summary.verseEnd! - summary.verseStart! + 1,
                       (i) => summary.verseStart! + i,
                     ))
             : (json['verse_numbers'] as List).cast<int>(),
       ),
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
        verseIds.toSet().length != verseIds.length ||
        (verseNumbers.isNotEmpty &&
            (surahNumber == null ||
                verseNumbers.length != verseIds.length ||
                arabic.split('\n').length != verseNumbers.length ||
                verseIds.asMap().entries.any(
                  (e) => e.value != verseIds.first + e.key,
                ) ||
                verseNumbers.asMap().entries.any(
                  (e) => e.value != verseNumbers.first + e.key,
                ))) ||
        (summary.pack == 'extended' &&
            (verseNumbers.isEmpty ||
                surahNumber != summary.surah ||
                verseNumbers.first != summary.verseStart ||
                verseNumbers.last != summary.verseEnd ||
                meaning.split('\n').length != verseNumbers.length ||
                pronunciation.split('\n').length != verseNumbers.length))) {
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
  final int? surahNumber;
  final List<int> verseNumbers;
  String get numberedArabic {
    if (verseNumbers.isEmpty) return arabic;
    const digits = '٠١٢٣٤٥٦٧٨٩';
    final lines = arabic.split('\n');
    return List.generate(lines.length, (i) {
      final number = '${verseNumbers[i]}'
          .split('')
          .map((c) => digits[int.parse(c)])
          .join();
      return '${lines[i]} ﴿$number﴾';
    }).join('\n\n');
  }

  final RuqyahReadingDetails details;
  late final String searchIndex;
}

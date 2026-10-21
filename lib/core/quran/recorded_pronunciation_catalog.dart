/// Offline letter names, separate from vowel sounds and whole-word speech.
class RecordedPronunciationCatalog {
  const RecordedPronunciationCatalog._();

  static const sourceUrl =
      'https://commons.wikimedia.org/wiki/File:The_Arabic_Alphabet-0Isyy_ZvZR8.webm';
  static const licenseUrl = 'https://creativecommons.org/licenses/by/3.0/';
  static const author = 'Waikato Islamic School of Education';

  // Paths are relative to audioplayers' default assets/ prefix.
  static const _directory = 'audio/learn_quran/letters/';
  static const _letters = {
    'ا': 'alif',
    'أ': 'alif',
    'إ': 'alif',
    'آ': 'alif',
    'ب': 'baa',
    'ت': 'taa',
    'ث': 'thaa',
    'ج': 'jeem',
    'ح': 'haa',
    'خ': 'khaa',
    'د': 'daal',
    'ذ': 'dhaal',
    'ر': 'raa',
    'ز': 'zaay',
    'س': 'seen',
    'ش': 'sheen',
    'ص': 'saad',
    'ض': 'daad',
    'ط': 'taa_heavy',
    'ظ': 'thaa_heavy',
    'ع': 'ayn',
    'غ': 'ghayn',
    'ف': 'faa',
    'ق': 'qaaf',
    'ك': 'kaaf',
    'ل': 'laam',
    'م': 'meem',
    'ن': 'noon',
    'ه': 'haa_light',
    'و': 'waaw',
    'ي': 'yaa',
    'ء': 'hamza',
  };

  /// A complete sequence, or null when the request needs another audio source.
  /// Diacritics stay intact: بَ must never play the letter name باء.
  static List<String>? assetsFor(String text) {
    final tokens = text
        .replaceAll(RegExp(r'[\u0640\u200c-\u200f\u202a-\u202e]'), '')
        .trim()
        .split(RegExp(r'[\s/،,؛;|]+'))
        .where((token) => token.isNotEmpty)
        .toList();
    if (tokens.isEmpty || !tokens.every(_letters.containsKey)) return null;
    return [for (final token in tokens) '$_directory${_letters[token]}.mp3'];
  }
}

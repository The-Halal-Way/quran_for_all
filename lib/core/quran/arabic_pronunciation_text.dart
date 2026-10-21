/// Isolated consonants are not words. Ask the voice to pronounce their Arabic
/// names, while preserving vowelled sounds and complete words as written.
class ArabicPronunciationText {
  const ArabicPronunciationText._();

  static const _letterNames = {
    'ا': 'أَلِف',
    'أ': 'أَلِف',
    'إ': 'أَلِف',
    'آ': 'أَلِف',
    'ب': 'بَاء',
    'ت': 'تَاء',
    'ث': 'ثَاء',
    'ج': 'جِيم',
    'ح': 'حَاء',
    'خ': 'خَاء',
    'د': 'دَال',
    'ذ': 'ذَال',
    'ر': 'رَاء',
    'ز': 'زَاي',
    'س': 'سِين',
    'ش': 'شِين',
    'ص': 'صَاد',
    'ض': 'ضَاد',
    'ط': 'طَاء',
    'ظ': 'ظَاء',
    'ع': 'عَيْن',
    'غ': 'غَيْن',
    'ف': 'فَاء',
    'ق': 'قَاف',
    'ك': 'كَاف',
    'ل': 'لَام',
    'م': 'مِيم',
    'ن': 'نُون',
    'ه': 'هَاء',
    'و': 'وَاو',
    'ي': 'يَاء',
    'ء': 'هَمْزَة',
  };

  static String spokenForm(String text) {
    final clean = text.trim();
    final letters = clean
        .split(RegExp(r'[\s/،,؛;|]+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (letters.isNotEmpty && letters.every(_letterNames.containsKey)) {
      return letters.map((letter) => _letterNames[letter]!).join('، ');
    }
    return clean;
  }
}

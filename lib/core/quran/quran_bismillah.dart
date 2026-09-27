/// Separates the unnumbered opening supplied by the Arabic text edition.
abstract final class QuranBismillah {
  static bool hasSeparateOpening(int surahId) =>
      surahId > 1 && surahId <= 114 && surahId != 9;

  // Accept both ordinary and Uthmani spelling, preserving the exact verse
  // text and its vowel marks after the opening. Never remove a fixed number
  // of characters: different editions use different combining marks.
  static const _marks =
      r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]*';
  static final _opening = RegExp(
    '^\\s*\\uFEFF?'
    'ب$_marksس$_marksم$_marks\\s+'
    '[اٱ]$_marksل$_marksل$_marksه$_marks\\s+'
    '[اٱ]$_marksل$_marksر$_marksح$_marksم$_marksن$_marks\\s+'
    '[اٱ]$_marksل$_marksر$_marksح$_marksي$_marksم$_marks\\s+',
  );

  static String verseText({
    required int surahId,
    required int ayahNumber,
    required String text,
  }) {
    if (ayahNumber != 1 || !hasSeparateOpening(surahId)) return text;
    final match = _opening.firstMatch(text);
    if (match == null) return text;
    final verse = text.substring(match.end);
    return verse.trim().isEmpty ? text : verse;
  }
}

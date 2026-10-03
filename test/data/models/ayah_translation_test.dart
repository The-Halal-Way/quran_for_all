import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';

void main() {
  test('preserves bracketed source wording in additional translations', () {
    expect(
      AyahModel.normalizeAdditionalTranslation('  In the name [of Allah]  '),
      'In the name [of Allah]',
    );
  });

  test('uses the additional edition and credits its translator', () {
    final ayah = _ayah(
      tafsirEn: 'An English rendering.',
      tafsirBn: 'একটি বাংলা অনুবাদ।',
    );

    final english = ayah.additionalTranslationFor(AppLanguage.english)!;
    expect(english.text, 'An English rendering.');
    expect(english.edition, 'en.hilali');
    expect(
      english.translator,
      'Muhammad Taqi-ud-Din al-Hilali and Muhammad Muhsin Khan',
    );

    final bangla = ayah.additionalTranslationFor(AppLanguage.bangla)!;
    expect(bangla.text, 'একটি বাংলা অনুবাদ।');
    expect(bangla.edition, 'bn.hoque');
    expect(bangla.translator, 'Zohurul Hoque');
  });

  test('credits the primary edition when additional text is unavailable', () {
    final ayah = _ayah(
      tafsirEn: 'বাংলা লেখা ভুল কলামে।',
      tafsirBn: 'English text in the wrong column.',
    );

    expect(
      ayah.additionalTranslationFor(AppLanguage.english)!.edition,
      'en.asad',
    );
    expect(
      ayah.additionalTranslationFor(AppLanguage.english)!.translator,
      'Muhammad Asad',
    );
    expect(
      ayah.additionalTranslationFor(AppLanguage.bangla)!.edition,
      'bn.bengali',
    );
    expect(
      ayah.additionalTranslationFor(AppLanguage.bangla)!.translator,
      'Muhiuddin Khan',
    );
  });

  test('identifies a cross-language fallback and handles missing text', () {
    final englishOnly = _ayah(translationBn: '');
    final fallback = englishOnly.additionalTranslationFor(AppLanguage.bangla)!;
    expect(fallback.language, AppLanguage.english);
    expect(fallback.edition, 'en.asad');

    expect(
      _ayah(
        translationEn: '',
        translationBn: '',
      ).additionalTranslationFor(AppLanguage.english),
      isNull,
    );
  });
}

AyahModel _ayah({
  String translationEn = 'Primary English translation.',
  String translationBn = 'প্রাথমিক বাংলা অনুবাদ।',
  String tafsirEn = '',
  String tafsirBn = '',
}) => AyahModel(
  id: 1,
  surahId: 1,
  ayahNumber: 1,
  juzNumber: 1,
  hizbQuarter: 1,
  pageNumber: 1,
  arabicText: 'بِسْمِ ٱللَّهِ',
  transliterationEn: '',
  transliterationBn: '',
  translationEn: translationEn,
  translationBn: translationBn,
  tafsirEn: tafsirEn,
  tafsirBn: tafsirBn,
  audioUrl: '',
);

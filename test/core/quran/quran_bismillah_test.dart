import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/quran/quran_bismillah.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';

import '../../support/quran_reader_fakes.dart';

void main() {
  test('separates Uthmani and ordinary openings without altering the ayah', () {
    for (final prefix in [
      bismillahArabic,
      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'بسم الله الرحمن الرحيم',
      '\uFEFF$bismillahArabic',
    ]) {
      expect(
        readerAyah(arabic: '$prefix $baqaraArabic').arabicText,
        baqaraArabic,
      );
    }
  });

  test('Fatiha, Tawbah and Bismillah inside a verse remain unchanged', () {
    final text = '$bismillahArabic $baqaraArabic';
    for (final (surah, number) in [(1, 1), (9, 1), (27, 30), (2, 2)]) {
      expect(
        readerAyah(surahId: surah, number: number, arabic: text).arabicText,
        text,
      );
    }
    expect(
      readerAyah(surahId: 27, number: 30, arabic: 'إِنَّهُ $text').arabicText,
      'إِنَّهُ $text',
    );
  });

  test('handles already separated, empty and unexpected text safely', () {
    for (final text in [baqaraArabic, '', bismillahArabic, 'بسم الله الم']) {
      expect(readerAyah(arabic: text).arabicText, text);
    }
  });

  test('corrects existing offline records and new API imports', () {
    final original = readerAyah();
    final stored = original.toMap()
      ..['arabic_text'] = '$bismillahArabic $baqaraArabic';
    final cached = AyahModel.fromMap(stored);
    final imported = AyahModel.fromMergedApi(
      surahId: 2,
      arabicAyah: {
        'number': 8,
        'numberInSurah': 1,
        'text': '$bismillahArabic $baqaraArabic',
      },
      audioBaseUrl: 'https://cdn.islamic.network/quran/audio/128/ar.alafasy',
    );
    expect(cached.arabicText, baqaraArabic);
    expect(imported.arabicText, baqaraArabic);
    expect(cached.id, 8);
    expect(cached.ayahNumber, 1);
    expect(cached.audioUrl, original.audioUrl);
    expect(cached.transliterationEn, 'Alif-Laam-Meem');
    expect(cached.translationEn, 'Alif. Lam. Mim.');
  });

  test('only the appropriate 112 surahs have an unnumbered opening', () {
    final surahs = List.generate(114, (i) => i + 1);
    expect(surahs.where(QuranBismillah.hasSeparateOpening), hasLength(112));
    expect(QuranBismillah.hasSeparateOpening(0), isFalse);
    expect(QuranBismillah.hasSeparateOpening(115), isFalse);
  });
}

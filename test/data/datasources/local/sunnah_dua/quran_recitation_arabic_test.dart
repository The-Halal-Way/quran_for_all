import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/datasources/local/sunnah_dua/sunnah_collection_content_bn.dart';
import 'package:quran_for_all/data/datasources/local/sunnah_dua/sunnah_collection_content_en.dart';
import 'package:quran_for_all/domain/entities/sunnah_dua/sunnah_dua_content.dart';

void main() {
  test('Quran recitations preserve Uthmani Madd marks in both locales', () {
    final english = {
      for (final item in sunnahCollectionContentEn)
        if (item.kind == SunnahDuaKind.quranAyah) item.id: item.arabic,
    };
    final bengali = {
      for (final item in sunnahCollectionContentBn)
        if (item.kind == SunnahDuaKind.quranAyah) item.id: item.arabic,
    };
    const maddCounts = {
      'ayatul_kursi': 4,
      'last_two_ayah_al_baqarah': 6,
      'last_three_ayah_al_hashr': 3,
      'surah_talaq_ayah_2_3': 1,
      'aal_imran_ayah_26_27': 5,
      'surah_al_kahf_first_10_ayah': 4,
    };

    expect(english.keys, unorderedEquals(maddCounts.keys));
    expect(bengali, english);
    for (final entry in maddCounts.entries) {
      expect(
        '\u0653'.allMatches(english[entry.key]!).length,
        entry.value,
        reason: entry.key,
      );
    }
    expect(english['surah_talaq_ayah_2_3'], startsWith('وَمَن يَتَّقِ'));
    expect(
      english['surah_al_kahf_first_10_ayah']!.split('\n\n'),
      hasLength(10),
    );
    expect(english['surah_al_kahf_first_10_ayah'], startsWith('ٱلْحَمْدُ'));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/repositories/sunnah_dua_repository_impl.dart';
import 'package:quran_for_all/domain/entities/sunnah_dua/sunnah_dua_content.dart';
import 'package:quran_for_all/l10n/app_localizations_bn.dart';
import 'package:quran_for_all/l10n/app_localizations_en.dart';

void main() {
  test('More recitations share reviewed Madd text across locales', () {
    final english = SunnahDuaRepositoryImpl(AppLocalizationsEn()).collections;
    final bengali = SunnahDuaRepositoryImpl(AppLocalizationsBn()).collections;
    final moreEn = {
      for (final item in english)
        if (item.kind != SunnahDuaKind.quranAyah) item.id: item.arabic,
    };
    final moreBn = {
      for (final item in bengali)
        if (item.kind != SunnahDuaKind.quranAyah) item.id: item.arabic,
    };
    const maddCounts = {
      'morning_evening': 0,
      'seeking_forgiveness': 0,
      'difficulty': 3,
      'gratitude': 2,
      'siyam_sunnahs': 0,
      'after_salah': 1,
      'salawat': 4,
      'when_angry': 0,
      'during_loss': 1,
      'after_fajr': 1,
      'ending_gathering': 2,
      'bedtime_dhikr': 0,
    };

    expect(moreEn.keys, unorderedEquals(maddCounts.keys));
    expect(moreBn, moreEn);
    for (final entry in maddCounts.entries) {
      expect(
        '\u0653'.allMatches(moreEn[entry.key]!).length,
        entry.value,
        reason: entry.key,
      );
    }
    expect(moreEn['gratitude'], startsWith('رَبِّ أَوْزِعْنِىٓ'));
    expect(moreEn['during_loss'], startsWith('إِنَّا لِلَّهِ وَإِنَّآ'));
  });

  test('Routine recitations preserve Madd in both localizations', () {
    final english = SunnahDuaRepositoryImpl(
      AppLocalizationsEn(),
    ).dailyPractices;
    final bengali = SunnahDuaRepositoryImpl(
      AppLocalizationsBn(),
    ).dailyPractices;
    final routineEn = {
      for (final item in english)
        if (item.arabic.isNotEmpty) item.id: item.arabic,
    };
    final routineBn = {
      for (final item in bengali)
        if (item.arabic.isNotEmpty) item.id: item.arabic,
    };
    const maddCounts = {
      'waking_up': 2,
      'washroom': 2,
      'wudu_sunnahs': 1,
      'masjid_sunnahs': 2,
      'after_prayer': 0,
      'leaving_home': 0,
      'eating_sunnahs': 0,
      'sneezing_sunnah': 0,
      'sleeping_sunnahs': 0,
    };

    expect(routineEn.keys, unorderedEquals(maddCounts.keys));
    expect(routineBn, routineEn);
    for (final entry in maddCounts.entries) {
      expect(
        '\u0653'.allMatches(routineEn[entry.key]!).length,
        entry.value,
        reason: entry.key,
      );
    }
    expect(routineEn['washroom'], contains('الْخَبَآئِثِ'));
  });
}

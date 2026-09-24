import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/data/repositories/sunnah_dua_repository_impl.dart';
import 'package:quran_for_all/domain/entities/sunnah_dua/sunnah_dua_content.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/l10n/app_localizations_bn.dart';
import 'package:quran_for_all/l10n/app_localizations_en.dart';
import 'package:quran_for_all/presentation/models/sunnah_dua_shortcuts_presenter.dart';
import 'package:quran_for_all/presentation/viewmodels/sunnah_dua_viewmodel.dart';

void main() {
  test(
    'daily catalog covers the day and keeps situational content in shortcuts',
    () {
      final catalog = SunnahDuaRepositoryImpl(AppLocalizationsEn());
      final daily = catalog.dailyPractices;
      expect(daily.first.id, 'waking_up');
      expect(daily.last.id, 'sleeping_sunnahs');
      expect(daily.map((item) => item.id).toSet().length, daily.length);
      expect(daily.every((item) => item.kind == SunnahDuaKind.sunnah), isTrue);
      expect(
        daily.map((item) => item.phase).toSet(),
        SunnahDayPhase.values.toSet(),
      );
      expect(
        daily.map((item) => item.id),
        isNot(contains('seeking_forgiveness')),
      );
      expect(daily.map((item) => item.id), isNot(contains('difficulty')));
      final collectionIds = catalog.collections.map((item) => item.id);
      expect(catalog.collections, hasLength(18));
      expect(collectionIds.toSet(), hasLength(18));
      expect(
        collectionIds,
        containsAll([
          'seeking_forgiveness',
          'difficulty',
          'morning_evening',
          'gratitude',
          'siyam_sunnahs',
          'after_salah',
          'salawat',
          'when_angry',
          'during_loss',
          'after_fajr',
          'ending_gathering',
          'bedtime_dhikr',
          'ayatul_kursi',
          'last_two_ayah_al_baqarah',
          'last_three_ayah_al_hashr',
          'surah_talaq_ayah_2_3',
          'aal_imran_ayah_26_27',
          'surah_al_kahf_first_10_ayah',
        ]),
      );
      for (final item in [...daily, ...catalog.collections]) {
        expect(
          item.points.isNotEmpty || item.benefits.isNotEmpty,
          isTrue,
          reason: item.id,
        );
        expect(item.source, isNotEmpty, reason: item.id);
      }
    },
  );

  test(
    'Quran recitations are separate while routine search stays independent',
    () {
      final strings = AppLocalizationsEn();
      final model = SunnahDuaViewModel(SunnahDuaRepositoryImpl(strings));
      addTearDown(model.dispose);
      final total = model.totalPractices;
      model.searchRoutine('  DRINKING   WATER ');
      expect(model.practices.map((item) => item.id), ['drinking']);
      expect(model.collections, hasLength(12));
      expect(model.quranRecitations, hasLength(6));
      expect(
        model.quranRecitations.every((item) => item.pronunciation.isNotEmpty),
        isTrue,
      );
      expect(
        presentSunnahCollectionShortcuts(model.collections),
        hasLength(12),
      );
      expect(model.practices.map((item) => item.id), ['drinking']);
      model.searchRoutine('does-not-exist');
      expect(model.practices, isEmpty);
      model.searchRoutine('');
      expect(model.practices.length, total);
      expect(model.quranRecitations, hasLength(6));
    },
  );

  test('Bengali, Arabic without marks, and locale refresh work', () {
    final model = SunnahDuaViewModel(
      SunnahDuaRepositoryImpl(AppLocalizationsEn()),
    );
    addTearDown(model.dispose);
    model.searchRoutine('باسمك أموت');
    expect(model.practices.map((item) => item.id), ['sleeping_sunnahs']);
    model.updateRepository(SunnahDuaRepositoryImpl(AppLocalizationsBn()));
    model.searchRoutine('পানি পান');
    expect(model.practices.map((item) => item.id), ['drinking']);
    expect(model.practices.single.title, 'পানি পান');
    expect(model.practices.single.practice, contains('ধীরে'));
    expect(model.practices.single.source, contains('সহিহ'));
  });

  test('collection content has matching localized English and Bengali IDs', () {
    final english = SunnahDuaRepositoryImpl(AppLocalizationsEn()).collections;
    final bangla = SunnahDuaRepositoryImpl(AppLocalizationsBn()).collections;

    expect(
      bangla.map((item) => item.id).toList(),
      english.map((item) => item.id).toList(),
    );
    expect(
      bangla.singleWhere((item) => item.id == 'after_salah').title,
      'সালাতের পর যিকর',
    );
    expect(
      english.singleWhere((item) => item.id == 'difficulty').source,
      'Sahih al-Bukhari 6346',
    );
    final ayatulKursi = english.singleWhere(
      (item) => item.id == 'ayatul_kursi',
    );
    expect(ayatulKursi.kind, SunnahDuaKind.quranAyah);
    expect(ayatulKursi.benefits, isNotEmpty);
    expect(ayatulKursi.hadithReferences, hasLength(3));
    expect(ayatulKursi.hadithReferences[1].reference, '810');
    expect(ayatulKursi.authenticityNotes, isNotEmpty);
    final alHashr = english.singleWhere(
      (item) => item.id == 'last_three_ayah_al_hashr',
    );
    expect(alHashr.hadithReferences.single.grade, 'Weak (Da’if)');
    final alKahf = english.singleWhere(
      (item) => item.id == 'surah_al_kahf_first_10_ayah',
    );
    expect(alKahf.arabic.split('\n\n'), hasLength(10));
    expect(alKahf.pronunciation, contains('10. Idh awal-fityatu'));
    expect(alKahf.translation, contains('10. When the young men'));
    expect(alKahf.hadithReferences.single.reference, '809a');
    expect(alKahf.practice, contains('full surah'));
    expect(
      bangla.singleWhere((item) => item.id == 'ayatul_kursi').title,
      'আয়াতুল কুরসি',
    );
    for (final catalog in [english, bangla]) {
      final recitations = catalog.where(
        (item) => item.kind == SunnahDuaKind.quranAyah,
      );
      expect(recitations, hasLength(6));
      for (final item in recitations) {
        expect(item.pronunciation, isNotEmpty, reason: item.id);
        expect(item.benefits, isNotEmpty, reason: item.id);
      }
    }
    final alKahfBn = bangla.singleWhere(
      (item) => item.id == 'surah_al_kahf_first_10_ayah',
    );
    expect(alKahfBn.arabic, alKahf.arabic);
    expect(alKahfBn.pronunciation, contains('১০. ইয আওয়াল'));
    expect(alKahfBn.translation, contains('১০. যখন যুবকরা'));
  });

  test('every generated locale is selectable and survives persisted codes', () {
    expect(
      AppLanguage.values.map((language) => language.locale).toSet(),
      AppLocalizations.supportedLocales.toSet(),
    );
    for (final language in AppLanguage.values) {
      expect(AppLanguageX.fromCode(language.code), language);
      expect(language.label, isNotEmpty);
      final catalog = SunnahDuaRepositoryImpl(
        lookupAppLocalizations(language.locale),
      );
      expect(catalog.dailyPractices.length, 22);
    }
    expect(AppLanguageX.fromCode('unknown'), AppLanguage.english);
  });
}

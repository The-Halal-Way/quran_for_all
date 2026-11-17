import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/datasources/local/sunnah_catalog_loader.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/dua/dua_catalog.dart';
import 'package:quran_for_all/data/models/sunnah/sunnah_catalog.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/sunnah/sunnah_library_viewmodel.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/sunnah_catalog/sunnah_entry_view.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_catalog/sunnah_hadith_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final raw = File(SunnahCatalogLoader.assetPath).readAsStringSync();
  Map<String, dynamic> json() => jsonDecode(raw) as Map<String, dynamic>;
  final catalog = SunnahCatalog.fromJson(json());

  test('expanded asset exposes all 247 entries and 51 ordered categories', () {
    expect(catalog.entries, hasLength(247));
    expect(catalog.categories, hasLength(51));
    expect(
      catalog.category(catalog.allId).entryIds,
      catalog.entries.keys.toList(),
    );
    const newCategories = {
      'ghusl',
      'tayammum',
      'prayer_etiquette',
      'iqamah',
      'sacrifice',
      'hajj_umrah',
      'dua_etiquette',
      'gatherings',
      'marriage',
      'newborn',
      'end_of_life',
      'visiting_the_sick',
      'fitrah',
      'hair_and_beard',
    };
    final grouped = catalog.groups.expand((group) => group.categoryIds).toSet();
    expect(grouped.containsAll(newCategories), true);
    for (final id in newCategories) {
      expect(catalog.category(id).entryIds, isNotEmpty, reason: id);
    }
    for (final entry
        in (json()['entries'] as List).cast<Map<String, dynamic>>()) {
      final parsed = catalog.entries[entry['id']]!;
      for (final language in ['en', 'bn']) {
        expect(parsed.title.inLanguage(language), entry['title'][language]);
        expect(
          parsed.practice.inLanguage(language),
          entry['practice'][language],
        );
      }
    }
  });

  test('grading attribution and original source metadata survive parsing', () {
    final aqiqah =
        catalog.entries['newborn_arrange_aqiqah_on_seventh_day']!.hadith.single;
    expect(aqiqah.gradingStatus, 'sahih');
    expect(aqiqah.gradedBy.inLanguage('en'), 'Al-Albani');
    final kahf = catalog.entries['friday_read_al_kahf']!.hadith.single;
    expect(kahf.sourceCollections.single.number, '6209');
    expect(
      kahf.sourceCollections.single.collection.inLanguage('en'),
      contains('Al-Bayhaqi'),
    );
    expect(
      catalog.entries.values
          .expand((entry) => entry.hadith)
          .where((hadith) => !hadith.gradedBy.isEmpty),
      hasLength(47),
    );
  });

  test(
    'Quran links preserve full surah ranges and specified repetition counts',
    () {
      final baqarah = catalog
          .entries['quran_recite_al_baqarah_at_home']!
          .quranReadingLinks
          .single;
      expect([baqarah.surah, baqarah.ayah, baqarah.endAyah], [2, 1, 286]);
      expect(baqarah.repetitions, isNull);
      expect(
        catalog
            .entries['morning_evening_three_surahs']!
            .quranReadingLinks
            .first
            .repetitions,
        3,
      );
      expect(
        catalog
            .entries['ghusl_follow_prophetic_sequence']!
            .quranReferences
            .single
            .surah,
        5,
      );
      final duas = DuaCatalog.fromJson(
        jsonDecode(File('assets/json/dua_catalog.json').readAsStringSync())
            as Map<String, dynamic>,
      );
      for (final entry in catalog.entries.values) {
        expect(
          duas.entries.keys.toSet().containsAll(entry.linkedDuaIds),
          true,
          reason: entry.id,
        );
      }
    },
  );

  test(
    'bad integration totals, missing related IDs and hidden categories are rejected',
    () {
      final totals = json();
      totals['integration']['entryCount'] = 135;
      expect(() => SunnahCatalog.fromJson(totals), throwsFormatException);
      final related = json();
      related['entries'][0]['relatedEntryIds'] = ['missing_sunnah'];
      expect(() => SunnahCatalog.fromJson(related), throwsFormatException);
      final groups = json();
      groups['categoryGroups'][0]['categoryIds'].remove('ghusl');
      expect(() => SunnahCatalog.fromJson(groups), throwsFormatException);
      final all = json();
      all['categories'][0]['entryIds'].removeLast();
      all['categories'][0]['entryCount']--;
      expect(() => SunnahCatalog.fromJson(all), throwsFormatException);
    },
  );

  test(
    'invalid category membership, verse ranges and repetition counts are rejected',
    () {
      final membership = json();
      membership['entries'][0]['categoryIds'] = ['hajj_umrah'];
      expect(() => SunnahCatalog.fromJson(membership), throwsFormatException);
      expect(
        () => SunnahQuranReference({'surah': 2, 'ayah': 285, 'endAyah': 1}),
        throwsFormatException,
      );
      final repetitions = json();
      repetitions['entries'][0]['repetitionsByOccasion'] = {'morning': 'three'};
      expect(() => SunnahCatalog.fromJson(repetitions), throwsFormatException);
    },
  );

  test(
    'library loads only on request and finds newly added bilingual content',
    () async {
      final bundle = _CatalogBundle(raw);
      final vm = SunnahLibraryViewModel(
        loader: SunnahCatalogLoader(bundle: bundle),
      );
      addTearDown(vm.dispose);
      expect(bundle.reads, 0);
      await vm.load();
      expect(bundle.reads, 1);
      expect(vm.error, isNull);
      vm.search('ইহরামে তালবিয়া');
      expect(
        vm.results.map((entry) => entry.id),
        contains('hajj_recite_talbiyah'),
      );
      vm.selectCategory('newborn');
      vm.search('aqiqah');
      expect(
        vm.results.map((entry) => entry.id),
        contains('newborn_arrange_aqiqah_on_seventh_day'),
      );
      vm.selectCategory('hajj_umrah');
      expect(
        vm.results.map((entry) => entry.id).toList(),
        catalog.category('hajj_umrah').entryIds,
      );
    },
  );

  test('missing and malformed catalog errors can be retried', () async {
    final bundle = _CatalogBundle('{broken')..missing = true;
    final vm = SunnahLibraryViewModel(
      loader: SunnahCatalogLoader(bundle: bundle),
    );
    addTearDown(vm.dispose);
    await vm.load();
    expect(vm.error, isNotNull);
    expect(vm.catalog, isNull);
    bundle.missing = false;
    await vm.load();
    expect(vm.error, isA<FormatException>());
    bundle.raw = raw;
    await vm.load();
    expect(vm.error, isNull);
    expect(vm.catalog!.entries, hasLength(247));
  });

  testWidgets(
    'new categories preserve initial entry and swipe order in both languages',
    (tester) async {
      final settings = _Settings();
      addTearDown(settings.dispose);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(320, 700));
      final ids = catalog.category('hajj_umrah').entryIds;
      for (final language in ['en', 'bn']) {
        await tester.pumpWidget(
          ChangeNotifierProvider<SettingsViewModel>.value(
            value: settings,
            child: MaterialApp(
              key: ValueKey(language),
              locale: Locale(language),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.5)),
                child: child!,
              ),
              home: SunnahEntryView(
                catalog: catalog,
                categoryId: 'hajj_umrah',
                entry: catalog.entries[ids[1]]!,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find
              .text(catalog.entries[ids[1]]!.title.inLanguage(language))
              .hitTestable(),
          findsOneWidget,
        );
        await tester.drag(find.byType(PageView), const Offset(-300, 0));
        await tester.pumpAndSettle();
        expect(
          find
              .text(catalog.entries[ids[2]]!.title.inLanguage(language))
              .hitTestable(),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('reader displays supplied grader and original collection', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SunnahHadithCard(
              hadith: catalog.entries['friday_read_al_kahf']!.hadith.single,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Graded by Al-Albani'), findsOneWidget);
    expect(find.textContaining('Al-Bayhaqi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _CatalogBundle extends CachingAssetBundle {
  _CatalogBundle(this.raw);
  String raw;
  bool missing = false;
  int reads = 0;
  @override
  Future<ByteData> load(String key) async {
    reads++;
    if (missing) throw FlutterError('Missing test catalog');
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(raw)));
  }
}

class _Settings extends ChangeNotifier implements SettingsViewModel {
  @override
  AppSettings get settings => AppSettings.defaults();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

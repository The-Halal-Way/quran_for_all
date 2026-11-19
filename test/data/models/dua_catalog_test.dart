import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/datasources/local/dua_catalog_loader.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/dua/dua_catalog.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dua/dua_library_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/catalog/dua_entry_view.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_entry_copy_button.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_hadith_card.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_occasion_selector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final raw = File(DuaCatalogLoader.assetPath).readAsStringSync();
  DuaJson json() => jsonDecode(raw) as DuaJson;
  final catalog = DuaCatalog.fromJson(json());

  test('expanded catalog preserves bilingual content and separate indexes', () {
    expect(catalog.entries, hasLength(205));
    expect(catalog.categories, hasLength(26));
    final all = catalog.category(catalog.allId);
    expect(all.entryIds, hasLength(200));
    expect(all.referenceIds, hasLength(5));
    expect(
      all.entryIds.toSet().intersection(all.referenceIds.toSet()),
      isEmpty,
    );
    expect(all.entryIds, contains('talbiyah_hajj_and_umrah'));
    expect(all.referenceIds, contains('marketplace_dhikr_report'));
    for (final entry in duaObjects(json()['entries'])) {
      final parsed = catalog.entries[entry['id']]!;
      expect(parsed.arabic, entry['arabic']);
      for (final language in ['en', 'bn']) {
        expect(parsed.title.inLanguage(language), entry['title'][language]);
        expect(
          parsed.pronunciation.inLanguage(language),
          entry['pronunciation'][language],
        );
        expect(parsed.meaning.inLanguage(language), entry['meaning'][language]);
      }
    }
  });

  test('source attributions and differing opinions are retained', () {
    final qunut =
        catalog.entries['witr_qunut_guidance_and_protection']!.hadith.single;
    expect(qunut.grading.status, 'sahih');
    expect(
      qunut.grading.attribution.inLanguage('en'),
      startsWith('Al-Albani;'),
    );
    expect(
      qunut.grading.attribution.inLanguage('bn'),
      startsWith('আল-আলবানি;'),
    );
    expect(qunut.relation, 'wording_and_context');
    final disputed =
        catalog.entries['when_seeing_someone_afflicted']!.hadith.single;
    expect(disputed.grading.status, 'disputed');
    expect(disputed.grading.opinions.map((opinion) => opinion.status), [
      'weak',
      'hasan',
    ]);
    expect(disputed.grading.opinions.last.url, 'https://dorar.net/h/SBX6HBkw');
    expect(
      catalog.entries['beneficial_rain']!.hadith.first.wordingUrl,
      isNotEmpty,
    );
  });

  test(
    'main entries have bilingual benefits with sources and explicit kinds',
    () {
      for (final entry in catalog.entries.values) {
        if (!entry.isDefault) {
          expect(entry.benefits, isEmpty, reason: entry.id);
          continue;
        }
        expect(entry.benefits, isNotEmpty, reason: entry.id);
        for (final benefit in entry.benefits) {
          expect(benefit.text.values['en'], isNotEmpty);
          expect(benefit.text.values['bn'], isNotEmpty);
          expect(Uri.parse(benefit.sourceUrl).host, isNotEmpty);
          expect(benefit.sourceLabel.values['en'], isNotEmpty);
          expect(benefit.sourceLabel.values['bn'], isNotEmpty);
        }
      }
      final excerpt =
          catalog.entries['q_baqarah_closing_supplications']!.benefits.single;
      expect(
        excerpt.text.inLanguage('en'),
        contains('complete final two verses'),
      );
      expect(excerpt.text.inLanguage('en'), contains('excerpts'));
      expect(
        catalog.entries['hasbiyallahu_in_worry']!.benefits.single.kind,
        'reflection',
      );
      expect(
        catalog.entries['siyam_sunnahs']!.benefits.single.text.inLanguage('en'),
        contains('not a reward for reciting'),
      );
    },
  );

  test(
    'benefits cannot silently lose their source or masquerade as another kind',
    () {
      for (final change in [
        {'sourceUrl': ''},
        {'sourceUrl': 'javascript:alert(1)'},
        {'kind': 'guaranteed_reward'},
      ]) {
        final malformed = json();
        (malformed['entries'][0]['benefits'][0] as Map).addAll(change);
        expect(() => DuaCatalog.fromJson(malformed), throwsFormatException);
      }
    },
  );

  test(
    'occasion counts and full Quran ranges retain their intended meaning',
    () {
      final ikhlas = catalog.entries['q_surah_al_ikhlas']!;
      expect(ikhlas.hasOccasionSelector, true);
      expect(ikhlas.practice.preferredOccasionFor('sleep'), 'before_sleep');
      expect(ikhlas.practice.preferredOccasionFor('evening'), 'evening');
      expect(ikhlas.practice.countFor('before_sleep'), 3);
      expect(ikhlas.quranReferences.single['endAyah'], 4);
      expect(
        catalog.entries['q_surah_al_falaq']!.quranReferences.single['endAyah'],
        5,
      );
      expect(
        catalog.entries['q_surah_an_nas']!.quranReferences.single['endAyah'],
        6,
      );
      expect(
        catalog.entries['q_ayat_al_kursi']!.practice.countFor('before_sleep'),
        1,
      );
      expect(
        catalog
            .entries['ruku_glorifying_the_magnificent']!
            .practice
            .repetitions,
        isNull,
      );
      expect(catalog.entries['after_witr_holy_king']!.practice.repetitions, 3);
      final practice = DuaPractice({
        'repetitionsPerOccasion': 3,
        'repetitionsByOccasion': {'evening': null},
      });
      expect(practice.countFor('evening'), isNull);
      expect(practice.countFor('morning'), 3);
    },
  );

  test('inconsistent totals, indexes, groups and related IDs are rejected', () {
    final totals = json();
    totals['integration']['defaultEntryCount'] = 136;
    expect(() => DuaCatalog.fromJson(totals), throwsFormatException);
    final all = json();
    all['categories'][0]['entryIds'].removeLast();
    all['categories'][0]['entryCount']--;
    expect(() => DuaCatalog.fromJson(all), throwsFormatException);
    final membership = json();
    membership['entries'][0]['categoryIds'] = ['sleep'];
    expect(() => DuaCatalog.fromJson(membership), throwsFormatException);
    final groups = json();
    groups['categoryGroups'][0]['categoryIds'].remove('morning');
    expect(() => DuaCatalog.fromJson(groups), throwsFormatException);
    final related = json();
    related['entries'][0]['relatedEntryIds'] = ['missing_dua'];
    expect(() => DuaCatalog.fromJson(related), throwsFormatException);
    final count = json();
    count['entries'][0]['practice']['repetitionsPerOccasion'] = 'three';
    expect(() => DuaCatalog.fromJson(count), throwsFormatException);
  });

  test(
    'library loads on request, searches new entries and keeps reports separate',
    () async {
      final bundle = _CatalogBundle(raw);
      final vm = DuaLibraryViewModel(loader: DuaCatalogLoader(bundle: bundle));
      addTearDown(vm.dispose);
      expect(bundle.reads, 0);
      await vm.load();
      expect(bundle.reads, 1);
      expect(vm.failed, false);
      vm.search('বিতরের কুনুত');
      expect(
        vm.results.map((entry) => entry.id),
        contains('witr_qunut_guidance_and_protection'),
      );
      vm.selectCategory('worship');
      vm.search('Talbiyah');
      expect(
        vm.results.map((entry) => entry.id),
        contains('talbiyah_hajj_and_umrah'),
      );
      vm.selectCategory(catalog.allId);
      expect(vm.results, hasLength(200));
      vm.showReferences(true);
      expect(vm.results, hasLength(5));
      expect(vm.results.every((entry) => !entry.isDefault), true);
      expect(bundle.reads, 1);
    },
  );

  test(
    'missing or malformed assets can be retried without a stale string cache',
    () async {
      final bundle = _CatalogBundle('{broken')..missing = true;
      final vm = DuaLibraryViewModel(loader: DuaCatalogLoader(bundle: bundle));
      addTearDown(vm.dispose);
      await vm.load();
      expect(vm.failed, true);
      bundle.missing = false;
      await vm.load();
      expect(vm.failed, true);
      bundle.raw = raw;
      await vm.load();
      expect(vm.failed, false);
      expect(vm.catalog!.entries, hasLength(205));
      expect(bundle.reads, 3);
    },
  );

  testWidgets(
    'reader starts with bedtime context and keeps occasion choice across swipes',
    (tester) async {
      final settings = _Settings();
      addTearDown(settings.dispose);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(320, 700));
      for (final language in ['en', 'bn']) {
        await tester.pumpWidget(
          ChangeNotifierProvider<SettingsViewModel>.value(
            value: settings,
            child: _TestApp(
              key: ValueKey(language),
              language: language,
              child: DuaEntryView(
                catalog: catalog,
                categoryId: 'sleep',
                entry: catalog.entries['q_surah_al_ikhlas']!,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(DuaEntryView)),
        )!;
        Finder occasionChip(String id, String label) => find.descendant(
          of: find.byKey(ValueKey(id)),
          matching: find.widgetWithText(ChoiceChip, label),
        );
        final bedtime = occasionChip(
          'q_surah_al_ikhlas',
          l10n.duaOccasionLabel('before_sleep'),
        );
        await tester.scrollUntilVisible(
          bedtime,
          200,
          scrollable: find
              .descendant(
                of: find.byKey(const ValueKey('q_surah_al_ikhlas')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(tester.widget<ChoiceChip>(bedtime).selected, true);
        final morning = occasionChip('q_surah_al_ikhlas', l10n.duaMorning);
        await tester.ensureVisible(morning);
        await tester.pumpAndSettle();
        await tester.tap(morning);
        await tester.pumpAndSettle();
        expect(tester.widget<ChoiceChip>(morning).selected, true);
        final pagerBounds = tester.getRect(find.byType(PageView));
        // The entire reading area can pass horizontal drags to the pager.
        await tester.dragFrom(
          Offset(pagerBounds.right - 8, pagerBounds.top + 20),
          const Offset(-280, 0),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<DuaEntryCopyButton>(find.byType(DuaEntryCopyButton))
              .entry
              .id,
          'q_surah_al_falaq',
        );
        final nextBedtime = occasionChip(
          'q_surah_al_falaq',
          l10n.duaOccasionLabel('before_sleep'),
        );
        await tester.scrollUntilVisible(
          nextBedtime,
          200,
          scrollable: find
              .descendant(
                of: find.byKey(const ValueKey('q_surah_al_falaq')),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.pumpAndSettle();
        expect(tester.widget<ChoiceChip>(nextBedtime).selected, true);
        await tester.dragFrom(
          Offset(pagerBounds.left + 8, pagerBounds.top + 20),
          const Offset(280, 0),
        );
        await tester.pumpAndSettle();
        expect(tester.widget<ChoiceChip>(morning).selected, true);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('supplied occasion labels display in both languages', (
    tester,
  ) async {
    final entry = catalog.entries['refuge_from_shaytan']!;
    for (final language in ['en', 'bn']) {
      await tester.pumpWidget(
        _TestApp(
          language: language,
          child: Scaffold(
            body: DuaOccasionSelector(
              entry: entry,
              selected: 'when_angry',
              onSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in entry.practice.occasionLabels.values) {
        expect(find.text(label.inLanguage(language)), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'source cards and copied text include supplied attribution and opinions',
    (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      for (final language in ['en', 'bn']) {
        for (final id in [
          'witr_qunut_guidance_and_protection',
          'when_seeing_someone_afflicted',
        ]) {
          final entry = catalog.entries[id]!;
          final report = entry.hadith.single;
          await tester.pumpWidget(
            _TestApp(
              language: language,
              child: Scaffold(
                appBar: AppBar(actions: [DuaEntryCopyButton(entry: entry)]),
                body: SingleChildScrollView(
                  child: DuaHadithCard(hadith: report),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          if (!report.grading.attribution.isEmpty) {
            expect(
              find.text(report.grading.attribution.inLanguage(language)),
              findsOneWidget,
            );
          }
          for (final opinion in report.grading.opinions) {
            expect(
              find.textContaining(opinion.by.inLanguage(language)),
              findsOneWidget,
            );
          }
          await tester.tap(find.byType(DuaEntryCopyButton));
          await tester.pumpAndSettle();
          expect(copied, contains(entry.arabic));
          expect(copied, contains(entry.meaning.inLanguage(language)));
          if (!report.grading.attribution.isEmpty) {
            expect(
              copied,
              contains(report.grading.attribution.inLanguage(language)),
            );
          }
          for (final opinion in report.grading.opinions) {
            expect(copied, contains(opinion.by.inLanguage(language)));
            if (opinion.url.isNotEmpty) expect(copied, contains(opinion.url));
          }
          expect(tester.takeException(), isNull);
        }
      }
    },
  );
}

class _CatalogBundle extends CachingAssetBundle {
  _CatalogBundle(this.raw);
  String raw;
  bool missing = false;
  int reads = 0;

  @override
  Future<ByteData> load(String key) async {
    expect(key, DuaCatalogLoader.assetPath);
    reads++;
    if (missing) throw FlutterError('Missing test catalog');
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(raw)));
  }
}

class _TestApp extends StatelessWidget {
  const _TestApp({super.key, required this.language, required this.child});
  final String language;
  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: Locale(language),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.4)),
      child: child!,
    ),
    home: child,
  );
}

class _Settings extends ChangeNotifier implements SettingsViewModel {
  @override
  AppSettings get settings => AppSettings.defaults();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

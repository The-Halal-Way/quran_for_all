import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/core/utils/dua_search.dart';
import 'package:quran_for_all/data/datasources/local/ruqyah/ruqyah_asset_loader.dart';
import 'package:quran_for_all/data/models/ruqyah/ruqyah_progress.dart';
import 'package:quran_for_all/data/repositories/ruqyah_repository.dart';
import 'package:quran_for_all/presentation/viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';

import '../../support/ruqyah_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late RuqyahTestBundle bundle;
  late RuqyahRepository repository;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bundle = RuqyahTestBundle();
    repository = RuqyahRepository(assets: RuqyahAssetLoader(bundle: bundle));
  });

  test(
    'knowledge articles load only their selected language, independently of readings',
    () async {
      final index = await repository.assets.loadIndex();
      final bn = await repository.assets.loadGuides('bn');
      expect(bundle.loaded, [
        'assets/json/ruqyah/index.json',
        'assets/json/ruqyah/guides_bn.json',
      ]);
      expect(
        bn.map((g) => g.id).toSet(),
        index.guides.map((g) => g.id).toSet(),
      );
      expect(index.guideGroups, hasLength(4));
      for (final guide in bn) {
        expect(RegExp('[\u0980-\u09FF]').hasMatch(guide.title), isTrue);
        expect(guide.sections.length, greaterThanOrEqualTo(3));
        for (final section in guide.sections) {
          expect(RegExp('[\u0980-\u09FF]').hasMatch(section.text), isTrue);
          expect(section.sources, isNotEmpty);
        }
      }
      final en = await repository.assets.loadGuides('en');
      for (final guide in en) {
        final other = bn.singleWhere((g) => g.id == guide.id);
        expect(guide.sections.length, other.sections.length, reason: guide.id);
        expect(guide.routineIds, other.routineIds);
        expect(guide.readingIds, other.readingIds);
        expect(
          guide.sources.map((s) => s.url),
          other.sources.map((s) => s.url),
        );
      }
      final purity = en.singleWhere((g) => g.id == 'purity');
      expect(
        DuaSearch.matches(purity.searchIndex, DuaSearch.normalize('Maliki')),
        isTrue,
      );
      expect(
        DuaSearch.matches(
          purity.searchIndex,
          DuaSearch.normalize('dar-alifta'),
        ),
        isTrue,
      );
    },
  );

  test(
    'new complete Quran selections match the audio verse IDs and bilingual contexts',
    () async {
      for (final language in ['en', 'bn']) {
        final bank = await repository.assets.loadReadings(language);
        expect(bank['ayyub']!.verseIds, [2566]);
        expect(bank['yunus']!.verseIds, [2570]);
        expect(bank['quran_refuge']!.verseIds, [2770, 2771]);
        expect(bank['quran_refuge']!.arabic, startsWith('وَقُل'));
        for (final reading in bank.values) {
          expect(reading.details.audience, isNotEmpty);
          expect(reading.details.background, isNotEmpty);
          expect(reading.details.method, isNotEmpty);
        }
        expect(
          bank['daily_protection']!.sources.any((s) => s.grade != null),
          isTrue,
        );
      }
    },
  );

  test(
    'new methods retain their actual contexts, counts and separate arrangements',
    () async {
      final morning = await repository.assets.loadRoutine('morning');
      expect(morning.summary.reported, isFalse);
      expect(morning.steps.map((s) => s.readingId), [
        'ikhlas',
        'falaq',
        'nas',
        'daily_protection',
      ]);
      expect(morning.steps.map((s) => s.count), everyElement(3));
      expect(
        morning.steps.first.countSource!.grade!.inLanguage('en'),
        contains('Hasan'),
      );
      final evening = await repository.assets.loadRoutine('evening');
      expect(evening.steps.last.readingId, 'perfect_words');
      expect(evening.steps.last.count, isNull);
      final stopping = await repository.assets.loadRoutine('stopping');
      expect(stopping.summary.reported, isTrue);
      expect(stopping.steps.single.count, isNull);
      final patient = await repository.assets.loadRoutine('patient');
      expect(patient.steps.last.count, 7);
      final dream = await repository.assets.loadRoutine('bad_dream');
      expect(dream.steps[0].readingId, isNull);
      expect(dream.steps[1].count, 3);
      expect(dream.steps[2].readingId, isNull);
    },
  );

  test(
    'missing articles, broken actions and wrong-language guides are rejected',
    () async {
      const path = 'assets/json/ruqyah/guides_bn.json';
      final original = File(path).readAsStringSync();
      for (final mutation in ['missing', 'link', 'language']) {
        final raw = jsonDecode(original) as Map<String, dynamic>;
        if (mutation == 'missing') (raw['guides'] as List).removeLast();
        if (mutation == 'link') raw['guides'][0]['reading_ids'] = ['unknown'];
        if (mutation == 'language') raw['language'] = 'en';
        bundle.overrides[path] = jsonEncode(raw);
        final loader = RuqyahAssetLoader(bundle: bundle);
        await expectLater(loader.loadGuides('bn'), throwsFormatException);
      }
    },
  );

  test(
    'changed methods restart instead of attaching old counts to new steps',
    () async {
      final first = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'pain',
      );
      addTearDown(first.dispose);
      await first.load('en');
      first.increment();
      first.increment();
      final old = RuqyahProgress.tryParse(repository.store.progress!.toJson())!;
      final changed = RuqyahProgress(
        routineId: old.routineId,
        readingIds: old.readingIds,
        index: old.index,
        length: old.length,
        counts: old.counts,
        completed: old.completed,
        sequence: '${old.sequence}-different',
      );
      final second = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'pain',
        resume: changed,
      );
      addTearDown(second.dispose);
      await second.load('bn');
      expect(second.failed, isFalse);
      expect(second.progressUpdated, isTrue);
      expect(second.count, 0);
      expect(second.completed, isEmpty);
      expect(repository.store.progress!.sequence, first.sequence);
    },
  );

  test(
    'changing language after completion does not recreate an unfinished reading',
    () async {
      final reader = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'stopping',
      );
      addTearDown(reader.dispose);
      await reader.load('en');
      reader.advance();
      expect(repository.store.progress, isNull);
      await reader.load('bn');
      expect(reader.finished, isTrue);
      expect(repository.store.progress, isNull);
    },
  );
}

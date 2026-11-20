import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/data/datasources/local/ruqyah/ruqyah_asset_loader.dart';
import 'package:quran_for_all/data/datasources/local/ruqyah/ruqyah_local_store.dart';
import 'package:quran_for_all/data/models/ruqyah/ruqyah_routine.dart';
import 'package:quran_for_all/data/models/ruqyah/ruqyah_progress.dart';
import 'package:quran_for_all/data/repositories/ruqyah_repository.dart';
import 'package:quran_for_all/presentation/viewmodels/ruqyah/ruqyah_viewmodel.dart';
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
    'constructing the feature performs no I/O; opening reads only its index',
    () async {
      final model = RuqyahViewModel(repository);
      addTearDown(model.dispose);
      expect(bundle.loaded, isEmpty);
      await model.initialize();
      expect(model.failed, isFalse);
      expect(bundle.loaded, ['assets/json/ruqyah/index.json']);
      expect(model.index!.readings, hasLength(18));
      expect(model.index!.routines, hasLength(10));
      expect(model.index!.guides, hasLength(16));
    },
  );

  test(
    'only selected-language readings and guides load, on separate actions',
    () async {
      final model = RuqyahViewModel(repository);
      addTearDown(model.dispose);
      await model.initialize();
      await model.selectTab(1, 'bn');
      expect(bundle.loaded, contains('assets/json/ruqyah/readings_bn.json'));
      expect(
        bundle.loaded.any((f) => f.contains('_en.') || f.contains('guides_')),
        isFalse,
      );
      expect(model.visibleReadings.first.meaning, contains('পরম করুণাময়'));
      await model.selectTab(2, 'bn');
      expect(bundle.loaded, contains('assets/json/ruqyah/guides_bn.json'));
      expect(bundle.loaded.any((f) => f.contains('_en.')), isFalse);
    },
  );

  test(
    'complete passages, references and bilingual text exist for every reading',
    () async {
      for (final language in ['en', 'bn']) {
        final readings = await repository.assets.loadReadings(language);
        expect(readings['fatihah']!.verseIds, [1, 2, 3, 4, 5, 6, 7]);
        expect(readings['fatihah']!.arabic.split('\n'), hasLength(7));
        expect(readings['baqarah_last']!.verseIds, [292, 293]);
        expect(readings['baqarah_last']!.arabic.split('\n'), hasLength(2));
        expect(readings['kursi']!.verseIds, [262]);
        expect(readings['nas']!.verseIds, [6231, 6232, 6233, 6234, 6235, 6236]);
        for (final item in readings.values) {
          expect(item.meaning, isNotEmpty, reason: item.id);
          expect(item.pronunciation, isNotEmpty, reason: item.id);
          expect(item.context, isNotEmpty, reason: item.id);
          expect(item.sources, isNotEmpty, reason: item.id);
        }
        for (final summary in (await repository.assets.loadIndex()).routines) {
          expect(
            (await repository.assets.loadRoutine(summary.id)).steps,
            isNotEmpty,
          );
        }
      }
    },
  );

  test(
    'Arabic and localized meanings can be searched without vowel marks',
    () async {
      final model = RuqyahViewModel(repository);
      addTearDown(model.dispose);
      await model.initialize();
      await model.selectTab(1, 'bn');
      model.filter(search: 'قل هو الله احد');
      expect(model.visibleReadings.map((e) => e.id), ['ikhlas']);
      model.filter(search: 'আয়াতুল কুরসি');
      expect(model.visibleReadings.single.id, 'kursi');
    },
  );

  test(
    'bodily pain uses three then seven, and persists exact counts across languages',
    () async {
      final first = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'pain',
      );
      addTearDown(first.dispose);
      await first.load('en');
      expect(first.step.count, 3);
      expect(first.canAdvance, isFalse);
      first.advance();
      expect(first.index, 0);
      for (var i = 0; i < 3; i++) {
        first.increment();
      }
      first.advance();
      expect(first.step.count, 7);
      first.increment();
      first.increment();
      final saved = repository.store.progress!;
      expect(saved.index, 1);
      expect(saved.counts[1], 2);
      final resumed = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'pain',
        resume: saved,
      );
      addTearDown(resumed.dispose);
      await resumed.load('bn');
      expect(resumed.index, 1);
      expect(resumed.count, 2);
      expect(resumed.completed, {0});
      expect(resumed.reading!.meaning, contains('আমি'));
      await resumed.load('en');
      expect(resumed.index, 1);
      expect(resumed.count, 2);
      for (var i = 0; i < 5; i++) {
        resumed.increment();
      }
      resumed.advance();
      expect(resumed.finished, isTrue);
      expect(repository.store.progress, isNull);
    },
  );

  test(
    'bedtime repeats the entire recite and wipe cycle three times',
    () async {
      final model = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'bedtime',
      );
      addTearDown(model.dispose);
      await model.load('en');
      expect(model.length, 12);
      expect(List.generate(12, (i) => model.stepAt(i).readingId), [
        'ikhlas',
        'falaq',
        'nas',
        null,
        'ikhlas',
        'falaq',
        'nas',
        null,
        'ikhlas',
        'falaq',
        'nas',
        null,
      ]);
      expect(model.routine!.cycleAt(4), 2);
      expect(model.step.count, isNull);
      for (var i = 0; i < 12; i++) {
        model.advance();
      }
      expect(model.finished, isTrue);
      model.restart();
      expect(model.index, 0);
      expect(model.completed, isEmpty);
    },
  );

  test('swiping to the end does not mark unread steps complete', () async {
    final model = RuqyahReaderViewModel(
      repository: repository,
      routineId: 'self',
    );
    addTearDown(model.dispose);
    await model.load('en');
    model.goTo(2);
    model.advance();
    expect(model.finished, isFalse);
    expect(model.index, 0);
    expect(model.completed, {2});
  });

  test(
    'bookmark, preferences and counter writes preserve each other',
    () async {
      final model = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'pain',
      );
      addTearDown(model.dispose);
      await model.load('en');
      model.increment();
      final saveBookmark = model.toggleBookmark();
      model.setPreferences(
        const RuqyahReaderPreferences(pronunciation: false, fontSize: 34),
      );
      model.increment();
      await saveBookmark;
      // Queue a final write to await all preceding mutations.
      await repository.store.saveReader(repository.store.reader);
      final fresh = RuqyahLocalStore();
      await fresh.load();
      expect(fresh.bookmarks, contains('bismillah'));
      expect(fresh.reader.pronunciation, isFalse);
      expect(fresh.reader.fontSize, 34);
      expect(fresh.progress!.counts[0], 2);
    },
  );

  test('bad local state and out-of-range progress recover safely', () async {
    SharedPreferences.setMockInitialValues({RuqyahLocalStore.key: '{broken'});
    final store = RuqyahLocalStore();
    await store.load();
    expect(store.progress, isNull);
    expect(store.bookmarks, isEmpty);
    expect(
      RuqyahProgress.tryParse({'version': 1, 'length': 2, 'index': 9}),
      isNull,
    );
  });

  test('missing counts evidence and unknown reading IDs are rejected', () {
    expect(
      () => RuqyahStep.fromJson({
        'id': 'bad',
        'reading_id': 'fatihah',
        'count': 7,
      }),
      throwsFormatException,
    );
    expect(
      () => RuqyahRoutine.fromJson(
        {
          'id': 'bad',
          'title': {'en': 'Bad', 'bn': 'ভুল'},
          'description': {'en': 'Bad', 'bn': 'ভুল'},
          'kind': 'reported',
          'group': 'care',
          'guide_id': 'practice',
          'cycles': 1,
          'steps': [
            {'id': 'one', 'reading_id': 'missing'},
          ],
        },
        {'fatihah'},
      ),
      throwsFormatException,
    );
  });

  test(
    'malformed assets show a retryable error instead of partial readings',
    () async {
      const indexPath = 'assets/json/ruqyah/index.json';
      bundle.overrides[indexPath] = '{broken';
      final model = RuqyahViewModel(repository);
      addTearDown(model.dispose);
      await model.initialize();
      expect(model.failed, isTrue);
      bundle.overrides.remove(indexPath);
      await model.initialize();
      expect(model.failed, isFalse);
      bundle.overrides['assets/json/ruqyah/readings_bn.json'] = jsonEncode({
        'version': 1,
        'language': 'en',
        'readings': {},
      });
      await model.selectTab(1, 'bn');
      expect(model.contentFailed, isTrue);
      expect(model.readings, isNull);
    },
  );
}

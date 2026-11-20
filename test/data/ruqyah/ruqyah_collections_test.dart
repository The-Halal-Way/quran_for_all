import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/data/datasources/local/ruqyah/ruqyah_asset_loader.dart';
import 'package:quran_for_all/data/models/ruqyah/ruqyah_routine.dart';
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
    'short practices keep the long packs unloaded; collections load only the chosen language',
    () async {
      final short = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'self',
      );
      addTearDown(short.dispose);
      await short.load('en');
      expect(short.failed, isFalse);
      expect(
        bundle.loaded.any(
          (p) => p.contains('long_') || p.endsWith('/collections.json'),
        ),
        isFalse,
      );
      final reader = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'extended_quran',
      );
      addTearDown(reader.dispose);
      await reader.load('bn');
      expect(reader.failed, isFalse);
      expect(reader.length, 23);
      expect(
        bundle.loaded,
        contains('assets/json/ruqyah/long_readings_bn.json'),
      );
      expect(
        bundle.loaded,
        isNot(contains('assets/json/ruqyah/long_readings_en.json')),
      );
      expect(bundle.loaded.any((p) => p.contains('/guides_')), isFalse);
    },
  );

  test(
    'every collection has complete, non-overlapping passages and accurate totals',
    () async {
      const expected = {
        'extended_quran': (101, 17, 23),
        'manzil': (79, 14, 18),
        'musa_passages': (22, 5, 5),
      };
      Set<int>? extended, manzil;
      for (final lang in ['en', 'bn']) {
        final readings = await repository.assets.loadReadings(
          lang,
          includeExtended: true,
        );
        expect(readings.length, 37);
        for (final item in expected.entries) {
          final routine = await repository.assets.loadRoutine(item.key);
          expect(() => routine.validateCollection(readings), returnsNormally);
          final totals = routine.summary.collection!;
          expect((
            totals.verseCount,
            totals.surahCount,
            totals.passageCount,
          ), item.value);
          expect(routine.cycles, 1);
          expect(routine.steps.every((s) => s.count == null), isTrue);
          expect(routine.summary.reported, isFalse);
          final verses = routine.steps
              .expand((s) => readings[s.readingId]!.verseIds)
              .toList();
          expect(verses.toSet().length, totals.verseCount);
          if (item.key == 'extended_quran') extended = verses.toSet();
          if (item.key == 'manzil') manzil = verses.toSet();
        }
        expect(extended!.containsAll(manzil!), isTrue);
        final opening = readings['baqarah_opening']!;
        expect(opening.arabic, startsWith('الٓمٓ'));
        expect(opening.arabic, isNot(contains('بِسْمِ')));
        // References use the standard Hafs 6236-ayah numbering used by audio.
        const offsets = {
          2: 7,
          3: 293,
          7: 954,
          10: 1364,
          17: 2029,
          20: 2348,
          23: 2673,
          26: 2932,
          37: 3788,
          55: 4901,
          59: 5126,
          72: 5447,
          109: 6207,
        };
        for (final reading in readings.values.where(
          (r) => r.summary.pack == 'extended',
        )) {
          final numbers = reading.verseNumbers;
          expect(
            reading.verseIds,
            numbers.map((n) => offsets[reading.surahNumber]! + n).toList(),
            reason: reading.id,
          );
          expect(reading.arabic.split('\n').length, numbers.length);
          expect(reading.meaning.split('\n').length, numbers.length);
          expect(reading.pronunciation.split('\n').length, numbers.length);
          expect(reading.numberedArabic, contains('﴿'));
          expect(reading.arabic, isNot(contains('...')));
          expect(reading.sources, isNotEmpty);
        }
      }
    },
  );

  test(
    'truncated Arabic, missing translation and wrong-language long packs fail cleanly',
    () async {
      const arPath = 'assets/json/ruqyah/long_readings.json';
      const bnPath = 'assets/json/ruqyah/long_readings_bn.json';
      for (final mutation in ['truncated', 'missing', 'language', 'audio']) {
        bundle.overrides.clear();
        final ar =
            jsonDecode(File(arPath).readAsStringSync()) as Map<String, dynamic>;
        final bn =
            jsonDecode(File(bnPath).readAsStringSync()) as Map<String, dynamic>;
        if (mutation == 'truncated') {
          ar['readings'][0]['arabic'] = (ar['readings'][0]['arabic'] as String)
              .split('\n')
              .take(4)
              .join('\n');
        }
        if (mutation == 'audio') {
          ar['readings'][0]['verse_ids'] = [8, 9, 11, 10, 12];
        }
        if (mutation == 'missing') {
          (bn['readings'] as Map).remove('baqarah_opening');
        }
        if (mutation == 'language') bn['language'] = 'en';
        bundle.overrides[arPath] = jsonEncode(ar);
        bundle.overrides[bnPath] = jsonEncode(bn);
        await expectLater(
          RuqyahAssetLoader(
            bundle: bundle,
          ).loadReadings('bn', includeExtended: true),
          throwsFormatException,
        );
      }
    },
  );

  test(
    'duplicate or missing passages cannot pass as a complete collection',
    () async {
      final raw =
          jsonDecode(
                File('assets/json/ruqyah/collections.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final readings = await repository.assets.loadReadings(
        'en',
        includeExtended: true,
      );
      final collection = Map<String, dynamic>.from(raw['routines'][0] as Map);
      collection['steps'] = [
        for (final step in collection['steps'] as List)
          Map<String, dynamic>.from(step as Map),
      ];
      collection['steps'][1]['reading_id'] =
          collection['steps'][0]['reading_id'];
      final changed = RuqyahRoutine.fromJson(collection, readings.keys.toSet());
      expect(() => changed.validateCollection(readings), throwsFormatException);
    },
  );

  test(
    'a late collection passage resumes across languages with marks and bookmarks',
    () async {
      final first = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'extended_quran',
      );
      addTearDown(first.dispose);
      await first.load('en');
      first.goTo(18);
      first.markRead(0);
      await first.toggleBookmark();
      final saved = repository.store.progress!;
      final resumed = RuqyahReaderViewModel(
        repository: repository,
        routineId: 'extended_quran',
        resume: saved,
      );
      addTearDown(resumed.dispose);
      await resumed.load('bn');
      expect(resumed.failed, isFalse);
      expect(resumed.index, 18);
      expect(resumed.completed, {0});
      expect(resumed.bookmarked, isTrue);
      expect(
        RegExp('[\u0980-\u09FF]').hasMatch(resumed.reading!.meaning),
        isTrue,
      );
      expect(resumed.counts, isEmpty);
    },
  );
}

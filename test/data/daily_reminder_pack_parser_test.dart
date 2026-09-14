import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/datasources/local/daily_reminder_pack_loader.dart';
import 'package:quran_for_all/data/datasources/local/daily_reminder_pack_parser.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

import '../support/daily_reminder_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String raw;
  late DailyReminderPack pack;

  setUpAll(() async {
    raw = await loadDailyReminderJson();
    pack = parseDailyReminderPack(raw);
  });

  test(
    'parses all 122 consecutive releases with valid boundaries and links',
    () {
      expect(pack.items, hasLength(122));
      expect(pack.schedule, hasLength(122));
      expect(pack.schedule.first.localDate.toString(), '2026-09-13');
      expect(pack.schedule.last.localDate.toString(), '2027-01-12');
      for (var index = 1; index < pack.schedule.length; index++) {
        expect(
          pack.schedule[index].localDate.toLocalDateTime().difference(
            pack.schedule[index - 1].localDate.toLocalDateTime(),
          ),
          const Duration(days: 1),
        );
      }
      for (final item in pack.items) {
        expect(pack.scheduleForContent(item.id), isNotNull);
        expect(item.sourceIds.every(pack.sources.containsKey), isTrue);
        expect(
          item.originalPassageIds.every(pack.passages.containsKey),
          isTrue,
        );
      }
    },
  );

  test('resolves exact, base, then default whole editions', () {
    final item = pack.items.first;
    expect(item.resolveEdition('bn')?.edition.locale, 'bn');
    expect(item.resolveEdition('bn-BD')?.edition.locale, 'bn');
    expect(item.resolveEdition('fr-CA')?.edition.locale, 'en');
    expect(item.resolveEdition('fr-CA')?.isFallback, isTrue);
  });

  test('canonical Arabic remains available during localized fallback', () {
    final item = pack.items.firstWhere(
      (entry) => entry.originalPassageIds.isNotEmpty,
    );
    expect(item.resolveEdition('fr'), isNotNull);
    final passages = item.originalPassageIds.map((id) => pack.passages[id]);
    expect(passages, isNotEmpty);
    expect(passages.every((entry) => entry?.language == 'ar'), isTrue);
  });

  test('background parser succeeds and rejects invalid schema', () async {
    final parsed = await compute(parseDailyReminderPack, raw);
    expect(parsed.items, hasLength(122));
    final invalid = jsonDecode(raw) as Map<String, dynamic>;
    invalid['schemaVersion'] = 1;
    await expectLater(
      compute(parseDailyReminderPack, jsonEncode(invalid)),
      throwsFormatException,
    );
  });

  test(
    'loader shares in-flight initialization and retains valid cache',
    () async {
      var runs = 0;
      var fail = false;
      final completer = Completer<void>();
      final loader = DailyReminderPackLoader(
        assetLoader: (_) async => raw,
        parserRunner: (value) async {
          runs++;
          await completer.future;
          if (fail) throw const FormatException('bad update');
          return parseDailyReminderPack(value);
        },
      );
      final first = loader.load();
      final second = loader.load();
      completer.complete();
      expect(identical(await first, await second), isTrue);
      expect(runs, 1);
      fail = true;
      expect(await loader.load(forceRefresh: true), same(loader.cachedPack));
      expect(runs, 2);
    },
  );

  test('source models only expose exact Quran mappings as offline links', () {
    expect(pack.sources['quran:17:23']?.hasExactOfflineQuranMapping, isTrue);
    expect(pack.sources['bukhari:1']?.hasExactOfflineQuranMapping, isFalse);
  });

  test('future typed blocks parse and optional unknown blocks are omitted', () {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    (decoded['assets'] as Map<String, dynamic>)['fixture-image'] = {
      'id': 'fixture-image',
      'mimeType': 'image/png',
      'bundledAssetPath': 'assets/images/fixture.png',
      'remoteUrl': null,
    };
    final item =
        (decoded['items'] as List<dynamic>).first as Map<String, dynamic>;
    final edition =
        (item['editions'] as Map<String, dynamic>)['en']
            as Map<String, dynamic>;
    edition['blocks'] = [
      {
        'id': 'h',
        'type': 'heading',
        'required': true,
        'text': 'Heading',
        'level': 2,
      },
      {
        'id': 'o',
        'type': 'originalPassage',
        'required': false,
        'passageId': 'knowledge-excerpt',
      },
      {
        'id': 't',
        'type': 'translation',
        'required': true,
        'passageId': 'knowledge-excerpt',
        'text': 'Synthetic translation fixture.',
        'language': 'en',
        'direction': 'ltr',
        'translator': 'Fixture',
        'sourceIds': <String>[],
      },
      {
        'id': 'tr',
        'type': 'transliteration',
        'required': true,
        'passageId': 'knowledge-excerpt',
        'text': 'Synthetic transliteration.',
        'language': 'en',
        'direction': 'ltr',
        'scheme': 'fixture',
      },
      {
        'id': 'i',
        'type': 'image',
        'required': false,
        'assetId': 'fixture-image',
        'altText': 'Geometric fixture',
        'caption': null,
      },
      {
        'id': 'a',
        'type': 'audio',
        'required': false,
        'assetId': 'fixture-image',
        'transcript': 'Synthetic audio fixture.',
        'passageId': null,
      },
      {
        'id': 'l',
        'type': 'list',
        'required': true,
        'items': ['First', 'Second'],
        'ordered': true,
      },
      {'id': 'd', 'type': 'divider', 'required': false},
      {'id': 'u', 'type': 'futureOptionalType', 'required': false},
    ];
    final parsed = parseDailyReminderPack(jsonEncode(decoded));
    final blocks = parsed.items.first.editions['en']!.blocks;
    expect(blocks, hasLength(8));
    expect(
      blocks.map((block) => block.type),
      containsAll(
        DailyReminderBlockType.values.where(
          (type) => ![
            DailyReminderBlockType.paragraph,
            DailyReminderBlockType.callout,
            DailyReminderBlockType.action,
          ].contains(type),
        ),
      ),
    );
  });

  test('required unsupported content makes only that item unavailable', () {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final item =
        (decoded['items'] as List<dynamic>).first as Map<String, dynamic>;
    final edition =
        (item['editions'] as Map<String, dynamic>)['en']
            as Map<String, dynamic>;
    (edition['blocks'] as List<dynamic>).add({
      'id': 'required-future',
      'type': 'futureRequiredType',
      'required': true,
    });
    final parsed = parseDailyReminderPack(jsonEncode(decoded));
    expect(parsed.unavailableItemIds, {'dr-0001'});
    expect(parsed.items, hasLength(122));
  });
}

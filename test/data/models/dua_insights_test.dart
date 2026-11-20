import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/dua/dua_catalog.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dua/dua_library_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/insights/dua_insight_copy.dart';
import 'package:flutter/widgets.dart';

void main() {
  final raw =
      jsonDecode(File('assets/json/dua_catalog.json').readAsStringSync())
          as DuaJson;
  final catalog = DuaCatalog.fromJson(raw);

  test(
    'every supplied explanation, virtue and source is preserved in both languages',
    () {
      for (final json in duaObjects(raw['entries'])) {
        final insight = catalog.entries[json['id']]!.insights;
        final original = duaMap(json['insights']);
        for (final language in ['en', 'bn']) {
          expect(
            insight.purpose.inLanguage(language),
            original['purpose'][language],
          );
          expect(
            insight.significance.inLanguage(language),
            original['significance']['text'][language],
          );
          expect(
            insight.background.inLanguage(language),
            original['background']['text'][language],
          );
        }
        expect(insight.significanceKind, 'reflection_on_meaning');
        expect(
          insight.reportedVirtues.length,
          (original['reportedVirtues'] as List).length,
        );
        expect(
          insight.backgroundReferences.map((e) => e.url),
          duaObjects(original['background']['references']).map((e) => e['url']),
        );
        for (var i = 0; i < insight.reportedVirtues.length; i++) {
          for (final language in ['en', 'bn']) {
            expect(
              insight.reportedVirtues[i].text.inLanguage(language),
              original['reportedVirtues'][i]['text'][language],
            );
          }
        }
      }
    },
  );

  test(
    'reference-only and reflection entries do not become claimed virtues',
    () {
      for (final entry in catalog.entries.values) {
        if (entry.insights.virtueBasis == 'meaning_and_context_only') {
          expect(entry.insights.reportedVirtues, isEmpty, reason: entry.id);
        }
        if (!entry.isDefault) {
          expect(entry.insights.recommendAsRoutine, isFalse);
          expect(entry.insights.reportedVirtues, isEmpty);
          expect(entry.insights.evidenceNote.isEmpty, isFalse);
        }
      }
      expect(
        catalog
            .entries['marketplace_dhikr_report']!
            .insights
            .backgroundReferences
            .single
            .grading
            .opinions
            .map((g) => g.status),
        ['weak', 'hasan'],
      );
    },
  );

  test('reported virtues need explicit classification and valid sources', () {
    final rawInsight = duaMap(duaObjects(raw['entries']).first['insights']);
    DuaJson copy() => jsonDecode(jsonEncode(rawInsight)) as DuaJson;
    final missingSource = copy();
    missingSource['reportedVirtues'][0]['references'] = [];
    expect(() => DuaInsights(missingSource), throwsFormatException);
    final wrongBasis = copy();
    wrongBasis['virtueBasis'] = 'meaning_and_context_only';
    expect(() => DuaInsights(wrongBasis), throwsFormatException);
    final reflectionClaim = copy();
    reflectionClaim['significance']['kind'] = 'reported_virtue';
    expect(() => DuaInsights(reflectionClaim), throwsFormatException);
  });

  test(
    'older entries without insights retain their existing benefit content',
    () {
      final old = Map<String, dynamic>.of(duaObjects(raw['entries']).first)
        ..remove('insights');
      final entry = DuaEntry(old);
      expect(entry.insights.hasIntroduction, isFalse);
      expect(entry.benefits, isNotEmpty);
      expect(entry.arabic, old['arabic']);
    },
  );

  test('library search includes the newly supplied reflections', () {
    final model = DuaLibraryViewModel()..catalog = catalog;
    addTearDown(model.dispose);
    model.search('self-sufficiency');
    expect(model.results.map((e) => e.id), contains('leaving_home'));
    model.search('বাইরের কাজ ও অনিশ্চয়তার');
    expect(model.results.map((e) => e.id), contains('leaving_home'));
  });

  test(
    'copied insight text keeps full conditional wording, context and source links',
    () {
      for (final language in ['en', 'bn']) {
        final l10n = lookupAppLocalizations(Locale(language));
        final entry = catalog.entries['sayyidul_istighfar']!;
        final copy = [
          ...duaInsightIntroCopy(entry, l10n),
          ...duaInsightContextCopy(entry, l10n),
        ].join('\n');
        expect(copy, contains(entry.insights.purpose.inLanguage(language)));
        expect(
          copy,
          contains(
            entry.insights.reportedVirtues.single.text.inLanguage(language),
          ),
        );
        expect(copy, contains(entry.insights.background.inLanguage(language)));
        expect(copy, contains('https://sunnah.com/bukhari:6306'));
      }
    },
  );
}

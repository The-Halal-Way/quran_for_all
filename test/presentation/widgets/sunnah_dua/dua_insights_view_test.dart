import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/dua/dua_catalog.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_entry_tile.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_reading_panel.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/insights/dua_entry_background.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/insights/dua_entry_introduction.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_section_search.dart';

void main() {
  final catalog = DuaCatalog.fromJson(
    jsonDecode(File('assets/json/dua_catalog.json').readAsStringSync())
        as DuaJson,
  );
  for (final language in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('insights read naturally at 320px in $language $brightness', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(320, 760);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final entry = catalog.entries['sayyidul_istighfar']!;
        await tester.pumpWidget(
          _App(
            language: language,
            brightness: brightness,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  DuaEntryIntroduction(entry: entry),
                  DuaReadingPanel(passage: entry.passagesFor(null).single),
                  DuaEntryBackground(entry: entry),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final purpose = find.byKey(const ValueKey('dua-insight-purpose'));
        final virtue = find.byKey(const ValueKey('dua-insight-virtue-0'));
        final arabic = find.byKey(const ValueKey('dua-reading-arabic'));
        expect(
          tester.getTopLeft(purpose).dy,
          lessThan(tester.getTopLeft(virtue).dy),
        );
        expect(
          tester.getTopLeft(virtue).dy,
          lessThan(tester.getTopLeft(arabic).dy),
        );
        expect(
          find.text(
            entry.insights.reportedVirtues.single.text.inLanguage(language),
          ),
          findsOneWidget,
        );
        expect(find.byType(Scrollable), findsOneWidget);
        final background = find.byKey(
          PageStorageKey('dua-background-${entry.id}'),
        );
        await tester.ensureVisible(background);
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(
            lookupAppLocalizations(Locale(language)).duaBackgroundTitle,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(entry.insights.background.inLanguage(language)),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'library preview explains purpose without clipping $language $brightness',
        (tester) async {
          tester.view.physicalSize = const Size(320, 760);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          var opened = false;
          final entry = catalog.entries['sayyidul_istighfar']!;
          await tester.pumpWidget(
            _App(
              language: language,
              brightness: brightness,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: DuaEntryTile(entry: entry, onTap: () => opened = true),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.text(entry.insights.purpose.inLanguage(language)),
            findsOneWidget,
          );
          await tester.tap(find.text(entry.title.inLanguage(language)));
          expect(opened, isTrue);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'fast search edits survive an older parent echo and can still be cleared',
    (tester) async {
      var query = '';
      late StateSetter rebuild;
      await tester.pumpWidget(
        _App(
          child: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return SunnahDuaSectionSearch(
                hint: 'Search',
                query: query,
                onChanged: (_) {},
              );
            },
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Sudden');
      rebuild(() => query = 'Su');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Sudden',
      );
      rebuild(() => query = '');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    },
  );

  testWidgets(
    'reflection and weak-report context remain visibly distinct from virtues',
    (tester) async {
      for (final id in ['physical_pain', 'marketplace_dhikr_report']) {
        final entry = catalog.entries[id]!;
        await tester.pumpWidget(
          _App(
            child: SingleChildScrollView(
              child: DuaEntryIntroduction(entry: entry),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('dua-insight-virtue-0')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey('dua-insight-reflection')),
          findsOneWidget,
        );
        expect(
          find.text(entry.insights.evidenceNote.inLanguage('en')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }
    },
  );
}

class _App extends StatelessWidget {
  const _App({
    required this.child,
    this.language = 'en',
    this.brightness = Brightness.light,
  });
  final Widget child;
  final String language;
  final Brightness brightness;
  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: Locale(language),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: brightness == Brightness.dark
        ? AppTheme.darkTheme
        : AppTheme.lightTheme,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.6)),
      child: child!,
    ),
    home: Scaffold(body: child),
  );
}

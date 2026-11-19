import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/datasources/local/sunnah_dua/sunnah_collection_content.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/dua/dua_catalog.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/models/sunnah_dua_content_presenter.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/catalog/dua_entry_view.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_entry_benefits.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_entry_copy_button.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/catalog/dua_reading_panel.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_detail/sunnah_dua_benefits_panel.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_detail/sunnah_dua_detail_launcher.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_detail/sunnah_dua_detail_sheet.dart';

void main() {
  final catalog = DuaCatalog.fromJson(
    jsonDecode(File('assets/json/dua_catalog.json').readAsStringSync())
        as DuaJson,
  );

  Future<void> dragText(
    WidgetTester tester,
    Finder target,
    Finder viewport,
    ScrollPosition position,
  ) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    final before = position.pixels;
    final visible = tester.getRect(target).intersect(tester.getRect(viewport));
    expect(visible.isEmpty, false);
    await tester.dragFrom(visible.center, const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(before + 10));
  }

  testWidgets(
    'dua text drags scroll the whole page and horizontal text drags change dua',
    (tester) async {
      final settings = _Settings();
      addTearDown(settings.dispose);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(390, 844));
      for (final language in ['en', 'bn']) {
        await tester.pumpWidget(
          ChangeNotifierProvider<SettingsViewModel>.value(
            value: settings,
            child: _App(
              key: ValueKey(language),
              language: language,
              child: DuaEntryView(
                catalog: catalog,
                entry: catalog.entries['q_ayat_al_kursi']!,
                entryIds: const ['q_ayat_al_kursi', 'q_surah_al_ikhlas'],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final page = find.byKey(const ValueKey('q_ayat_al_kursi'));
        Finder within(Finder matching) =>
            find.descendant(of: page, matching: matching);
        final list = within(find.byType(ListView));
        final scrollable = within(find.byType(Scrollable));
        expect(scrollable, findsOneWidget);
        expect(within(find.byType(EditableText)), findsNothing);
        final position = tester.state<ScrollableState>(scrollable).position;
        await tester.scrollUntilVisible(
          within(find.byType(DuaReadingPanel)),
          200,
          scrollable: scrollable,
        );
        final arabic = within(find.byKey(const ValueKey('dua-reading-arabic')));
        final pronunciation = within(
          find.byKey(const ValueKey('dua-reading-pronunciation')),
        );
        final meaning = within(
          find.byKey(const ValueKey('dua-reading-meaning')),
        );
        expect(
          tester.getTopLeft(within(find.byType(DuaEntryBenefits))).dy,
          lessThan(tester.getTopLeft(arabic).dy),
        );
        for (final target in [arabic, pronunciation, meaning]) {
          await dragText(tester, target, list, position);
        }
        await tester.ensureVisible(meaning);
        await tester.pumpAndSettle();
        final visible = tester.getRect(meaning).intersect(tester.getRect(list));
        await tester.dragFrom(visible.center, const Offset(-300, 0));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<DuaEntryCopyButton>(find.byType(DuaEntryCopyButton))
              .entry
              .id,
          'q_surah_al_ikhlas',
        );
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'Quran sheets put benefits first and all three text blocks use one scroll',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(390, 844));
      for (final language in ['en', 'bn']) {
        for (final id in ['ayatul_kursi', 'surah_al_kahf_first_10_ayah']) {
          await tester.pumpWidget(
            _App(
              key: ValueKey('$language/$id'),
              language: language,
              child: Builder(
                builder: (context) {
                  final item = presentSunnahContent(
                    sunnahCollectionContent(
                      AppLocalizations.of(context)!,
                    ).firstWhere((item) => item.id == id),
                  );
                  return Scaffold(
                    body: TextButton(
                      onPressed: () => showSunnahDuaDetails(context, item),
                      child: const Text('Open reading'),
                    ),
                  );
                },
              ),
            ),
          );
          await tester.tap(find.text('Open reading'));
          await tester.pumpAndSettle();
          final sheet = find.byType(SunnahDuaDetailSheet);
          Finder within(Finder matching) =>
              find.descendant(of: sheet, matching: matching);
          final scrollable = within(find.byType(Scrollable));
          expect(scrollable, findsOneWidget);
          expect(within(find.byType(EditableText)), findsNothing);
          final position = tester.state<ScrollableState>(scrollable).position;
          final arabic = within(
            find.byKey(const ValueKey('sunnah-detail-arabic')),
          );
          final pronunciation = within(
            find.byKey(const ValueKey('sunnah-detail-pronunciation')),
          );
          final meaning = within(
            find.byKey(const ValueKey('sunnah-detail-meaning')),
          );
          expect(
            tester.getTopLeft(within(find.byType(SunnahDuaBenefitsPanel))).dy,
            lessThan(tester.getTopLeft(arabic).dy),
          );
          expect(
            tester.getTopLeft(arabic).dy,
            lessThan(tester.getTopLeft(pronunciation).dy),
          );
          expect(
            tester.getTopLeft(pronunciation).dy,
            lessThan(tester.getTopLeft(meaning).dy),
          );
          for (final target in [arabic, pronunciation, meaning]) {
            await dragText(
              tester,
              target,
              within(find.byType(SingleChildScrollView)),
              position,
            );
          }
          expect(tester.takeException(), isNull);
        }
      }
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}

class _App extends StatelessWidget {
  const _App({super.key, required this.language, required this.child});
  final String language;
  final Widget child;
  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: Locale(language),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

class _Settings extends ChangeNotifier implements SettingsViewModel {
  @override
  AppSettings get settings => AppSettings.defaults();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

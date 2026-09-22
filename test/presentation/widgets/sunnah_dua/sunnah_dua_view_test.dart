import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/sunnah_dua_view.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/daily_duah/daily_duah_data.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_detail/sunnah_dua_detail_sheet.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_grid.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_shortcut_carousel.dart';

void main() {
  testWidgets(
    'collections search opens forgiveness without filtering the routine',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const _TestApp());
      await tester.pumpAndSettle();

      final collectionSearch = find.descendant(
        of: find.byKey(const ValueKey('collections-search')),
        matching: find.byType(TextField),
      );
      await tester.ensureVisible(collectionSearch);
      await tester.enterText(collectionSearch, 'forgiveness');
      await tester.pumpAndSettle();
      final carousel = tester.widget<SunnahDuaShortcutCarousel>(
        find.byType(SunnahDuaShortcutCarousel),
      );
      expect(carousel.items.map((item) => item.id), ['seeking_forgiveness']);
      expect(
        tester
            .widgetList<SunnahDuaGrid>(find.byType(SunnahDuaGrid))
            .fold<int>(0, (sum, grid) => sum + grid.items.length),
        22,
      );

      await tester.ensureVisible(find.text('Seeking forgiveness'));
      await tester.tap(find.text('Seeking forgiveness'));
      await tester.pumpAndSettle();
      expect(find.byType(SunnahDuaDetailSheet), findsOneWidget);
      expect(find.textContaining('2702a'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('routine search has its own clear and no-results state', (
    tester,
  ) async {
    await tester.pumpWidget(const _TestApp());
    await tester.pumpAndSettle();
    final routineSearch = find.descendant(
      of: find.byKey(const ValueKey('routine-search')),
      matching: find.byType(TextField),
    );
    await tester.ensureVisible(routineSearch);
    await tester.enterText(routineSearch, 'zzzz-not-found');
    await tester.pumpAndSettle();
    expect(find.text('No matches found'), findsOneWidget);
    expect(find.byType(SunnahDuaGrid), findsNothing);
    expect(
      tester
          .widget<SunnahDuaShortcutCarousel>(
            find.byType(SunnahDuaShortcutCarousel),
          )
          .items
          .length,
      15,
    );
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.byType(SunnahDuaGrid), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('new Duah categories use Bengali localized labels', (
    tester,
  ) async {
    const labels = <(String, String)>[
      ('Learning & Understanding', 'জ্ঞান ও বোঝাপড়া'),
      ('Parents & Family', 'মা-বাবা ও পরিবার'),
      ('Repentance & Mercy', 'তাওবা ও রহমত'),
      ('Guidance & Faith', 'হিদায়াত ও ঈমান'),
      ('Provision & Goodness', 'রিযিক ও কল্যাণ'),
      ('Worship & Acceptance', 'ইবাদত ও কবুলিয়ত'),
      ('Patience & Steadfastness', 'ধৈর্য ও অবিচলতা'),
      ('Protection & Safety', 'আশ্রয় ও নিরাপত্তা'),
      ('The Hereafter', 'আখিরাত'),
      ('Illness & Visiting', 'অসুস্থতা ও রোগী দেখতে যাওয়া'),
      ('Community & Kindness', 'সমাজ ও সদাচরণ'),
      ('Rain & Weather', 'বৃষ্টি ও আবহাওয়া'),
      ('Laylat al-Qadr', 'লাইলাতুল কদর'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('bn'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                for (final (label, _) in labels)
                  Text(
                    DuahCategory(
                      icon: Icons.auto_awesome_rounded,
                      label: label,
                      items: const [],
                    ).localizedLabel(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final (_, translation) in labels) {
      expect(find.text(translation), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('$locale $brightness fits a compact phone with large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _TestApp(locale: locale, brightness: brightness, scale: 1.8),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final scrollable = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('sleeping_sunnahs')),
          500,
          scrollable: scrollable,
          maxScrolls: 40,
        );
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const ValueKey('sleeping_sunnahs')));
        await tester.pumpAndSettle();
        expect(find.byType(SunnahDuaDetailSheet), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class _TestApp extends StatelessWidget {
  const _TestApp({
    this.locale = 'en',
    this.brightness = Brightness.light,
    this.scale = 1,
  });
  final String locale;
  final Brightness brightness;
  final double scale;

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: Locale(locale),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: const SunnahDuaView(),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/views/dashboard/ramadan/ramadan_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/ramadan/ramadan_make_up_log.dart';
import 'package:quran_for_all/presentation/widgets/common/app_icon_grid_section.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_shortcut_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    String locale = 'en',
    Brightness brightness = Brightness.light,
    double textScale = 1,
    Widget? home,
  }) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: brightness == Brightness.light
              ? AppTheme.lightTheme
              : AppTheme.darkTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: home ?? const RamadanView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('dashboard shortcut opens Ramadan in place of Powerful Du’a', (
    tester,
  ) async {
    await pumpPage(
      tester,
      home: Builder(
        builder: (context) => Scaffold(
          body: AppIconGridSection(
            title: 'Explore',
            items: dashboardActions(context),
          ),
        ),
      ),
    );
    expect(find.text('Powerful Du\'a'), findsNothing);
    await tester.tap(find.text('Ramadan'));
    await tester.pumpAndSettle();
    expect(find.byType(RamadanView), findsOneWidget);
    expect(find.text('A month to return'), findsOneWidget);
  });

  testWidgets('search exposes women’s guidance and source', (tester) async {
    await pumpPage(tester);
    final search = find.byKey(const ValueKey('ramadan_search'));
    await tester.ensureVisible(search);
    await tester.enterText(search, 'pregnancy');
    await tester.pumpAndSettle();
    final topic = find.text('Pregnancy and breastfeeding');
    await tester.ensureVisible(topic);
    await tester.tap(topic);
    await tester.pumpAndSettle();
    expect(find.textContaining('fidyah opinions differ'), findsOneWidget);
    expect(find.textContaining('Egypt Dar al-Ifta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('make-up log persists a personal count', (tester) async {
    await pumpPage(tester);
    await tester.ensureVisible(find.byType(RamadanMakeUpLog));
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('ramadan_log_increase')));
    }
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('ramadan_make_up_days'), 3);
    await tester.pumpWidget(const SizedBox.shrink());
    await pumpPage(tester);
    expect(
      find.descendant(
        of: find.byType(RamadanMakeUpLog),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('overview opens the women’s guide on a compact Bangla screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPage(tester, locale: 'bn', textScale: 1.5);
    final section = find.byKey(const ValueKey('ramadan_section_women'));
    await tester.ensureVisible(section);
    await tester.tap(section);
    await tester.pumpAndSettle();
    final topic = find.text('মাসিক ও রোজা');
    await tester.ensureVisible(topic);
    await tester.tap(topic);
    await tester.pumpAndSettle();
    expect(find.textContaining('বাদ যাওয়া রোজার কাজা আছে'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('fits compact $locale $brightness with large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await pumpPage(
          tester,
          locale: locale,
          brightness: brightness,
          textScale: 1.5,
        );
        expect(find.byType(RamadanView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

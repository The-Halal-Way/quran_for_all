import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/zakat/zakat_currency.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/views/dashboard/zakat_calculator/zakat_calculator_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_icon_grid_section.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_shortcut_catalog.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/zakat_calculator/zakat_amount_field.dart';

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpPage(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    Brightness brightness = Brightness.light,
  }) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: brightness == Brightness.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          home: const ZakatCalculatorView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.byWidgetPredicate(
    (widget) => widget is ZakatAmountField && widget.label == label,
  );

  testWidgets('shows a live due amount after price, wealth and lunar year', (
    tester,
  ) async {
    await pumpPage(tester);
    final price = field('Pure silver price per gram');
    await tester.enterText(
      find.descendant(of: price, matching: find.byType(TextField)),
      '1',
    );
    final cash = field('Cash & bank balances');
    await tester.ensureVisible(cash);
    await tester.enterText(
      find.descendant(of: cash, matching: find.byType(TextField)),
      '1000',
    );
    await tester.ensureVisible(find.byType(SwitchListTile));
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    expect(find.text('Nisab reached · zakat is due'), findsOneWidget);
    expect(find.text('৳ 25.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('currency change asks before clearing entered values', (
    tester,
  ) async {
    await pumpPage(tester);
    final price = field('Pure silver price per gram');
    final input = find.descendant(of: price, matching: find.byType(TextField));
    await tester.enterText(input, '150');
    await tester.ensureVisible(find.byType(DropdownMenu<ZakatCurrency>));
    await tester.tap(find.byType(DropdownMenu<ZakatCurrency>));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('USD').last);
    await tester.pumpAndSettle();
    expect(find.text('Switch currency?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(input).controller!.text, '150');

    await tester.tap(find.byType(DropdownMenu<ZakatCurrency>));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('USD').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Switch & clear'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(input).controller!.text, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard shortcut opens the calculator', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              body: AppIconGridSection(
                title: 'Explore',
                items: dashboardActions(context),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zakat Calculator'));
    await tester.pumpAndSettle();
    expect(find.byType(ZakatCalculatorView), findsOneWidget);
  });

  for (final locale in [const Locale('en'), const Locale('bn')]) {
    for (final brightness in Brightness.values) {
      testWidgets('fits a compact phone in $locale $brightness', (
        tester,
      ) async {
        await pumpPage(tester, locale: locale, brightness: brightness);
        expect(find.byType(ZakatCalculatorView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/widgets/common/app_icon_grid_section.dart';
import 'package:quran_for_all/presentation/views/dashboard/when_you_have_a_need/need_amal.dart';
import 'package:quran_for_all/presentation/views/dashboard/when_you_have_a_need/need_amal_detail_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/when_you_have_a_need/when_you_have_a_need_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/when_you_have_a_need/dashboard_need_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/dashboard_test_app.dart';

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
          home: const WhenYouHaveANeedView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Salatul Hajah detail identifies the disputed narration', (
    tester,
  ) async {
    await pumpPage(tester);
    final search = find.byKey(const ValueKey('need_search'));
    await tester.ensureVisible(search);
    await tester.enterText(search, 'hajah');
    await tester.pumpAndSettle();
    await tester.tap(find.text('How to perform'));
    await tester.pumpAndSettle();
    expect(find.byType(NeedAmalDetailView), findsOneWidget);
    expect(find.text('Disputed / weak narration'), findsOneWidget);
    expect(find.textContaining('Tirmidhi called the report'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Yunus count is labeled personal and can be increased', (
    tester,
  ) async {
    await pumpPage(tester);
    final search = find.byKey(const ValueKey('need_search'));
    await tester.ensureVisible(search);
    await tester.enterText(search, 'yunus');
    await tester.pumpAndSettle();
    final increase = find.byKey(const ValueKey('need_increase_count'));
    await tester.ensureVisible(increase);
    await tester.tap(increase);
    await tester.pumpAndSettle();
    expect(find.text('1 / 100'), findsOneWidget);
    expect(find.textContaining('not prescribed'), findsOneWidget);
  });

  testWidgets('dashboard section opens guide and adds a stable tracker task', (
    tester,
  ) async {
    final state = DashboardTestState();
    addTearDown(state.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => DashboardTestApp(
          state: state,
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(child: DashboardNeedSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('When You Have a Need'), findsOneWidget);
    final grid = tester.widget<AppIconGridSection>(
      find.byKey(const ValueKey('dashboard_need_section')),
    );
    expect(grid.items, hasLength(NeedCategory.values.length));
    expect(grid.phoneColumns, 3);
    await tester.tap(find.text('Salah Based Amals'));
    await tester.pumpAndSettle();
    expect(find.byType(WhenYouHaveANeedView), findsOneWidget);
    expect(find.byKey(const ValueKey('need_card_tahajjud')), findsOneWidget);
    expect(find.byKey(const ValueKey('need_card_quran_khatm')), findsNothing);
    final search = find.byKey(const ValueKey('need_search'));
    await tester.ensureVisible(search);
    await tester.enterText(search, 'Tahajjud');
    await tester.pumpAndSettle();
    await tester.tap(find.text('How to perform'));
    await tester.pumpAndSettle();
    final add = find.byKey(const ValueKey('need_add_tracker_tahajjud'));
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(
      state.tracker.tasks.where(
        (task) => task.id == 'reminder_need_amal_tahajjud',
      ),
      hasLength(1),
    );
  });

  testWidgets('dashboard grid action opens all practices', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final state = DashboardTestState();
    addTearDown(state.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => DashboardTestApp(
          state: state,
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(child: DashboardNeedSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final titleTop = tester.getTopLeft(find.text('When You Have a Need')).dy;
    final actionTop = tester.getTopLeft(find.text('View all')).dy;
    final subtitleTop = tester
        .getTopLeft(find.text('Quran and Sunnah practices for times of need'))
        .dy;
    expect((titleTop - actionTop).abs(), lessThan(20));
    final titleBottom = tester
        .getBottomLeft(find.text('When You Have a Need'))
        .dy;
    expect(subtitleTop - titleBottom, closeTo(AppSpacing.xs, 0.1));
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('need_card_tahajjud')), findsOneWidget);
    expect(find.byKey(const ValueKey('need_card_quran_khatm')), findsOneWidget);
  });

  testWidgets('long Arabic dua detail fits a compact Bangla screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPage(
      tester,
      locale: 'bn',
      brightness: Brightness.dark,
      textScale: 1.5,
    );
    final search = find.byKey(const ValueKey('need_search'));
    await tester.ensureVisible(search);
    await tester.enterText(search, 'Salatul');
    await tester.pumpAndSettle();
    await tester.tap(find.text('দোয়া পড়ুন'));
    await tester.pumpAndSettle();
    expect(find.byType(NeedAmalDetailView), findsOneWidget);
    expect(find.text('মতভেদপূর্ণ / দুর্বল বর্ণনা'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard entry fits compact large text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final state = DashboardTestState();
    addTearDown(state.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => DashboardTestApp(
          state: state,
          scale: 1.5,
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(child: DashboardNeedSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
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
        expect(find.byType(WhenYouHaveANeedView), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

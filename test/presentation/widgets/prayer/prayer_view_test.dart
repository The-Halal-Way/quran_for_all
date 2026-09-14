import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/views/prayer/forbidden_times/forbidden_times_view.dart';
import 'package:quran_for_all/presentation/views/prayer/prayer_view.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_guidance/prayer_guidance_sheet.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_rakat_guide/prayer_rakat_guide_sheet.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_focus_hero.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_guidance_launcher.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_rakat_guide_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_reference_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_state_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_timeline_tile.dart';

import '../../../support/prayer_test_app.dart';

void main() {
  late PrayerTestViewModel model;
  setUp(() => model = PrayerTestViewModel());
  tearDown(() => model.dispose());

  testWidgets(
    'schedule updates refresh the focus and preserve full time ranges',
    (tester) async {
      await tester.pumpWidget(PrayerTestApp(model: model));
      await tester.pumpAndSettle();
      expect(find.byType(PrayerTimelineTile), findsNWidgets(6));
      expect(find.byType(PrayerReferenceCard), findsNWidgets(5));
      expect(
        tester.widget<PrayerFocusHero>(find.byType(PrayerFocusHero)).time,
        '4:25 PM - 6:15 PM',
      );

      model.currentPrayer = 'Isha';
      model.notifyListeners();
      await tester.pumpAndSettle();
      final hero = tester.widget<PrayerFocusHero>(find.byType(PrayerFocusHero));
      expect(hero.content.title, 'Isha Closure');
      expect(hero.time, '7:30 PM - 4:30 AM');

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, 400),
      );
      await tester.pumpAndSettle();
      expect(model.refreshes, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'loading, guide mode, permission error and retry stay available',
    (tester) async {
      model.hasData = false;
      model.isLoading = true;
      await tester.pumpWidget(PrayerTestApp(model: model));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<PrayerFocusHero>(find.byType(PrayerFocusHero)).hasTimes,
        isFalse,
      );

      model.isLoading = false;
      model.errorType = PrayerTimesErrorType.permissionDenied;
      model.notifyListeners();
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(PrayerView)),
      )!;
      expect(find.text(l10n.prayerTimesPermissionDeniedTitle), findsOneWidget);
      await tester.tap(find.text(l10n.dashboardRetry));
      await tester.pumpAndSettle();
      expect(model.refreshes, 1);

      model.hasData = true;
      model.errorType = PrayerTimesErrorType.none;
      model.notifyListeners();
      await tester.pumpAndSettle();
      expect(find.byType(PrayerStateCard), findsNothing);
      expect(
        tester.widget<PrayerFocusHero>(find.byType(PrayerFocusHero)).hasTimes,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rakat details, guidance and library navigation still open', (
    tester,
  ) async {
    await tester.pumpWidget(PrayerTestApp(model: model));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(PrayerRakatGuideCard));
    await tester.tap(find.byType(PrayerRakatGuideCard));
    await tester.pumpAndSettle();
    expect(find.byType(PrayerRakatGuideSheet), findsOneWidget);
    expect(find.text('Fajr'), findsWidgets);
    Navigator.of(tester.element(find.byType(PrayerRakatGuideSheet))).pop();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Forbidden Times'));
    await tester.tap(find.text('Forbidden Times'));
    await tester.pumpAndSettle();
    expect(find.byType(ForbiddenTimesView), findsOneWidget);
    Navigator.of(tester.element(find.byType(ForbiddenTimesView))).pop();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(PrayerGuidanceLauncher));
    await tester.tap(find.byType(PrayerGuidanceLauncher));
    await tester.pumpAndSettle();
    expect(find.byType(PrayerGuidanceSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('$locale $brightness fits a small phone with large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          PrayerTestApp(
            model: model,
            locale: locale,
            brightness: brightness,
            scale: 1.8,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byType(PrayerRakatGuideCard));
        await tester.tap(find.byType(PrayerRakatGuideCard));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        Navigator.of(tester.element(find.byType(PrayerRakatGuideSheet))).pop();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byType(PrayerGuidanceLauncher));
        await tester.tap(find.byType(PrayerGuidanceLauncher));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('regular phone and tablet layouts fit full prayer ranges', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final width in [390.0, 900.0]) {
      await tester.binding.setSurfaceSize(Size(width, 900));
      await tester.pumpWidget(PrayerTestApp(model: model));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/views/dashboard/daily_tracker/daily_tracker_full_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/dashboard_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_hadith_section.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_prayer_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_prayer_row.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_tracker_preview.dart';

import '../../../support/dashboard_test_app.dart';

void main() {
  late DashboardTestState state;
  setUp(() => state = DashboardTestState());
  tearDown(() => state.dispose());

  testWidgets('tracker preview opens the full checklist and retains progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      DashboardTestApp(state: state, home: const DashboardView()),
    );
    await tester.pumpAndSettle();
    await state.tracker.toggleTask('fajr');
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(DashboardView)),
    )!;
    expect(
      find.text(l10n.dailyTrackerProgressLabel(1, state.tracker.totalTasks)),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byType(DashboardTrackerPreview));
    await tester.tap(find.byType(DashboardTrackerPreview));
    await tester.pumpAndSettle();
    expect(find.byType(DailyTrackerFullView), findsOneWidget);
    expect(state.tracker.completedTasks, 1);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(DashboardView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pull to refresh requests fresh prayer times', (tester) async {
    await tester.pumpWidget(
      DashboardTestApp(state: state, home: const DashboardView()),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, 400),
    );
    await tester.pumpAndSettle();
    expect(state.prayer.refreshes, 1);
  });

  testWidgets('prayer details expand and collapse; retry is actionable', (
    tester,
  ) async {
    var retries = 0;
    Future<void> pumpCard({bool error = false}) => tester.pumpWidget(
      DashboardTestApp(
        state: state,
        home: Scaffold(
          body: DashboardPrayerCard(
            times: error ? const {} : state.prayer.prayerTimes,
            ranges: state.prayer.prayerTimeRanges,
            current: 'Asr',
            loading: false,
            errorTitle: error ? 'Location unavailable' : null,
            onRetry: () => retries++,
          ),
        ),
      ),
    );
    await pumpCard();
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPrayerRow), findsNothing);
    await tester.tap(find.byIcon(Icons.expand_more_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPrayerRow), findsNWidgets(5));
    expect(find.text('4:25 PM - 6:15 PM'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.expand_less_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardPrayerRow), findsNothing);
    await pumpCard(error: true);
    await tester.pumpAndSettle();
    await tester.tap(find.byWidgetPredicate((widget) => widget is TextButton));
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('$locale $brightness dashboard fits compact large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          DashboardTestApp(
            state: state,
            home: const DashboardView(),
            locale: locale,
            brightness: brightness,
            scale: 1.8,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byType(DashboardHadithSection));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('dashboard fits tablet and regular phone widths', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final width in [320.0, 390.0, 900.0]) {
      await tester.binding.setSurfaceSize(Size(width, 900));
      await tester.pumpWidget(
        DashboardTestApp(state: state, home: const DashboardView()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}

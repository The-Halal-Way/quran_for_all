import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/views/dashboard/daily_tracker/daily_tracker_full_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/dashboard_view.dart';
import 'package:quran_for_all/presentation/views/daily_reminders/daily_reminders_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_icon_grid_section.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_daily_reminder_button.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_forbidden_time_row.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_hadith_section.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_prayer_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_prayer_row.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/dashboard_view/dashboard_tracker_preview.dart';

import '../../../support/dashboard_test_app.dart';

void main() {
  late DashboardTestState state;
  setUp(() => state = DashboardTestState());
  tearDown(() => state.dispose());

  testWidgets('daily reminders open from the dashboard header', (tester) async {
    await tester.pumpWidget(
      DashboardTestApp(state: state, home: const DashboardView()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DashboardDailyReminderButton), findsOneWidget);
    await tester.tap(find.byType(DashboardDailyReminderButton));
    await tester.pumpAndSettle();

    expect(find.byType(DailyRemindersView), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    state.dispose();
  });

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

  testWidgets('duas and tools share one Explore grid', (tester) async {
    await tester.pumpWidget(
      DashboardTestApp(state: state, home: const DashboardView()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppIconGridSection), findsOneWidget);
    final section = tester.widget<AppIconGridSection>(
      find.byType(AppIconGridSection),
    );
    expect(section.items, hasLength(7));
    expect(section.title, 'Explore');
    expect(tester.takeException(), isNull);
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

  testWidgets('forbidden windows follow the daily prayer sequence', (
    tester,
  ) async {
    var openedForbiddenTimes = false;
    const forbiddenTimes = [
      PrayerForbiddenTimeItem(
        title: 'Sunrise pause',
        timeLabel: 'Around 6:00 AM',
        body: 'Wait until sunrise clears.',
      ),
      PrayerForbiddenTimeItem(
        title: 'Zenith pause',
        timeLabel: 'Before 12:05 PM',
        body: 'Wait until Dhuhr begins.',
      ),
      PrayerForbiddenTimeItem(
        title: 'Sunset pause',
        timeLabel: 'Before 6:15 PM',
        body: 'Wait until Maghrib begins.',
      ),
    ];

    await tester.pumpWidget(
      DashboardTestApp(
        state: state,
        home: Scaffold(
          body: SingleChildScrollView(
            child: DashboardPrayerCard(
              times: const {
                'Maghrib': '6:15 PM',
                'Fajr': '4:30 AM',
                'Isha': '7:30 PM',
                'Sunrise': '6:00 AM',
                'Asr': '4:25 PM',
                'Dhuhr': '12:05 PM',
              },
              ranges: const {},
              current: 'Asr',
              loading: false,
              forbiddenTimes: forbiddenTimes,
              onRetry: () {},
              onForbiddenTimesTap: () => openedForbiddenTimes = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.expand_more_rounded));
    await tester.pumpAndSettle();

    Finder prayerLabel(String label) => find.descendant(
      of: find.byType(DashboardPrayerRow),
      matching: find.text(label),
    );
    Finder forbiddenLabel(String label) => find.descendant(
      of: find.byType(DashboardForbiddenTimeRow),
      matching: find.text(label),
    );
    final labels = [
      prayerLabel('Fajr'),
      prayerLabel('Sunrise'),
      forbiddenLabel('Sunrise pause'),
      forbiddenLabel('Zenith pause'),
      prayerLabel('Dhuhr'),
      prayerLabel('Asr'),
      forbiddenLabel('Sunset pause'),
      prayerLabel('Maghrib'),
      prayerLabel('Isha'),
    ];
    final positions = labels
        .map((label) => tester.getTopLeft(label).dy)
        .toList();
    for (var index = 1; index < positions.length; index++) {
      expect(positions[index], greaterThan(positions[index - 1]));
    }

    expect(find.byType(DashboardForbiddenTimeRow), findsNWidgets(3));
    await tester.tap(find.byType(DashboardForbiddenTimeRow).first);
    expect(openedForbiddenTimes, isTrue);
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

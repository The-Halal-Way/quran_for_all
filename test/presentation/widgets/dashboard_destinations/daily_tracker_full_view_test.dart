import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/enums/task_category.dart';
import 'package:quran_for_all/data/models/daily_task_model.dart';
import 'package:quran_for_all/presentation/views/dashboard/daily_tracker/daily_tracker_full_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_add_task_bar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_celebration.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_task_tile.dart';

import '../../../support/dashboard_test_app.dart';

void main() {
  late DashboardTestState state;
  setUp(() => state = DashboardTestState());
  tearDown(() => state.dispose());

  Future<void> pumpTracker(
    WidgetTester tester, {
    String locale = 'en',
    Brightness brightness = Brightness.light,
    double scale = 1,
  }) async {
    await tester.pumpWidget(
      DashboardTestApp(
        state: state,
        home: const DailyTrackerFullView(),
        locale: locale,
        brightness: brightness,
        scale: scale,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollToTask(WidgetTester tester, String id) async {
    await tester.scrollUntilVisible(
      find.byKey(ValueKey(id)),
      400,
      scrollable: find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      ),
      maxScrolls: 60,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('toggle and untoggle persist; refresh retains progress', (
    tester,
  ) async {
    await pumpTracker(tester);
    await scrollToTask(tester, 'fajr');
    final title = state.tracker.tasks
        .firstWhere((task) => task.id == 'fajr')
        .titleEn;
    await tester.tap(find.text(title));
    await tester.pumpAndSettle();
    expect(state.repository.progress['fajr']!.isCompleted, isTrue);
    expect(state.tracker.completedTasks, 1);
    await state.tracker.loadTasks();
    await tester.pumpAndSettle();
    expect(state.tracker.completedTasks, 1);
    await tester.tap(find.text(title));
    await tester.pumpAndSettle();
    expect(state.repository.progress['fajr']!.isCompleted, isFalse);
    expect(state.tracker.completedTasks, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'custom task validates, adds and deletes only after confirmation',
    (tester) async {
      await pumpTracker(tester);
      await tester.tap(
        find.byWidgetPredicate((widget) => widget is FilledButton),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Task'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a task name'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'Read tafsir');
      await tester.enterText(find.byType(TextField).last, 'Ten pages');
      await tester.tap(find.byType(SwitchListTile));
      await tester.tap(find.text('Add Task'));
      await tester.pumpAndSettle();
      final task = state.repository.customTasks.single;
      expect(task.titleEn, 'Read tafsir');
      expect(task.titleBn, 'Ten pages');
      expect(task.isOptional, isTrue);
      await scrollToTask(tester, task.id);
      expect(find.text('Ten pages'), findsOneWidget);
      final taskBottom = tester.getBottomLeft(find.byKey(ValueKey(task.id))).dy;
      final footerTop = tester
          .getTopLeft(find.byType(DailyTrackerAddTaskBar))
          .dy;
      expect(taskBottom, lessThanOrEqualTo(footerTop));
      await tester.tap(find.byTooltip('Delete task'));
      await tester.pumpAndSettle();
      expect(state.tracker.completedTasks, 0);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(state.repository.customTasks, hasLength(1));
      await tester.tap(find.byTooltip('Delete task'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(state.repository.customTasks, isEmpty);
      expect(find.text('Read tafsir'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('add task sheet scrolls above a keyboard on compact large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpTracker(tester, scale: 1.8);
    await tester.tap(
      find.byWidgetPredicate((widget) => widget is FilledButton),
    );
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'A new habit');
    await tester.ensureVisible(find.text('Add Task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();
    expect(state.repository.customTasks.single.titleEn, 'A new habit');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bengali keeps custom titles and subtitles distinct', (
    tester,
  ) async {
    await state.tracker.addCustomTask(
      title: 'Read tafsir',
      subtitle: 'Ten pages',
    );
    await pumpTracker(tester, locale: 'bn');
    expect(find.text('ফজর নামাজ'), findsOneWidget);
    await scrollToTask(tester, state.repository.customTasks.single.id);
    expect(find.text('Read tafsir'), findsOneWidget);
    expect(find.text('Ten pages'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long custom checklists build lazily', (tester) async {
    state.repository.customTasks = List.generate(
      120,
      (i) => DailyTask(
        id: 'custom_$i',
        titleEn: 'Habit $i',
        titleBn: '',
        category: TaskCategory.custom,
      ),
    );
    await state.tracker.loadTasks();
    await pumpTracker(tester);
    expect(
      tester.widgetList(find.byType(DailyTrackerTaskTile)).length,
      lessThan(25),
    );
    expect(find.text('Habit 119'), findsNothing);
    await scrollToTask(tester, 'custom_119');
    expect(find.text('Habit 119'), findsOneWidget);
    expect(
      tester.widgetList(find.byType(DailyTrackerTaskTile)).length,
      lessThan(25),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('required routine completion can be dismissed', (tester) async {
    await pumpTracker(tester);
    for (final task in state.tracker.tasks.where((task) => !task.isOptional)) {
      await state.tracker.toggleTask(task.id);
    }
    await tester.pumpAndSettle();
    expect(find.byType(DailyTrackerCelebration), findsOneWidget);
    await tester.tap(find.text('Alhamdulillah'));
    await tester.pumpAndSettle();
    expect(find.byType(DailyTrackerCelebration), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets('$locale $brightness tracker fits compact large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await pumpTracker(
          tester,
          locale: locale,
          brightness: brightness,
          scale: 1.8,
        );
        expect(tester.takeException(), isNull);
        await scrollToTask(tester, state.tracker.tasks.last.id);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

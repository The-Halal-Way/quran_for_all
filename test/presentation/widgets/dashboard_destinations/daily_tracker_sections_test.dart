import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/enums/task_category.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/daily_task_model.dart';
import 'package:quran_for_all/presentation/views/dashboard/daily_tracker/daily_tracker_full_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_category_sliver.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_section_order_tile.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_section_order_sheet.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_section_picker.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/daily_tracker_full_view/daily_tracker_user_task_sliver.dart';

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
        theme: brightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pickSection(WidgetTester tester, TaskCategory category) async {
    await tester.ensureVisible(find.byType(DailyTrackerSectionPicker));
    await tester.tap(find.byType(DailyTrackerSectionPicker));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is PopupMenuItem<TaskCategory> && widget.value == category,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollToTask(WidgetTester tester, String id) async {
    final scroll = tester.widget<CustomScrollView>(
      find.byType(CustomScrollView),
    );
    scroll.controller!.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(ValueKey(id)),
      300,
      scrollable: find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      ),
      maxScrolls: 60,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'choosing and moving sections keeps custom content and progress in Bangla',
    (tester) async {
      await pumpTracker(tester, locale: 'bn');
      await tester.tap(
        find.byWidgetPredicate((widget) => widget is FilledButton),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<DailyTrackerSectionPicker>(
              find.byType(DailyTrackerSectionPicker),
            )
            .selected,
        TaskCategory.custom,
      );
      await tester.enterText(find.byType(TextField).first, 'Read tafsir');
      await tester.enterText(find.byType(TextField).last, 'Ten pages');
      await pickSection(tester, TaskCategory.quran);
      await tester.tap(find.text('টাস্ক যুক্ত করুন').last);
      await tester.pumpAndSettle();
      final id = state.repository.customTasks.single.id;
      expect(state.repository.customTasks.single.category, TaskCategory.quran);
      await scrollToTask(tester, id);
      expect(find.text('Read tafsir'), findsOneWidget);
      expect(find.text('Ten pages'), findsOneWidget);
      await tester.tap(find.text('Read tafsir'));
      await tester.pumpAndSettle();
      expect(state.repository.progress[id]!.isCompleted, isTrue);

      await tester.tap(find.byTooltip('কাজের অপশন'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('অন্য বিভাগে সরান'));
      await tester.pumpAndSettle();
      await pickSection(tester, TaskCategory.nafl);
      await tester.tap(find.text('সরান'));
      await tester.pumpAndSettle();
      expect(state.repository.customTasks.single.id, id);
      expect(state.repository.customTasks.single.category, TaskCategory.nafl);
      expect(state.repository.progress[id]!.isCompleted, isTrue);
      await scrollToTask(tester, id);
      expect(find.text('Read tafsir'), findsOneWidget);
      expect(find.text('Ten pages'), findsOneWidget);
      await tester.tap(find.byTooltip('কাজের অপশন'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('মুছুন'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('মুছুন'));
      await tester.pumpAndSettle();
      expect(state.repository.customTasks, isEmpty);
      expect(state.repository.progress.containsKey(id), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('drag handles reorder sections; one save applies the draft', (
    tester,
  ) async {
    await pumpTracker(tester);
    await tester.tap(find.byTooltip('Organize sections'));
    await tester.pumpAndSettle();
    final handles = find.byIcon(Icons.drag_handle_rounded);
    final start = tester.getCenter(handles.first);
    final target = tester.getCenter(handles.at(1));
    final gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(0, 20));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveTo(target + const Offset(0, 100));
    await tester.pump(const Duration(milliseconds: 350));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(state.repository.sectionOrder, TaskCategory.values);
    expect(
      tester
          .widgetList<DailyTrackerSectionOrderTile>(
            find.byType(DailyTrackerSectionOrderTile),
          )
          .singleWhere((tile) => tile.index == 0)
          .category,
      TaskCategory.nafl,
    );
    await tester.tap(find.text('Save order'));
    await tester.pumpAndSettle();
    expect(state.repository.sectionOrder.take(2), [
      TaskCategory.nafl,
      TaskCategory.prayer,
    ]);
    expect(
      tester
          .widgetList<DailyTrackerCategorySliver>(
            find.byType(DailyTrackerCategorySliver),
          )
          .first
          .category,
      TaskCategory.nafl,
    );
    await state.tracker.loadTasks();
    expect(state.tracker.groupedTasks.keys.first, TaskCategory.nafl);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'empty My Tasks can move to top; task default and reset stay predictable',
    (tester) async {
      await pumpTracker(tester);
      await tester.tap(find.byTooltip('Organize sections'));
      await tester.pumpAndSettle();
      final customRow = find.byWidgetPredicate(
        (widget) =>
            widget is DailyTrackerSectionOrderTile &&
            widget.category == TaskCategory.custom,
      );
      await tester.scrollUntilVisible(
        customRow,
        200,
        scrollable: find.descendant(
          of: find.byType(DailyTrackerSectionOrderSheet),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(
        find.descendant(
          of: customRow,
          matching: find.byTooltip('Section options'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to top'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save order'));
      await tester.pumpAndSettle();
      expect(state.repository.sectionOrder.first, TaskCategory.custom);
      await state.tracker.addCustomTask(title: 'Personal habit');
      await tester.pumpAndSettle();
      expect(state.repository.customTasks.single.category, TaskCategory.custom);
      expect(state.tracker.groupedTasks.keys.first, TaskCategory.custom);

      await tester.tap(find.byTooltip('Organize sections'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Restore default order'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(state.repository.sectionOrder.first, TaskCategory.custom);
      await tester.tap(find.byTooltip('Organize sections'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Restore default order'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save order'));
      await tester.pumpAndSettle();
      expect(state.repository.sectionOrder, TaskCategory.values);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'user tasks reorder within a built-in section without changing other tasks',
    (tester) async {
      state.repository.customTasks = const [
        DailyTask(
          id: 'custom_a',
          titleEn: 'First prayer habit',
          titleBn: '',
          category: TaskCategory.prayer,
          isUserCreated: true,
        ),
        DailyTask(
          id: 'custom_b',
          titleEn: 'Second prayer habit',
          titleBn: '',
          category: TaskCategory.prayer,
          isUserCreated: true,
        ),
        DailyTask(
          id: 'custom_c',
          titleEn: 'Another habit',
          titleBn: '',
          category: TaskCategory.custom,
        ),
      ];
      await state.tracker.loadTasks();
      await pumpTracker(tester);
      await scrollToTask(tester, 'custom_b');
      final builtInIds = state.tracker.tasks
          .where((task) => !task.isUserCreated)
          .map((task) => task.id)
          .toList();
      final section = find.byWidgetPredicate(
        (widget) =>
            widget is DailyTrackerCategorySliver &&
            widget.category == TaskCategory.prayer,
      );
      final users = tester.widget<DailyTrackerUserTaskSliver>(
        find.descendant(
          of: section,
          matching: find.byType(DailyTrackerUserTaskSliver),
        ),
      );
      users.onReorder(0, 2);
      await tester.pumpAndSettle();
      expect(state.repository.customTasks.map((task) => task.id), [
        'custom_b',
        'custom_a',
        'custom_c',
      ]);
      expect(
        state.tracker.tasks
            .where((task) => !task.isUserCreated)
            .map((task) => task.id),
        builtInIds,
      );
      await state.tracker.loadTasks();
      expect(
        state.tracker.groupedTasks[TaskCategory.prayer]!
            .where((task) => task.isUserCreated)
            .map((task) => task.id),
        ['custom_b', 'custom_a'],
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '$locale $brightness organizer fits a small phone with large text',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 700));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await pumpTracker(
            tester,
            locale: locale,
            brightness: brightness,
            scale: 1.8,
          );
          await tester.tap(
            find.byTooltip(
              locale == 'bn' ? 'বিভাগ সাজান' : 'Organize sections',
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.descendant(
              of: find.byType(DailyTrackerSectionOrderSheet),
              matching: find.byType(SliverReorderableList),
            ),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
          await tester.tap(
            find.text(locale == 'bn' ? 'ক্রম সংরক্ষণ করুন' : 'Save order'),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

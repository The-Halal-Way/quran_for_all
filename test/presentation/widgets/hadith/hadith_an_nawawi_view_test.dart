import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_an_nawawi_view.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';

import '../../../support/dashboard_test_app.dart';

void main() {
  testWidgets(
    'starts at Hadith 1 without an introduction and shows scrollbar',
    (tester) async {
      final state = DashboardTestState();
      addTearDown(state.dispose);

      await tester.pumpWidget(
        DashboardTestApp(state: state, home: const HadithAnNawawiView()),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Introduction'), findsNothing);
      expect(find.text('Intro'), findsNothing);
      expect(find.text('Hadith 1  •  1/42'), findsOneWidget);

      final pageScrollbar = tester.widget<AppPageScrollbar>(
        find.byType(AppPageScrollbar),
      );
      expect(pageScrollbar.thumbVisibility, isTrue);

      final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
      expect(scrollbar.thumbVisibility, isTrue);

      await tester.tap(find.byTooltip('Search'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Introduction'), findsNothing);
      expect(find.text('Intro'), findsNothing);
      expect(find.text('Jump to Hadith'), findsOneWidget);
    },
  );
}

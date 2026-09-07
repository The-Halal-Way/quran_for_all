import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/data/models/quran/quran_hub_models.dart';
import 'package:quran_for_all/presentation/widgets/quran/quran_view/quran_path_card.dart';
import 'package:quran_for_all/presentation/widgets/quran/quran_view/quran_path_grid.dart';

void main() {
  testWidgets('keeps both Quran paths readable on a compact phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    QuranHubDestination? selectedDestination;

    await tester.pumpWidget(
      _TestApp(
        width: 300,
        child: QuranPathGrid(
          actions: _bengaliActions,
          onSelected: (destination) => selectedDestination = destination,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(QuranPathCard), findsNWidgets(2));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('কুরআন পড়ুন'));
    expect(selectedDestination, QuranHubDestination.read);
  });

  testWidgets('stacks the paths when the available width is very narrow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(280, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        width: 280,
        child: QuranPathGrid(actions: _englishActions, onSelected: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    final readPosition = tester.getTopLeft(find.text('Read Quran'));
    final learnPosition = tester.getTopLeft(find.text('Learn Quran'));

    expect(learnPosition.dy, greaterThan(readPosition.dy));
    expect(tester.takeException(), isNull);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        ),
      ),
    );
  }
}

final _englishActions = <QuranHubAction>[
  _action(
    destination: QuranHubDestination.read,
    title: 'Read Quran',
    detail: 'Begin from any surah',
  ),
  _action(
    destination: QuranHubDestination.learn,
    title: 'Learn Quran',
    detail: 'Begin with the first guided lesson',
    progress: 0.35,
  ),
];

final _bengaliActions = <QuranHubAction>[
  _action(
    destination: QuranHubDestination.read,
    title: 'কুরআন পড়ুন',
    detail: 'যেকোনো সূরা থেকে শুরু করুন',
  ),
  _action(
    destination: QuranHubDestination.learn,
    title: 'কুরআন শিখুন',
    detail: 'প্রথম গাইডেড লেসন দিয়ে শুরু করুন',
    progress: 0.35,
  ),
];

QuranHubAction _action({
  required QuranHubDestination destination,
  required String title,
  required String detail,
  double? progress,
}) {
  return QuranHubAction(
    destination: destination,
    title: title,
    detail: detail,
    iconAsset: destination == QuranHubDestination.read
        ? MyIcons.quranViewIcon
        : MyIcons.learnIcon,
    icon: destination == QuranHubDestination.read
        ? Icons.auto_stories_rounded
        : Icons.school_rounded,
    accent: destination == QuranHubDestination.read
        ? MyColors.secondary
        : MyColors.tertiary,
    secondaryAccent: destination == QuranHubDestination.read
        ? MyColors.primaryLight
        : const Color(0xFF005C4B),
    progress: progress,
  );
}

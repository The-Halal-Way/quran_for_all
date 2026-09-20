import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/presentation/widgets/common/app_icon_grid_section.dart';

void main() {
  testWidgets('uses a four-column service-style grid on phones', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var selected = -1;

    await tester.pumpWidget(
      _TestApp(
        child: AppIconGridSection(
          title: 'Our services',
          items: _items(onSelected: (index) => selected = index),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final firstRow = [0, 1, 2, 3]
        .map((index) => tester.getTopLeft(find.text('Feature $index')).dy)
        .toList();
    expect(firstRow.toSet(), hasLength(1));
    expect(
      tester.getTopLeft(find.text('Feature 4')).dy,
      greaterThan(firstRow.first),
    );
    expect(find.byType(CupertinoButton), findsNWidgets(8));

    await tester.tap(find.text('Feature 2'));
    expect(selected, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('falls back to two columns for enlarged text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(
        textScale: 1.8,
        child: AppIconGridSection(
          title: 'Our services',
          items: _items(count: 4, onSelected: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final first = tester.getTopLeft(find.text('Feature 0'));
    final second = tester.getTopLeft(find.text('Feature 1'));
    final third = tester.getTopLeft(find.text('Feature 2'));
    expect(second.dy, first.dy);
    expect(third.dy, greaterThan(first.dy));
    expect(tester.takeException(), isNull);
  });
}

List<AppIconGridItem> _items({
  int count = 8,
  required ValueChanged<int> onSelected,
}) {
  return List.generate(
    count,
    (index) => AppIconGridItem(
      icon: Icons.favorite_rounded,
      label: 'Feature $index',
      description: 'Feature description $index',
      accent: Colors.pink,
      onTap: () => onSelected(index),
    ),
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child, this.textScale = 1});

  final Widget child;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

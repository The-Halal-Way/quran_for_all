import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/utils/app_ios_scroll_behavior.dart';
import 'package:quran_for_all/core/utils/app_page_route.dart';

void main() {
  group('iOS design system', () {
    test('standard app routes use Cupertino navigation', () {
      final route = AppPageRoute<void>(builder: (_) => const SizedBox.shrink());

      expect(route, isA<CupertinoPageRoute<void>>());
    });

    testWidgets('scrolling always uses iOS bounce physics', (tester) async {
      ScrollPhysics? physics;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              physics = const AppIosScrollBehavior().getScrollPhysics(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(physics, isA<BouncingScrollPhysics>());
      expect(physics?.parent, isA<AlwaysScrollableScrollPhysics>());
    });
  });
}

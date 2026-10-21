import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import '../tasbeeh/tasbeeh_counter_ring.dart';
import 'tasbeeh_focus_phrase.dart';

class TasbeehFocusCounter extends StatelessWidget {
  const TasbeehFocusCounter({
    super.key,
    required this.phrase,
    required this.count,
    required this.target,
  });

  final TasbeehPhrase phrase;
  final int count;
  final int target;

  Widget _ring(double diameter) => TasbeehCounterRing(
    count: count,
    target: target,
    isTargetReached: count > 0 && count % target == 0,
    diameter: diameter,
    onHero: true,
  );

  Widget _phrase(double width) => SizedBox(
    width: width,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: TasbeehFocusPhrase(phrase: phrase),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > constraints.maxHeight * 1.25) {
        return Row(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, bounds) =>
                    Center(child: _phrase(bounds.maxWidth)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, bounds) => Center(
                  child: _ring(
                    math.min(320, math.min(bounds.maxWidth, bounds.maxHeight)),
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return Column(
        children: [
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.4),
            child: _phrase(constraints.maxWidth),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, bounds) => Center(
                child: _ring(
                  math.min(320, math.min(bounds.maxWidth, bounds.maxHeight)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    },
  );
}

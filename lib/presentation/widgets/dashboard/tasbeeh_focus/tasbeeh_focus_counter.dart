import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import '../tasbeeh/tasbeeh_counter_ring.dart';
import 'tasbeeh_focus_phrase.dart';

class TasbeehFocusCounter extends StatelessWidget {
  const TasbeehFocusCounter({super.key, required this.model});
  final TasbeehViewModel model;

  Widget _ring(double diameter) => TasbeehCounterRing(
    count: model.count,
    target: model.target,
    progress: model.progress,
    isTargetReached: model.isTargetReached,
    diameter: diameter,
  );

  Widget _phrase(double width) => FittedBox(
    fit: BoxFit.scaleDown,
    child: SizedBox(
      width: width,
      child: TasbeehFocusPhrase(phrase: model.selectedPhrase),
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
            const SizedBox(width: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, bounds) => Center(
                  child: _ring(
                    math.min(360, math.min(bounds.maxWidth, bounds.maxHeight)),
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return Column(
        children: [
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.4),
            child: _phrase(constraints.maxWidth),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, bounds) => Center(
                child: _ring(
                  math.min(360, math.min(bounds.maxWidth, bounds.maxHeight)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    },
  );
}

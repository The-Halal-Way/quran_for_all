import 'package:flutter/material.dart';

import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';
import 'short_surah_step_chip.dart';

// Section 1: Learning flow overview.
class ShortSurahLearningFlowSection extends StatelessWidget {
  const ShortSurahLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShortSurahSectionCard(
      title: 'Track Flow',
      subtitle:
          'Move through this sequence to build memorization, fluency, and salah readiness.',
      child: _FlowChips(),
    );
  }
}

class _FlowChips extends StatelessWidget {
  const _FlowChips();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < ShortSurahLearningData.learningFlow.length; i++)
          ShortSurahStepChip(
            step: i + 1,
            label: ShortSurahLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

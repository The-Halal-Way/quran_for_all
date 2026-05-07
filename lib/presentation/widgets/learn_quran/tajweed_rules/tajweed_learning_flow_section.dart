import 'package:flutter/material.dart';

import 'tajweed_learning_data.dart';
import 'tajweed_section_card.dart';
import 'tajweed_step_chip.dart';

// Section 1: Learning flow overview.
class TajweedLearningFlowSection extends StatelessWidget {
  const TajweedLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TajweedSectionCard(
      title: 'Track Flow',
      subtitle:
          'Follow this sequence to move from rule recognition to full applied recitation.',
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
        for (var i = 0; i < TajweedLearningData.learningFlow.length; i++)
          TajweedStepChip(
            step: i + 1,
            label: TajweedLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

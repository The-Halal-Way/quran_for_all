import 'package:flutter/material.dart';

import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';
import 'pronunciation_basics_step_chip.dart';

// Section 1: Learning flow overview.
class PronunciationBasicsLearningFlowSection extends StatelessWidget {
  const PronunciationBasicsLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: 'Track Flow',
      subtitle:
          'Follow this order to build clarity, control, and confident recitation flow.',
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
        for (
          var i = 0;
          i < PronunciationBasicsLearningData.learningFlow.length;
          i++
        )
          PronunciationBasicsStepChip(
            step: i + 1,
            label: PronunciationBasicsLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

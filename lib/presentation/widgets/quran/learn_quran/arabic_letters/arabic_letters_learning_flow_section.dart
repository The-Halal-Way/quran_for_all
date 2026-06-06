import 'package:flutter/material.dart';

import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';
import 'arabic_letters_step_chip.dart';

// Section 1: Learning flow overview.
class ArabicLettersLearningFlowSection extends StatelessWidget {
  const ArabicLettersLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArabicLettersSectionCard(
      title: 'Track Flow',
      subtitle:
          'Complete this sequence in order. Each section prepares the next skill.',
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
        for (var i = 0; i < ArabicLettersLearningData.learningFlow.length; i++)
          ArabicLettersStepChip(
            step: i + 1,
            label: ArabicLettersLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

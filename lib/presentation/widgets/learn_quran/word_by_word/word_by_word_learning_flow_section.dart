import 'package:flutter/material.dart';

import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';
import 'word_by_word_step_chip.dart';

// Section 1: Learning flow overview.
class WordByWordLearningFlowSection extends StatelessWidget {
  const WordByWordLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: 'Track Flow',
      subtitle:
          'Follow this flow to move from vocabulary recognition to ayah-level understanding.',
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
        for (var i = 0; i < WordByWordLearningData.learningFlow.length; i++)
          WordByWordStepChip(
            step: i + 1,
            label: WordByWordLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

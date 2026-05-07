import 'package:flutter/material.dart';

import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';
import 'audio_assisted_step_chip.dart';

// Section 1: Learning flow overview.
class AudioAssistedLearningFlowSection extends StatelessWidget {
  const AudioAssistedLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: 'Track Flow',
      subtitle:
          'Follow this sequence to improve listening accuracy, imitation quality, and self-correction.',
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
        for (var i = 0; i < AudioAssistedLearningData.learningFlow.length; i++)
          AudioAssistedStepChip(
            step: i + 1,
            label: AudioAssistedLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'makharij_learning_data.dart';
import 'makharij_section_card.dart';
import 'makharij_step_chip.dart';

class MakharijLearningFlowSection extends StatelessWidget {
  const MakharijLearningFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const MakharijSectionCard(
      title: 'Track Flow',
      subtitle:
          'Move in this order to build articulation precision from zone awareness to real phrase recitation.',
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
        for (var i = 0; i < MakharijLearningData.learningFlow.length; i++)
          MakharijStepChip(
            step: i + 1,
            label: MakharijLearningData.learningFlow[i],
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 5: Pause and restart guidance.
class PronunciationBasicsStopRestartSection extends StatelessWidget {
  const PronunciationBasicsStopRestartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '4) Pause and Restart Guidance',
      subtitle:
          'Stopping and restarting cleanly protects meaning and improves recitation confidence.',
      child: _StopRestartList(),
    );
  }
}

class _StopRestartList extends StatelessWidget {
  const _StopRestartList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final rule in PronunciationBasicsLearningData.stopRestartRules)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _StopRestartCard(rule: rule),
          ),
      ],
    );
  }
}

class _StopRestartCard extends StatelessWidget {
  const _StopRestartCard({required this.rule});

  final StopRestartGuide rule;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rule.rule,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          _Line(label: 'Pause', value: rule.pauseAction),
          const SizedBox(height: 4),
          _Line(label: 'Restart', value: rule.restartAction),
          const SizedBox(height: 4),
          _Line(label: 'Example', value: rule.example),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

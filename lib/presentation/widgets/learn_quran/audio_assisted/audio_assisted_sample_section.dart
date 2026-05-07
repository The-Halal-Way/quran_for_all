import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 6: Targeted sample practice.
class AudioAssistedSampleSection extends StatelessWidget {
  const AudioAssistedSampleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: '5) Targeted Audio Sample Practice',
      subtitle:
          'Practice selected ayah sets with clear listening goals and repeat targets.',
      child: _SampleList(),
    );
  }
}

class _SampleList extends StatelessWidget {
  const _SampleList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in AudioAssistedLearningData.sampleTargets)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SampleCard(item: item),
          ),
      ],
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.item});

  final AudioRecitationSampleGuide item;

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
            item.reference,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: context.learnText('Focus'), value: item.focus),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Listen for'), value: item.listenFor),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Repeat target'),
            value: item.repeatTarget,
          ),
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

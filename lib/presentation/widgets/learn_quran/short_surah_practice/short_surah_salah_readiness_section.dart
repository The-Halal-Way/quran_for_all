import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';

// Section 5: Salah readiness checkpoints.
class ShortSurahSalahReadinessSection extends StatelessWidget {
  const ShortSurahSalahReadinessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShortSurahSectionCard(
      title: '4) Salah Readiness Checklist',
      subtitle:
          'Evaluate if your short surah recitation is accurate, stable, and prayer-ready.',
      child: _ReadinessList(),
    );
  }
}

class _ReadinessList extends StatelessWidget {
  const _ReadinessList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in ShortSurahLearningData.salahReadiness)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ReadinessCard(item: item),
          ),
      ],
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.item});

  final ShortSurahSalahReadinessGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.checkpoint,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: context.learnText('Do this'), value: item.whatToDo),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Success marker'),
            value: item.successMarker,
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

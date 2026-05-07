import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'tajweed_learning_data.dart';
import 'tajweed_section_card.dart';

// Section 3: Meem saakin rule training.
class TajweedMeemSaakinSection extends StatelessWidget {
  const TajweedMeemSaakinSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TajweedSectionCard(
      title: '2) Meem Saakin Rules',
      subtitle:
          'Apply ikhfa shafawi, idgham shafawi, and izhar shafawi inside connected reading.',
      child: _MeemRuleList(),
    );
  }
}

class _MeemRuleList extends StatelessWidget {
  const _MeemRuleList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in TajweedLearningData.meemSaakinRules)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MeemRuleCard(item: item),
          ),
      ],
    );
  }
}

class _MeemRuleCard extends StatelessWidget {
  const _MeemRuleCard({required this.item});

  final TajweedMeemRuleGuide item;

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
            item.rule,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          _Line(label: context.learnText('Trigger'), value: item.trigger),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Delivery'), value: item.delivery),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Example'), value: item.example),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Common mistake'),
            value: item.mistake,
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

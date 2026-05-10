import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../pronunciation_button.dart';
import 'tajweed_learning_data.dart';
import 'tajweed_section_card.dart';

// Section 2: Noon saakin and tanween rule mapping.
class TajweedNoonTanweenSection extends StatelessWidget {
  const TajweedNoonTanweenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TajweedSectionCard(
      title: '1) Noon Saakin and Tanween Rules',
      subtitle:
          'Study izhar, idgham, iqlab, and ikhfa with triggers, examples, and delivery notes.',
      child: _RuleList(),
    );
  }
}

class _RuleList extends StatelessWidget {
  const _RuleList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in TajweedLearningData.noonTanweenRules)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RuleCard(item: item),
          ),
      ],
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.item});

  final TajweedRuleFamilyGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary.withValues(alpha: 0.09),
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
          _Line(label: context.learnText('How to read'), value: item.howToRead),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _Line(
                  label: context.learnText('Example'),
                  value: item.example,
                ),
              ),
              PronunciationButton(
                arabicText: extractArabic(item.example),
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Coach note'), value: item.coachNote),
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

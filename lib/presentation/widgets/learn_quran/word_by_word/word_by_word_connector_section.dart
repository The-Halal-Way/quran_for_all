import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../pronunciation_button.dart';
import 'word_by_word_learning_data.dart';
import 'word_by_word_section_card.dart';

// Section 4: Connector words and phrase role reading.
class WordByWordConnectorSection extends StatelessWidget {
  const WordByWordConnectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordByWordSectionCard(
      title: '3) Connector Words and Particle Cues',
      subtitle:
          'Spot linking words that shape sentence meaning, sequence, emphasis, and direction.',
      child: _ConnectorList(),
    );
  }
}

class _ConnectorList extends StatelessWidget {
  const _ConnectorList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in WordByWordLearningData.connectors)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ConnectorCard(item: item),
          ),
      ],
    );
  }
}

class _ConnectorCard extends StatelessWidget {
  const _ConnectorCard({required this.item});

  final WordByWordConnectorGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        color: colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.word,
                  style: AppTheme.text(context).titleMedium.copyWith(
                    color: colorScheme.primary,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              PronunciationButton(
                arabicText: item.word,
                size: 20,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 5),
          _Line(label: context.learnText('Function'), value: item.function),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Sample'), value: item.sample),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Reading cue'),
            value: item.readingCue,
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
        style: AppTheme.text(context).bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: AppTheme.text(
              context,
            ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

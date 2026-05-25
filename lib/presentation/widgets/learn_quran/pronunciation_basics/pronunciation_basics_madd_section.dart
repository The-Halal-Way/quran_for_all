import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../pronunciation_button.dart';
import 'pronunciation_basics_learning_data.dart';
import 'pronunciation_basics_section_card.dart';

// Section 4: Madd timing and vowel length control.
class PronunciationBasicsMaddSection extends StatelessWidget {
  const PronunciationBasicsMaddSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const PronunciationBasicsSectionCard(
      title: '3) Madd Timing and Vowel Length Control',
      subtitle:
          'Practice natural madd with fixed timing. The goal is consistency, not exaggeration.',
      child: _MaddList(),
    );
  }
}

class _MaddList extends StatelessWidget {
  const _MaddList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pattern in PronunciationBasicsLearningData.maddPatterns)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MaddCard(pattern: pattern),
          ),
      ],
    );
  }
}

class _MaddCard extends StatelessWidget {
  const _MaddCard({required this.pattern});

  final MaddPatternGuide pattern;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.tertiary.withValues(alpha: 0.09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pattern.label,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _Badge(label: context.learnText('Sound'), value: pattern.sound),
              _Badge(label: context.learnText('Count'), value: pattern.count),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: _Line(
                  label: context.learnText('Example'),
                  value: pattern.example,
                ),
              ),
              PronunciationButton(
                arabicText: extractArabic(pattern.example),
                size: 20,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Note'), value: pattern.note),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Text(
        '$label: $value',
        style: AppTheme.text(context).labelMedium.copyWith(
          color: colorScheme.primary,
          fontWeight: AppTheme.weightBold,
        ),
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

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../pronunciation_button.dart';
import 'tajweed_learning_data.dart';
import 'tajweed_section_card.dart';

// Section 4: Qalqalah and madd timing control.
class TajweedQalqalahMaddSection extends StatelessWidget {
  const TajweedQalqalahMaddSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const TajweedSectionCard(
      title: '3) Qalqalah and Madd Control',
      subtitle:
          'Train bounce letters and vowel length discipline together for stable pronunciation quality.',
      child: _QalqalahMaddBody(),
    );
  }
}

class _QalqalahMaddBody extends StatelessWidget {
  const _QalqalahMaddBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [_QalqalahList(), SizedBox(height: 10), _MaddList()],
    );
  }
}

class _QalqalahList extends StatelessWidget {
  const _QalqalahList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.learnText('Qalqalah Focus'),
          style: AppTheme.text(
            context,
          ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: 6),
        for (final item in TajweedLearningData.qalqalah)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _QalqalahCard(item: item),
          ),
      ],
    );
  }
}

class _QalqalahCard extends StatelessWidget {
  const _QalqalahCard({required this.item});

  final TajweedQalqalahGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.letter,
                  style: AppTheme.text(context).titleSmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              PronunciationButton(
                arabicText: extractArabic(item.sample),
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Sample'), value: item.sample),
          const SizedBox(height: 3),
          _Line(label: context.learnText('When'), value: item.when),
          const SizedBox(height: 3),
          _Line(label: context.learnText('Note'), value: item.note),
        ],
      ),
    );
  }
}

class _MaddList extends StatelessWidget {
  const _MaddList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.learnText('Madd Focus'),
          style: AppTheme.text(
            context,
          ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: 6),
        for (final item in TajweedLearningData.madd)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MaddCard(item: item),
          ),
      ],
    );
  }
}

class _MaddCard extends StatelessWidget {
  const _MaddCard({required this.item});

  final TajweedMaddGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.type,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Count'), value: item.count),
          const SizedBox(height: 3),
          _Line(label: context.learnText('Example'), value: item.example),
          const SizedBox(height: 3),
          _Line(label: context.learnText('Tip'), value: item.tip),
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

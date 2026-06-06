import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 3: Grouped shape families.
class ArabicLettersShapeFamilySection extends StatelessWidget {
  const ArabicLettersShapeFamilySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArabicLettersSectionCard(
      title: '2) Grouped Shape Learning',
      subtitle:
          'Learn high-retention groups so you can decode letters quickly during reading.',
      child: _ShapeFamilyList(),
    );
  }
}

class _ShapeFamilyList extends StatelessWidget {
  const _ShapeFamilyList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final family in ArabicLettersLearningData.shapeFamilies)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _FamilyCard(family: family),
          ),
      ],
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.family});

  final LetterFamilyGuide family;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        color: colorScheme.secondary.withValues(alpha: 0.09),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            family.title,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 4),
          Text(family.goal, style: AppTheme.text(context).bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final letter in family.letters)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.compact),
                    color: Colors.white,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    letter,
                    style: AppTheme.learnArabicLetter(
                      context,
                      fontSize: AppTheme.scaledFontSize(context, 29),
                    ).copyWith(fontWeight: AppTheme.weightBold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${context.learnText('Tip')}: ${family.tip}',
            style: AppTheme.text(context).labelMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

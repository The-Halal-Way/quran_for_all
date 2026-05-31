import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'short_surah_learning_data.dart';
import 'short_surah_section_card.dart';

// Section 2: Surah objective and focus map.
class ShortSurahFocusSection extends StatelessWidget {
  const ShortSurahFocusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShortSurahSectionCard(
      title: '1) Surah Objective Map',
      subtitle:
          'Use this map to understand what each short surah should train in your recitation journey.',
      child: _SurahFocusList(),
    );
  }
}

class _SurahFocusList extends StatelessWidget {
  const _SurahFocusList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in ShortSurahLearningData.surahFocus)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SurahFocusCard(item: item),
          ),
      ],
    );
  }
}

class _SurahFocusCard extends StatelessWidget {
  const _SurahFocusCard({required this.item});

  final ShortSurahFocusGuide item;

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
            item.surah,
            style: AppTheme.text(context).titleSmall.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: 6),
          _Line(label: context.learnText('Objective'), value: item.objective),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Key theme'), value: item.keyTheme),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Recitation target'),
            value: item.recitationTarget,
          ),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Practice prompt'),
            value: item.practicePrompt,
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

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 2: Focused listening drill section.
class AudioAssistedListeningSection extends StatelessWidget {
  const AudioAssistedListeningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: '1) Focused Listening Drills',
      subtitle:
          'Train your ear before speaking so imitation and correction become easier.',
      child: _ListeningDrillList(),
    );
  }
}

class _ListeningDrillList extends StatelessWidget {
  const _ListeningDrillList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in AudioAssistedLearningData.listeningDrills)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ListeningCard(item: item),
          ),
      ],
    );
  }
}

class _ListeningCard extends StatelessWidget {
  const _ListeningCard({required this.item});

  final AudioListeningDrillGuide item;

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
            item.title,
            style: AppTheme.text(context).titleSmall.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: context.learnText('Goal'), value: item.goal),
          const SizedBox(height: 4),
          for (var i = 0; i < item.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}.', style: AppTheme.text(context).labelMedium),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.steps[i],
                      style: AppTheme.text(context).bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 3),
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

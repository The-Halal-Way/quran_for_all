import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'audio_assisted_learning_data.dart';
import 'audio_assisted_section_card.dart';

// Section 3: Shadow recitation drills.
class AudioAssistedShadowSection extends StatelessWidget {
  const AudioAssistedShadowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioAssistedSectionCard(
      title: '2) Shadow Recitation Rounds',
      subtitle:
          'Imitate audio in staged levels so your articulation and timing transfer into solo recitation.',
      child: _ShadowList(),
    );
  }
}

class _ShadowList extends StatelessWidget {
  const _ShadowList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in AudioAssistedLearningData.shadowDrills)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ShadowCard(item: item),
          ),
      ],
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard({required this.item});

  final AudioShadowDrillGuide item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.level,
            style: AppTheme.text(context).titleSmall.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: 5),
          _Line(label: context.learnText('Pacing'), value: item.pacing),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Action'), value: item.action),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Watch for'), value: item.watchFor),
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

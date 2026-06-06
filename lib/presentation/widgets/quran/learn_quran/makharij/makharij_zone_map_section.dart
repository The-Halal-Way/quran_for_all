import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../pronunciation_button.dart';
import 'makharij_learning_data.dart';
import 'makharij_section_card.dart';

class MakharijZoneMapSection extends StatelessWidget {
  const MakharijZoneMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const MakharijSectionCard(
      title: '1) Articulation Zone Map',
      subtitle:
          'Learn each makhraj zone with its letters, physical cue, and a quick corrective drill.',
      child: _ZoneList(),
    );
  }
}

class _ZoneList extends StatelessWidget {
  const _ZoneList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final zone in MakharijLearningData.zones)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ZoneCard(zone: zone),
          ),
      ],
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({required this.zone});

  final MakharijZoneGuide zone;

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
            zone.zone,
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  zone.letters,
                  style: AppTheme.text(context).titleMedium.copyWith(
                    color: colorScheme.primary,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
              PronunciationButton(
                arabicText: extractArabic(zone.letters),
                size: 20,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _Line(label: context.learnText('Location'), value: zone.locationCue),
          const SizedBox(height: 4),
          _Line(label: context.learnText('Sound cue'), value: zone.soundCue),
          const SizedBox(height: 4),
          _Line(
            label: context.learnText('Common mistake'),
            value: zone.commonMistake,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _Line(
                  label: context.learnText('Drill'),
                  value: zone.drill,
                ),
              ),
              PronunciationButton(
                arabicText: extractArabic(zone.drill),
                size: 18,
                color: colorScheme.primary,
              ),
            ],
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

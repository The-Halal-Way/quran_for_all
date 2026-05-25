import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../pronunciation_button.dart';
import 'arabic_letters_learning_data.dart';
import 'arabic_letters_section_card.dart';

// Section 5: Articulation zone practice.
class ArabicLettersArticulationSection extends StatelessWidget {
  const ArabicLettersArticulationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ArabicLettersSectionCard(
      title: '4) Beginner Pronunciation and Articulation Hints',
      subtitle:
          'These cues guide where each sound is produced. Keep tone natural and avoid over-force.',
      child: Column(
        children: [
          for (
            var i = 0;
            i < ArabicLettersLearningData.articulationZones.length;
            i++
          )
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ArticulationZoneCard(
                guide: ArabicLettersLearningData.articulationZones[i],
                icon: _zoneIcon(i),
                color: _zoneColor(i),
              ),
            ),
        ],
      ),
    );
  }

  IconData _zoneIcon(int index) {
    const icons = [
      Icons.record_voice_over_rounded,
      Icons.spatial_audio,
      Icons.hearing_rounded,
      Icons.graphic_eq_rounded,
    ];
    return icons[index % icons.length];
  }

  Color _zoneColor(int index) {
    const colors = [
      Color(0xFF7D3A23),
      Color(0xFF2E648A),
      Color(0xFF2D7C53),
      Color(0xFF8A5A1D),
    ];
    return colors[index % colors.length];
  }
}

class _ArticulationZoneCard extends StatelessWidget {
  const _ArticulationZoneCard({
    required this.guide,
    required this.icon,
    required this.color,
  });

  final ArticulationZoneGuide guide;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.text(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  guide.zone,
                  style: textTheme.titleSmall.copyWith(
                    color: color,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  guide.letters,
                  style: AppTheme.learnArabicWord(
                    context,
                    fontSize: AppTheme.scaledFontSize(context, 27),
                  ).copyWith(fontWeight: AppTheme.weightBold),
                ),
              ),
              PronunciationButton(
                arabicText: guide.letters,
                size: 20,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(guide.hint, style: textTheme.bodySmall),
          const SizedBox(height: 3),
          Text(
            '${context.learnText('Avoid')}: ${guide.watchFor}',
            style: textTheme.labelMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

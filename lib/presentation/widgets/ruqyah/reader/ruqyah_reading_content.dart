import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_progress.dart';
import '../../../../data/models/ruqyah/ruqyah_reading.dart';
import '../../../../data/models/ruqyah/ruqyah_routine.dart';
import '../../../viewmodels/ruqyah/ruqyah_audio_controller.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_sources.dart';
import '../shared/ruqyah_style.dart';
import 'ruqyah_audio_controls.dart';
import 'ruqyah_text_panel.dart';
import 'ruqyah_reading_background.dart';

class RuqyahReadingContent extends StatelessWidget {
  const RuqyahReadingContent({
    super.key,
    required this.step,
    required this.reading,
    required this.preferences,
    required this.audio,
    required this.routine,
  });
  final RuqyahStep step;
  final RuqyahReading? reading;
  final RuqyahReaderPreferences preferences;
  final RuqyahAudioController? audio;
  final RuqyahRoutine? routine;
  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final item = reading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item?.summary.title.inLanguage(language) ??
              context.l10n.ruqyahInstructions,
          style: AppTheme.text(
            context,
          ).titleLarge.copyWith(fontWeight: FontWeight.w800, height: 1.4),
        ),
        const SizedBox(height: 12),
        if (step.instruction != null) ...[
          RuqyahPanel(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  color: RuqyahStyle.accent(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.instruction!.inLanguage(language),
                    style: AppTheme.text(
                      context,
                    ).bodyLarge.copyWith(height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (item != null) ...[
          Text(
            item.context,
            style: AppTheme.text(context).bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          RuqyahTextPanel(
            label: context.l10n.ruqyahArabic,
            text: item.arabic,
            arabic: true,
            fontSize: preferences.fontSize,
          ),
          if (audio != null) ...[
            const SizedBox(height: 14),
            RuqyahAudioControls(controller: audio!),
          ],
          if (preferences.pronunciation) ...[
            const SizedBox(height: 14),
            RuqyahTextPanel(
              label: context.l10n.ruqyahPronunciation,
              text: item.pronunciation,
            ),
          ],
          if (preferences.meaning) ...[
            const SizedBox(height: 14),
            RuqyahTextPanel(
              label: context.l10n.ruqyahMeaning,
              text: item.meaning,
            ),
          ],
          const SizedBox(height: 16),
          RuqyahReadingBackground(reading: item),
        ],
        const SizedBox(height: 16),
        RuqyahPanel(
          padding: EdgeInsets.zero,
          child: ExpansionTile(
            key: PageStorageKey('ruqyah-sources-${step.id}'),
            shape: const Border(),
            collapsedShape: const Border(),
            title: Text(
              context.l10n.ruqyahSources,
              style: AppTheme.text(context).titleSmall,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            children: [
              if (routine != null && !routine!.summary.reported)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    context.l10n.ruqyahArrangementNote,
                    style: AppTheme.text(
                      context,
                    ).bodySmall.copyWith(height: 1.6),
                  ),
                ),
              RuqyahSources(
                sources:
                    [
                      ...?item?.sources,
                      if (step.countSource != null) step.countSource!,
                      if (routine?.cycleSource != null) routine!.cycleSource!,
                    ].fold(
                      [],
                      (list, source) => list.any((s) => s.url == source.url)
                          ? list
                          : [...list, source],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

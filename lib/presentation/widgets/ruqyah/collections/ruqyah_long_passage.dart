import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/ruqyah/ruqyah_audio_controller.dart';
import '../../../viewmodels/ruqyah/ruqyah_reader_viewmodel.dart';
import '../reader/ruqyah_audio_controls.dart';
import '../reader/ruqyah_text_panel.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_sources.dart';
import '../shared/ruqyah_style.dart';

class RuqyahLongPassage extends StatelessWidget {
  const RuqyahLongPassage({
    super.key,
    required this.model,
    required this.audio,
    required this.index,
  });
  final RuqyahReaderViewModel model;
  final RuqyahAudioController audio;
  final int index;
  @override
  Widget build(BuildContext context) {
    final reading = model.readingAt(index)!;
    final selected = index == model.index;
    final prefs = model.preferences;
    final saved = model.repository.store.bookmarks.contains(reading.id);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reading.summary.title.inLanguage(context.l10n.localeName),
                    style: AppTheme.text(context).titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${reading.surahNumber}:${reading.verseNumbers.first}–${reading.verseNumbers.last}',
                    style: AppTheme.text(
                      context,
                    ).labelLarge.copyWith(color: RuqyahStyle.accent(context)),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: saved
                  ? context.l10n.ruqyahUnsaveReading
                  : context.l10n.ruqyahSaveReading,
              onPressed: () {
                model.goTo(index);
                model.toggleBookmark();
              },
              icon: Icon(
                saved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RuqyahTextPanel(
          label: context.l10n.ruqyahArabic,
          text: reading.numberedArabic,
          arabic: true,
          fontSize: prefs.fontSize,
        ),
        const SizedBox(height: 12),
        if (selected)
          RuqyahAudioControls(controller: audio)
        else
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => model.goTo(index),
              icon: const Icon(Icons.headphones_rounded, size: 19),
              label: Text(context.l10n.ruqyahAudio),
            ),
          ),
        if (prefs.pronunciation || prefs.meaning) ...[
          const SizedBox(height: 8),
          RuqyahPanel(
            padding: EdgeInsets.zero,
            child: ExpansionTile(
              key: PageStorageKey('collection-translation-${reading.id}'),
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                prefs.pronunciation && prefs.meaning
                    ? context.l10n.ruqyahPronunciationMeaning
                    : prefs.pronunciation
                    ? context.l10n.ruqyahPronunciation
                    : context.l10n.ruqyahMeaning,
                style: AppTheme.text(context).titleSmall,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: [
                if (prefs.pronunciation)
                  RuqyahTextPanel(
                    label: context.l10n.ruqyahPronunciation,
                    text: reading.pronunciation,
                  ),
                if (prefs.pronunciation && prefs.meaning)
                  const SizedBox(height: 12),
                if (prefs.meaning)
                  RuqyahTextPanel(
                    label: context.l10n.ruqyahMeaning,
                    text: reading.meaning,
                  ),
              ],
            ),
          ),
        ],
        ExpansionTile(
          key: PageStorageKey('collection-context-${reading.id}'),
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: EdgeInsets.zero,
          title: Text(
            context.l10n.ruqyahSources,
            style: AppTheme.text(context).labelLarge,
          ),
          children: [
            Text(
              reading.details.background,
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.6),
            ),
            RuqyahSources(sources: reading.sources),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: model.completed.contains(index)
                ? null
                : () => model.markRead(index),
            icon: Icon(
              model.completed.contains(index)
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              size: 18,
            ),
            label: Text(
              model.completed.contains(index)
                  ? context.l10n.ruqyahPassageRead
                  : context.l10n.ruqyahMarkPassageRead,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Divider(color: scheme.outlineVariant),
        ),
      ],
    );
  }
}

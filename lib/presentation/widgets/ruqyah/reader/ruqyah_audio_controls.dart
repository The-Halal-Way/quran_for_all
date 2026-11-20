import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/ruqyah/ruqyah_audio_controller.dart';
import '../shared/ruqyah_panel.dart';
import '../shared/ruqyah_style.dart';

class RuqyahAudioControls extends StatelessWidget {
  const RuqyahAudioControls({super.key, required this.controller});
  final RuqyahAudioController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final audio = controller;
      final accent = RuqyahStyle.accent(context);
      if (audio.verses.isEmpty) {
        return RuqyahPanel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.headphones_outlined, color: accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.ruqyahAudioPending,
                  style: AppTheme.text(context).bodySmall.copyWith(height: 1.5),
                ),
              ),
            ],
          ),
        );
      }
      final max = audio.duration.inMilliseconds.toDouble();
      return RuqyahPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.ruqyahAudio,
              style: AppTheme.text(
                context,
              ).titleSmall.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.ruqyahReciter,
              style: AppTheme.text(context).bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: context.l10n.ruqyahPrevious,
                  onPressed: audio.verseIndex > 0 && !audio.busy
                      ? () => audio.moveVerse(-1)
                      : null,
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
                FilledButton.tonal(
                  onPressed: audio.busy ? null : audio.toggle,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(72, 48),
                  ),
                  child: audio.busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          audio.playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          semanticLabel: audio.playing
                              ? context.l10n.ruqyahPause
                              : context.l10n.ruqyahPlay,
                          size: 30,
                        ),
                ),
                IconButton(
                  tooltip: context.l10n.ruqyahNext,
                  onPressed:
                      audio.verseIndex + 1 < audio.verses.length && !audio.busy
                      ? () => audio.moveVerse(1)
                      : null,
                  icon: const Icon(Icons.skip_next_rounded),
                ),
                IconButton(
                  tooltip: context.l10n.ruqyahRepeat,
                  isSelected: audio.repeat,
                  onPressed: audio.toggleRepeat,
                  selectedIcon: Icon(Icons.repeat_rounded, color: accent),
                  icon: const Icon(Icons.repeat_rounded),
                ),
              ],
            ),
            if (audio.verses.length > 1)
              Center(
                child: Text(
                  context.l10n.ruqyahVerse(
                    RuqyahStyle.number(context, audio.verseIndex + 1),
                    RuqyahStyle.number(context, audio.verses.length),
                  ),
                  style: AppTheme.text(context).labelSmall,
                ),
              ),
            if (max > 0)
              Slider(
                value: audio.position.inMilliseconds.toDouble().clamp(0, max),
                max: max,
                onChanged: audio.seek,
                semanticFormatterCallback: (value) =>
                    '${(value / 1000).round()} s',
              ),
            if (audio.downloading) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: audio.downloadProgress.clamp(0, 1),
                color: accent,
              ),
              const SizedBox(height: 4),
              Text(
                '${RuqyahStyle.number(context, (audio.downloadProgress * 100).round())}%',
                style: AppTheme.text(context).labelSmall,
              ),
            ] else
              TextButton.icon(
                onPressed: audio.downloaded ? null : audio.download,
                icon: Icon(
                  audio.downloaded
                      ? Icons.offline_pin_rounded
                      : Icons.download_rounded,
                  size: 18,
                ),
                label: Text(
                  audio.downloaded
                      ? context.l10n.ruqyahDownloaded
                      : context.l10n.ruqyahDownload,
                ),
              ),
            if (audio.failed)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  context.l10n.ruqyahAudioError,
                  style: AppTheme.text(context).bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            Text(
              context.l10n.ruqyahAudioNote,
              style: AppTheme.text(context).labelSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    },
  );
}

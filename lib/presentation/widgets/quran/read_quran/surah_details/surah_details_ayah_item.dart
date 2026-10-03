import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/app_language.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../data/models/ayah_model.dart';
import '../../../../viewmodels/audio_control_viewmodel.dart';
import '../../../ayah_tile.dart';

class SurahDetailsAyahItem extends StatelessWidget {
  const SurahDetailsAyahItem({
    super.key,
    required this.ayah,
    required this.language,
    required this.showPronunciation,
    required this.showTranslation,
    required this.isBookmarked,
    required this.isLastReadAyah,
    required this.isPlaying,
    required this.isHighlighted,
    required this.onPlay,
    required this.onToggleBookmark,
    required this.onMarkAsLastRead,
    required this.loadAdditionalTranslation,
  });

  final AyahModel ayah;
  final AppLanguage language;
  final bool showPronunciation;
  final bool showTranslation;
  final bool isBookmarked;
  final bool isLastReadAyah;
  final bool isPlaying;
  final bool isHighlighted;
  final VoidCallback onPlay;
  final VoidCallback onToggleBookmark;
  final VoidCallback onMarkAsLastRead;
  final Future<AyahTranslation?> Function() loadAdditionalTranslation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final showHighlight = isPlaying || isHighlighted;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isPlaying
              ? scheme.secondary.withValues(alpha: 0.12)
              : (isHighlighted ? scheme.primary.withValues(alpha: 0.08) : null),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: showHighlight
              ? Border.all(
                  color: isPlaying
                      ? scheme.secondary.withValues(alpha: 0.58)
                      : scheme.primary.withValues(alpha: 0.42),
                  width: isPlaying ? 1.4 : 1.2,
                )
              : null,
        ),
        // Position events only rebuild the playing ayah, not the scroll list.
        child: isPlaying
            ? Consumer<AudioControlViewModel>(
                builder: (context, audio, _) => _buildTile(
                  progress: audio.progress,
                  position: audio.position,
                  duration: audio.duration,
                ),
              )
            : _buildTile(),
      ),
    );
  }

  Widget _buildTile({
    double progress = 0,
    Duration position = Duration.zero,
    Duration duration = Duration.zero,
  }) => AyahTile(
    ayah: ayah,
    showPronunciation: showPronunciation,
    showTranslation: showTranslation,
    language: language,
    isBookmarked: isBookmarked,
    isLastReadAyah: isLastReadAyah,
    isPlaying: isPlaying,
    playbackProgress: progress,
    playbackPosition: position,
    playbackDuration: duration,
    onPlay: onPlay,
    onToggleBookmark: onToggleBookmark,
    onMarkAsLastRead: onMarkAsLastRead,
    loadAdditionalTranslation: loadAdditionalTranslation,
  );
}

import 'package:flutter/material.dart';

import '../../core/enums/app_language.dart';
import '../../core/localization/l10n_extensions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_responsive.dart';
import '../../data/models/ayah_model.dart';

class AyahTile extends StatelessWidget {
  static const double _earlyHighlightPercent = 0.14;
  static const double _minEarlySeconds = 1.0;
  static const double _maxEarlySeconds = 6.0;

  const AyahTile({
    super.key,
    required this.ayah,
    required this.showPronunciation,
    required this.showTranslation,
    required this.language,
    required this.isBookmarked,
    required this.isLastReadAyah,
    required this.isPlaying,
    required this.playbackProgress,
    required this.playbackPosition,
    required this.playbackDuration,
    required this.onPlay,
    required this.onToggleBookmark,
    this.onMarkAsLastRead,
  });

  final AyahModel ayah;
  final bool showPronunciation;
  final bool showTranslation;
  final AppLanguage language;
  final bool isBookmarked;
  final bool isLastReadAyah;
  final bool isPlaying;
  final double playbackProgress;
  final Duration playbackPosition;
  final Duration playbackDuration;
  final VoidCallback onPlay;
  final VoidCallback onToggleBookmark;
  final VoidCallback? onMarkAsLastRead;

  void _showTafsirSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _TafsirBottomSheet(ayah: ayah, tafsir: ayah.tafsirFor(language));
      },
    );
  }

  Widget _buildTafsirButton(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: () => _showTafsirSheet(context),
      icon: const Icon(Icons.auto_stories_rounded, size: 18),
      label: Text(context.readQuranText('Tafsir')),
      style: FilledButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.xs + 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transliteration = ayah.transliterationFor(language);
    final translation = language == AppLanguage.bangla
        ? ayah.translationBn
        : ayah.translationEn;
    final translationLabel = language == AppLanguage.bangla ? 'BN' : 'EN';
    final colorScheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);

    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 420;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isCompact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ayah number and Juz info
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs + 1,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.16,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Text(
                              '${ayah.surahId}:${ayah.ayahNumber}',
                              style: AppTheme.text(context).labelSmall.copyWith(
                                color: colorScheme.primary,
                                fontWeight: AppTheme.weightBlack,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs + 1,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Text(
                              'Juz ${ayah.juzNumber}',
                              style: AppTheme.text(context).labelSmall.copyWith(
                                color: colorScheme.primary,
                                fontWeight: AppTheme.weightBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // bookmark, play, and last read buttons
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          _buildTafsirButton(context),
                          IconButton(
                            onPressed: onToggleBookmark,
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_add_outlined,
                            ),
                            tooltip: isBookmarked
                                ? context.readQuranText('Remove ayah bookmark')
                                : context.readQuranText('Save ayah bookmark'),
                          ),
                          IconButton(
                            onPressed: onMarkAsLastRead,
                            icon: Icon(
                              isLastReadAyah
                                  ? Icons.history_toggle_off_rounded
                                  : Icons.history_edu_rounded,
                            ),
                            style: isLastReadAyah
                                ? IconButton.styleFrom(
                                    backgroundColor: colorScheme.primary
                                        .withValues(alpha: 0.16),
                                    foregroundColor: colorScheme.primary,
                                  )
                                : null,
                            tooltip: context.readQuranText(
                              isLastReadAyah
                                  ? 'Current last read ayah'
                                  : 'Mark ayah as last read',
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: onPlay,
                            icon: Icon(
                              isPlaying
                                  ? Icons.stop_circle_rounded
                                  : Icons.play_circle_fill_rounded,
                            ),
                            tooltip: context.readQuranText(
                              isPlaying ? 'Stop ayah audio' : 'Play ayah audio',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      // Ayah number and Juz info
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm + 2,
                          vertical: AppSpacing.sm - 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '${ayah.surahId}:${ayah.ayahNumber}',
                          style: text.labelMedium.copyWith(
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs + 1,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          'Juz ${ayah.juzNumber}',
                          style: AppTheme.text(context).labelSmall.copyWith(
                            color: colorScheme.primary,
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildTafsirButton(context),
                      IconButton(
                        onPressed: onToggleBookmark,
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_add_outlined,
                        ),
                        tooltip: isBookmarked
                            ? context.readQuranText('Remove ayah bookmark')
                            : context.readQuranText('Save ayah bookmark'),
                      ),
                      IconButton(
                        onPressed: onMarkAsLastRead,
                        icon: Icon(
                          isLastReadAyah
                              ? Icons.history_toggle_off_rounded
                              : Icons.history_edu_rounded,
                        ),
                        style: isLastReadAyah
                            ? IconButton.styleFrom(
                                backgroundColor: colorScheme.primary.withValues(
                                  alpha: 0.16,
                                ),
                                foregroundColor: colorScheme.primary,
                              )
                            : null,
                        tooltip: context.readQuranText(
                          isLastReadAyah
                              ? 'Current last read ayah'
                              : 'Mark ayah as last read',
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: onPlay,
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_circle_rounded
                              : Icons.play_circle_fill_rounded,
                        ),
                        tooltip: context.readQuranText(
                          isPlaying ? 'Stop ayah audio' : 'Play ayah audio',
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.sm + 2),
                _buildArabicText(context),
                if (showPronunciation && transliteration.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    transliteration,
                    style: AppTheme.text(context).bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ],
                if (showTranslation && translation.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _TranslationLine(label: translationLabel, text: translation),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildArabicText(BuildContext context) {
    final baseStyle = AppTheme.quranArabic(context);

    if (!isPlaying || playbackProgress <= 0) {
      return Text(
        ayah.arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: baseStyle,
      );
    }

    final graphemes = ayah.arabicText.characters.toList();
    if (graphemes.isEmpty) {
      return Text(
        ayah.arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: baseStyle,
      );
    }

    final total = graphemes.length;
    final clamped = playbackProgress.clamp(0.0, 1.0);
    final durationMs = playbackDuration.inMilliseconds;
    final positionMs = playbackPosition.inMilliseconds;

    final acceleratedProgress = durationMs > 0
        ? () {
            final durationSeconds = durationMs / 1000.0;
            final earlySeconds = (durationSeconds * _earlyHighlightPercent)
                .clamp(_minEarlySeconds, _maxEarlySeconds);
            final effectiveDurationMs =
                ((durationSeconds - earlySeconds).clamp(0.25, durationSeconds) *
                        1000)
                    .toDouble();
            final clampedPosition = positionMs.clamp(0, durationMs);
            return (clampedPosition / effectiveDurationMs).clamp(0.0, 1.0);
          }()
        : (clamped * 1.35).clamp(0.0, 1.0);

    // Highlight completes 1-2 seconds early, but remains visible until
    // playback ends because this widget paints highlight only while isPlaying.
    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: acceleratedProgress),
      builder: (context, animatedProgress, _) {
        final highlightCount = (total * animatedProgress).ceil().clamp(
          0,
          total,
        );
        final highlighted = graphemes.take(highlightCount).join();
        final remaining = graphemes.skip(highlightCount).join();

        return RichText(
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(
                text: highlighted,
                style: baseStyle.copyWith(
                  backgroundColor: colorScheme.secondary.withValues(
                    alpha: 0.28,
                  ),
                ),
              ),
              TextSpan(text: remaining, style: baseStyle),
            ],
          ),
        );
      },
    );
  }
}

class _TranslationLine extends StatelessWidget {
  const _TranslationLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final appText = AppTheme.text(context);
    final labelFontSize = responsive.pick(
      mobile: 11,
      tablet: 10.5,
      desktop: 11.2,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: AppSpacing.xs),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs - 1,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            label,
            style: appText.labelMedium.copyWith(
              color: colorScheme.primary,
              fontSize: AppTheme.scaledFontSize(context, labelFontSize),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: Text(text, style: appText.bodyMedium.copyWith(height: 1.45)),
        ),
      ],
    );
  }
}

class _TafsirBottomSheet extends StatelessWidget {
  const _TafsirBottomSheet({required this.ayah, required this.tafsir});

  final AyahModel ayah;
  final String tafsir;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .4,
      minChildSize: 0.3,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            media.viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.readQuranText('Tafsir'),
                style: AppTheme.text(
                  context,
                ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${context.readQuranText('Surah')} ${ayah.surahId}:${ayah.ayahNumber}',
                style: AppTheme.text(context).labelLarge.copyWith(
                  color: colorScheme.primary,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: tafsir.trim().isEmpty
                    ? Center(
                        child: Text(
                          context.readQuranText(
                            'No tafsir available for this ayah yet.',
                          ),
                          textAlign: TextAlign.center,
                          style: AppTheme.text(context).bodyMedium,
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        children: [
                          SelectableText(
                            tafsir,
                            style: AppTheme.text(
                              context,
                            ).bodyMedium.copyWith(height: 1.5),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

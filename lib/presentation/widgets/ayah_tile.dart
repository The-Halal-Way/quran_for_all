import 'package:flutter/material.dart';

import '../../core/enums/app_language.dart';
import '../../core/localization/l10n_extensions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_responsive.dart';
import '../../data/models/ayah_model.dart';

class AyahTile extends StatelessWidget {
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
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w900,
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
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
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
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    final baseStyle = AppTextStyles.quranArabic(context);

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
    final highlightCount = (total * clamped).ceil().clamp(0, total);

    final highlighted = graphemes.take(highlightCount).join();
    final remaining = graphemes.skip(highlightCount).join();
    final colorScheme = Theme.of(context).colorScheme;

    return RichText(
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: highlighted,
            style: baseStyle.copyWith(
              backgroundColor: colorScheme.secondary.withValues(alpha: 0.28),
            ),
          ),
          TextSpan(text: remaining, style: baseStyle),
        ],
      ),
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
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: labelFontSize,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
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
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${context.readQuranText('Surah')} ${ayah.surahId}:${ayah.ayahNumber}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        children: [
                          SelectableText(
                            tafsir,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.5),
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

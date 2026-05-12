import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/enums/app_language.dart';
import '../../core/localization/l10n_extensions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/ayah_model.dart';

class AyahTile extends StatelessWidget {
  const AyahTile({
    super.key,
    required this.ayah,
    required this.showPronunciation,
    required this.showTranslation,
    required this.language,
    required this.isBookmarked,
    required this.onPlay,
    required this.onToggleBookmark,
    this.onMarkAsLastRead,
  });

  final AyahModel ayah;
  final bool showPronunciation;
  final bool showTranslation;
  final AppLanguage language;
  final bool isBookmarked;
  final VoidCallback onPlay;
  final VoidCallback onToggleBookmark;
  final VoidCallback? onMarkAsLastRead;

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
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm + 2,
                              vertical: AppSpacing.sm - 2,
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
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSecondary,
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
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          IconButton(
                            onPressed: onToggleBookmark,
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_add_outlined,
                            ),
                            tooltip: isBookmarked
                                ? context.readQuranText(
                                    'Remove ayah bookmark',
                                  )
                                : context.readQuranText('Save ayah bookmark'),
                          ),
                          IconButton(
                            onPressed: onMarkAsLastRead,
                            icon: const Icon(Icons.history_edu_rounded),
                            tooltip: context.readQuranText(
                              'Mark ayah as last read',
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: onPlay,
                            icon: const Icon(Icons.play_circle_fill_rounded),
                            tooltip: 'Play ayah audio',
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
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
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
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
                        icon: const Icon(Icons.history_edu_rounded),
                        tooltip: context.readQuranText('Mark ayah as last read'),
                      ),
                      IconButton.filledTonal(
                        onPressed: onPlay,
                        icon: const Icon(Icons.play_circle_fill_rounded),
                        tooltip: 'Play ayah audio',
                      ),
                    ],
                  ),
            const SizedBox(height: AppSpacing.sm + 2),
            Text(
              ayah.arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.quranArabic(context),
            ),
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
}

class _TranslationLine extends StatelessWidget {
  const _TranslationLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
              fontSize: 11.sp.clamp(10.5, 12.0),
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

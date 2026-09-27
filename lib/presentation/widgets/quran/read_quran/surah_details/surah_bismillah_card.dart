import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enums/app_language.dart';
import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/surah_opening_model.dart';

class SurahBismillahCard extends StatelessWidget {
  const SurahBismillahCard({
    super.key,
    required this.opening,
    required this.language,
    required this.showPronunciation,
    required this.showTranslation,
    required this.isPlaying,
    required this.playbackProgress,
    required this.onPlay,
  });

  final SurahOpeningModel opening;
  final AppLanguage language;
  final bool showPronunciation;
  final bool showTranslation;
  final bool isPlaying;
  final double playbackProgress;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final ayah = opening.source;
    final pronunciation = ayah.transliterationFor(language);
    final translation = language == AppLanguage.bangla
        ? ayah.translationBn
        : ayah.translationEn;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withValues(alpha: isPlaying ? 0.16 : 0.08),
              scheme.secondary.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isPlaying
                ? scheme.secondary
                : scheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.readQuranBismillahTitle,
                    style: text.labelLarge.copyWith(
                      color: scheme.onSurface,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: onPlay,
                  tooltip: isPlaying
                      ? context.l10n.readQuranStopBismillahAudio
                      : context.l10n.readQuranPlayBismillahAudio,
                  icon: Icon(
                    isPlaying
                        ? CupertinoIcons.stop_fill
                        : CupertinoIcons.play_fill,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              ayah.arabicText,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: AppTheme.quranArabic(
                context,
              ).copyWith(color: scheme.onSurface),
            ),
            if (showPronunciation && pronunciation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                pronunciation,
                textAlign: TextAlign.center,
                style: text.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (showTranslation && translation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                translation,
                textAlign: TextAlign.center,
                style: text.bodyMedium,
              ),
            ],
            if (isPlaying) ...[
              const SizedBox(height: AppSpacing.md),
              LinearProgressIndicator(
                value: playbackProgress.clamp(0.0, 1.0),
                color: scheme.secondary,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

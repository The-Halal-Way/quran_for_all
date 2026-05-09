import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/surah_model.dart';
import '../../common/app_pill.dart';

class SurahMetaCard extends StatelessWidget {
  const SurahMetaCard({
    super.key,
    required this.surah,
    required this.isPlayingFullSurah,
    required this.onTogglePlayback,
  });

  final SurahModel surah;
  final bool isPlayingFullSurah;
  final VoidCallback onTogglePlayback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl - 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            surah.nameArabic,
            textAlign: TextAlign.center,
            style: AppTextStyles.surahArabicName(context),
          ),
          const SizedBox(height: AppSpacing.xs + 1),
          Text(
            surah.nameEnglish,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 1),
          Text(
            surah.nameTranslated,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.lg - 2),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            children: [
              AppPill.overlay(
                icon: Icons.layers_outlined,
                label: '${surah.totalAyahs} ${context.readQuranText('ayahs')}',
              ),
              AppPill.overlay(
                icon: Icons.public_rounded,
                label: context.readQuranText(surah.revelationType),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg - 2),
          FilledButton.tonalIcon(
            onPressed: onTogglePlayback,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colorScheme.primary,
            ),
            icon: Icon(
              isPlayingFullSurah
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_fill_rounded,
            ),
            label: Text(
              context.readQuranText(
                isPlayingFullSurah ? 'Stop Surah Audio' : 'Play Full Surah',
              ),
            ),
          ),
        ],
      ),
    );
  }
}



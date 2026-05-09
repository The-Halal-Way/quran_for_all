import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/surah_model.dart';
import '../../common/app_pill.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({super.key, required this.surah, required this.onTap});

  final SurahModel surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.22),
                      AppColors.tertiary.withValues(alpha: 0.16),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    surah.id.toString(),
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            surah.nameEnglish,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AppPill.surface(
                          icon: Icons.layers_rounded,
                          label:
                              '${surah.totalAyahs} ${context.readQuranText('ayahs')}',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      surah.nameTranslated,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm + 2),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: 6,
                      children: [
                        AppPill.surface(
                          label: context.readQuranText(surah.revelationType),
                          icon: Icons.public_rounded,
                          backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
                          borderColor: colorScheme.outline.withValues(alpha: 0.35),
                        ),
                        AppPill.surface(
                          label: surah.nameArabic,
                          backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
                          borderColor: colorScheme.outline.withValues(alpha: 0.35),
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

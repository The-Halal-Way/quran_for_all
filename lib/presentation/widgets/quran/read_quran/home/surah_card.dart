import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../../../../core/localization/surah_name_localizer.dart';
import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../data/models/surah_model.dart';
import '../../../../viewmodels/settings_viewmodel.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    required this.isBookmarked,
    required this.onToggleBookmark,
  });

  final SurahModel surah;
  final VoidCallback onTap;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTheme.text(context);
    final language = context.watch<SettingsViewModel>().settings.language;
    final localizedTitle = surah.localizedTitle(context, language);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.18),
                      colorScheme.tertiary.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.18),
                  ),
                ),
                child: Center(
                  child: Text(
                    surah.id.toString(),
                    style: textTheme.labelLarge.copyWith(
                      color: colorScheme.primary,
                      fontWeight: AppTheme.weightExtraBold,
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
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            localizedTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium.copyWith(
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          flex: 2,
                          child: Text(
                            surah.nameArabic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: textTheme.titleMedium.copyWith(
                              color: colorScheme.primary,
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${context.readQuranText(surah.nameTranslated)} · '
                      '${_localizedRevelationType(context)} · '
                      '${surah.totalAyahs} ${context.l10n.readQuranAyahsLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                onPressed: onToggleBookmark,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_add_outlined,
                  color: isBookmarked
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                tooltip: isBookmarked
                    ? context.l10n.readQuranRemoveSurahBookmarkTooltip
                    : context.l10n.readQuranSaveSurahBookmarkTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizedRevelationType(BuildContext context) {
    return switch (surah.revelationType) {
      'Meccan' => context.l10n.readQuranMeccan,
      'Medinan' => context.l10n.readQuranMedinan,
      _ => context.readQuranText(surah.revelationType),
    };
  }
}

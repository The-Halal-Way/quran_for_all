import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/enums/app_language.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/search_result_model.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
    required this.translationLanguage,
  });

  final SearchResultModel result;
  final VoidCallback onTap;
  final AppLanguage translationLanguage;

  String _subtitleText() {
    if (result.ayah == null) {
      return result.subtitle;
    }

    var subtitle = translationLanguage == AppLanguage.bangla
        ? result.ayah!.translationBn
        : result.ayah!.translationEn;

    subtitle = subtitle.replaceAll(RegExp(r'\s+'), ' ').trim();
    return subtitle;
  }

  String _titleText() {
    if (result.type == SearchResultType.surah && result.surah != null) {
      return result.title;
    }

    return result.title;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final leadingSize = responsive.pick(mobile: 40, tablet: 36, desktop: 42);
    final trailingIconSize = responsive.pick(
      mobile: 19,
      tablet: 17.5,
      desktop: 19.5,
    );

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg - 2,
            AppSpacing.md,
            AppSpacing.lg - 2,
            AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: leadingSize,
                height: leadingSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  result.type == SearchResultType.surah
                      ? Icons.menu_book_rounded
                      : Icons.format_quote_rounded,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.type == SearchResultType.surah &&
                              result.surah != null
                          ? '${result.surah!.id}. ${result.surah!.localizedTitle(context, translationLanguage)}'
                          : _titleText(),
                      style: AppTheme.text(
                        context,
                      ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
                    ),
                    const SizedBox(height: AppSpacing.xs + 1),
                    Text(
                      _subtitleText(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.text(context).bodyMedium.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.76),
                      ),
                    ),
                    if (result.ayah != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Chip(
                        avatar: const Icon(Icons.place_outlined, size: 16),
                        label: Text(
                          '${context.l10n.readQuranAyahLabel} ${result.ayah!.surahId}:${result.ayah!.ayahNumber}',
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm - 2),
              Icon(
                Icons.north_east_rounded,
                color: colorScheme.primary,
                size: trailingIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

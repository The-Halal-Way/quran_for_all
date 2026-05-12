import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/enums/app_language.dart';
import '../../../../core/theme/app_spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg - 2, AppSpacing.md, AppSpacing.lg - 2, AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w.clamp(36.0, 44.0),
                height: 40.w.clamp(36.0, 44.0),
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
                      result.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs + 1),
                    Text(
                      _subtitleText(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.76),
                      ),
                    ),
                    if (result.ayah != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Chip(
                        avatar: const Icon(Icons.place_outlined, size: 16),
                        label: Text(
                          '${context.readQuranText('Ayah')} ${result.ayah!.surahId}:${result.ayah!.ayahNumber}',
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
                size: 19.sp.clamp(17.0, 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

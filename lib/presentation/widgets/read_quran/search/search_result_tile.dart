import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/enums/app_language.dart';
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
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  result.type == SearchResultType.surah
                      ? Icons.menu_book_rounded
                      : Icons.format_quote_rounded,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
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
                    const SizedBox(height: 5),
                    Text(
                      _subtitleText(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.76),
                      ),
                    ),
                    if (result.ayah != null) ...[
                      const SizedBox(height: 8),
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
              const SizedBox(width: 6),
              Icon(
                Icons.north_east_rounded,
                color: colorScheme.primary,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

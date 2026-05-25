import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/ayah_model.dart';
import '../../../../data/models/bookmark_model.dart';
import '../../../../data/models/surah_model.dart';

class BookmarkListTile extends StatelessWidget {
  const BookmarkListTile({
    super.key,
    required this.bookmark,
    required this.surah,
    required this.ayah,
    required this.language,
    required this.onTap,
  });

  final BookmarkModel bookmark;
  final SurahModel? surah;
  final AyahModel? ayah;
  final AppLanguage language;
  final VoidCallback onTap;

  bool get _isAyahBookmark => bookmark.type == BookmarkType.ayah;

  String _title(BuildContext context) {
    if (_isAyahBookmark) {
      return '${context.readQuranText('Ayah')} ${bookmark.surahId}:${bookmark.ayahNumber ?? ''}';
    }

    final localizedName = surah?.localizedTitle(context, language).trim() ?? '';
    if (localizedName.isNotEmpty) {
      return '${bookmark.surahId}. $localizedName';
    }

    return '${context.readQuranText('Surah')} ${bookmark.surahId}';
  }

  String _subtitle(BuildContext context) {
    if (_isAyahBookmark) {
      final ayahTranslation = language == AppLanguage.bangla
          ? ayah?.translationBn
          : ayah?.translationEn;
      final compact = _compactText(ayahTranslation ?? '');
      if (compact.isNotEmpty) {
        return compact;
      }

      final surahName = surah?.localizedTitle(context, language).trim() ?? '';
      if (surahName.isNotEmpty) {
        return '${context.readQuranText('Surah')}: $surahName';
      }

      return '${context.readQuranText('Surah')} ${bookmark.surahId}';
    }

    final translated = context.readQuranText(
      surah?.nameTranslated.trim() ?? '',
    );
    final arabic = surah?.nameArabic.trim() ?? '';

    if (translated.isNotEmpty && arabic.isNotEmpty) {
      return '$translated • $arabic';
    }
    if (translated.isNotEmpty) {
      return translated;
    }
    if (arabic.isNotEmpty) {
      return arabic;
    }

    return context.readQuranText('Saved bookmark');
  }

  String _typeLabel(BuildContext context) {
    if (_isAyahBookmark) {
      return context.readQuranText('Ayah');
    }

    return context.readQuranText('Surah');
  }

  IconData _typeIcon() {
    if (_isAyahBookmark) {
      return Icons.format_quote_rounded;
    }

    return Icons.menu_book_rounded;
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 420;

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
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
                    child: Icon(_typeIcon(), color: colorScheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (compact)
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                _title(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.text(context).titleMedium
                                    .copyWith(fontWeight: AppTheme.weightBold),
                              ),
                              Chip(
                                visualDensity: VisualDensity.compact,
                                avatar: Icon(_typeIcon(), size: 14),
                                label: Text(_typeLabel(context)),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _title(context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.text(context).titleMedium
                                      .copyWith(
                                        fontWeight: AppTheme.weightBold,
                                      ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Chip(
                                visualDensity: VisualDensity.compact,
                                avatar: Icon(_typeIcon(), size: 14),
                                label: Text(_typeLabel(context)),
                              ),
                            ],
                          ),
                        const SizedBox(height: AppSpacing.xs + 1),
                        Text(
                          _subtitle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).bodyMedium.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.76,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.north_east_rounded,
                    color: colorScheme.primary,
                    size: trailingIconSize,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _compactText(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

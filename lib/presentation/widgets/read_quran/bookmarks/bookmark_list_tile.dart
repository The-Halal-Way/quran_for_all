import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
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

    final englishName = surah?.nameEnglish.trim() ?? '';
    if (englishName.isNotEmpty) {
      return '${bookmark.surahId}. $englishName';
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

      final surahName = surah?.nameEnglish.trim() ?? '';
      if (surahName.isNotEmpty) {
        return '${context.readQuranText('Surah')}: $surahName';
      }

      return '${context.readQuranText('Surah')} ${bookmark.surahId}';
    }

    final translated = surah?.nameTranslated.trim() ?? '';
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
                width: 40.w.clamp(36.0, 44.0),
                height: 40.w.clamp(36.0, 44.0),
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.76),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.north_east_rounded,
                color: colorScheme.primary,
                size: 19.sp.clamp(17.0, 20.0),
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

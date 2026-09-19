import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/presentation/widgets/empty_state.dart';

class SurahDetailsSearchButton extends StatelessWidget {
  const SurahDetailsSearchButton({
    super.key,
    required this.ayahs,
    required this.language,
    required this.onJumpToAyah,
  });

  final List<AyahModel> ayahs;
  final AppLanguage language;
  final ValueChanged<int> onJumpToAyah;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openSurahSearchSheet(context),
      icon: const Icon(CupertinoIcons.search, size: 21),
      color: Colors.white,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.13),
      ),
    );
  }

  void _openSurahSearchSheet(BuildContext context) {
    var query = '';
    var results = const <AyahModel>[];

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) {
          final colorScheme = Theme.of(sheetContext).colorScheme;

          return StatefulBuilder(
            builder: (sheetContext, setSheetState) {
              final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    bottomInset + AppSpacing.md,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(sheetContext).size.height * 0.72,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.readQuranSearchInsideSurahTitle,
                          style: AppTheme.text(sheetContext).titleMedium
                              .copyWith(fontWeight: AppTheme.weightBold),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText:
                                context.l10n.readQuranSearchInsideSurahHint,
                            prefixIcon: const Icon(CupertinoIcons.search),
                          ),
                          onChanged: (value) {
                            setSheetState(() {
                              query = value.trim();
                              results = _searchSurahAyahs(
                                ayahs: ayahs,
                                query: query,
                                language: language,
                              );
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          query.isEmpty
                              ? context.l10n.readQuranStartTypingSurahSearch
                              : context.l10n.readQuranResultsCount(
                                  results.length,
                                ),
                          style: AppTheme.text(sheetContext).bodySmall.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: query.isEmpty
                              ? EmptyState(
                                  icon: CupertinoIcons.doc_text_search,
                                  title: context.l10n.readQuranSearchAyahsTitle,
                                  message:
                                      context.l10n.readQuranSearchAyahsBody,
                                )
                              : results.isEmpty
                              ? EmptyState(
                                  icon: CupertinoIcons.search_circle,
                                  title: context.l10n.readQuranNoResultsTitle,
                                  message: context.l10n.readQuranNoResultsBody,
                                )
                              : ListView.separated(
                                  itemCount: results.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: AppSpacing.sm),
                                  itemBuilder: (itemContext, index) {
                                    final ayah = results[index];
                                    final preview =
                                        language == AppLanguage.bangla
                                        ? ayah.translationBn
                                        : ayah.translationEn;

                                    return Card(
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.md,
                                              vertical: AppSpacing.xs,
                                            ),
                                        title: Text(
                                          '${context.l10n.readQuranAyahLabel} ${ayah.ayahNumber}',
                                          style: AppTheme.text(itemContext)
                                              .titleSmall
                                              .copyWith(
                                                fontWeight: AppTheme.weightBold,
                                              ),
                                        ),
                                        subtitle: Text(
                                          preview.replaceAll(
                                            RegExp(r'\s+'),
                                            ' ',
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Icon(
                                          CupertinoIcons.arrow_down_circle,
                                          color: colorScheme.primary,
                                        ),
                                        onTap: () {
                                          Navigator.of(sheetContext).pop();
                                          onJumpToAyah(ayah.ayahNumber);
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<AyahModel> _searchSurahAyahs({
    required List<AyahModel> ayahs,
    required String query,
    required AppLanguage language,
  }) {
    final normalizedQuery = _normalizeSearchText(query);
    if (normalizedQuery.isEmpty) {
      return const <AyahModel>[];
    }

    return ayahs
        .where((ayah) {
          final translation = language == AppLanguage.bangla
              ? ayah.translationBn
              : ayah.translationEn;
          final candidates = <String>[
            ayah.ayahNumber.toString(),
            ayah.arabicText,
            translation,
            ayah.transliterationFor(language),
          ];

          return candidates.any((value) {
            return _normalizeSearchText(value).contains(normalizedQuery);
          });
        })
        .take(80)
        .toList(growable: false);
  }

  String _normalizeSearchText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

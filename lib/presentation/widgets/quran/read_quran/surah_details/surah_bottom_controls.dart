import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';

import '../../../../../../core/localization/l10n_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../empty_state.dart';

class SurahBottomControls extends StatelessWidget {
  const SurahBottomControls({
    super.key,
    required this.readingViewMode,
    required this.showPronunciation,
    required this.showTranslation,
    required this.isPlayingFullSurah,
    required this.ayahs,
    required this.language,
    required this.onJumpToAyah,
    required this.onToggleReadingMode,
    required this.onTogglePronunciation,
    required this.onToggleTranslation,
    required this.onTogglePlayback,
  });

  final ReadingViewMode readingViewMode;
  final bool showPronunciation;
  final bool showTranslation;
  final bool isPlayingFullSurah;
  final List<AyahModel> ayahs;
  final AppLanguage language;
  final ValueChanged<int> onJumpToAyah;
  final VoidCallback onToggleReadingMode;
  final VoidCallback onTogglePronunciation;
  final VoidCallback onToggleTranslation;
  final VoidCallback onTogglePlayback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedBg = colorScheme.primary.withValues(alpha: 0.14);
    final unselectedBg = colorScheme.surface.withValues(alpha: 0.7);
    final stroke = colorScheme.outline.withValues(alpha: 0.22);

    return SafeArea(
      bottom: false,
      child: Container(
        height: kToolbarHeight,
        padding: EdgeInsets.only(
          left: 12.h,
          right: 12.h,
          top: 10.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          spacing: AppSpacing.xs,
          children: [
            Expanded(
              child: _BottomNavAction(
                icon: readingViewMode == ReadingViewMode.detailsView
                    ? Icons.view_agenda_rounded
                    : Icons.wrap_text_rounded,
                selected: true,
                tooltip: context.l10n.readQuranReadingModeLabel,
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
                onTap: onToggleReadingMode,
              ),
            ),
            Expanded(
              child: _BottomNavAction(
                icon: Icons.record_voice_over_rounded,
                selected: showPronunciation,
                tooltip: context.l10n.settingsShowPronunciationTitle,
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
                onTap: onTogglePronunciation,
              ),
            ),
            Expanded(
              child: _BottomNavAction(
                icon: Icons.translate_rounded,
                selected: showTranslation,
                tooltip: context.l10n.settingsShowTranslationsTitle,
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
                onTap: onToggleTranslation,
              ),
            ),
            Expanded(
              child: _SurahSearchAction(
                ayahs: ayahs,
                language: language,
                onJumpToAyah: onJumpToAyah,
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
              ),
            ),
            Expanded(
              child: _BottomNavAction(
                icon: isPlayingFullSurah
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_fill_rounded,
                selected: isPlayingFullSurah,
                tooltip: isPlayingFullSurah
                    ? context.l10n.readQuranStopSurahAudio
                    : context.l10n.readQuranPlayFullSurah,
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
                onTap: onTogglePlayback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavAction extends StatelessWidget {
  const _BottomNavAction({
    required this.icon,
    required this.selected,
    required this.tooltip,
    required this.selectedBg,
    required this.unselectedBg,
    required this.stroke,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final String tooltip;
  final Color selectedBg;
  final Color unselectedBg;
  final Color stroke;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.7);

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        child: IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            iconSize: 18,
            backgroundColor: selected ? MyColors.scaffold : unselectedBg,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              side: BorderSide(color: stroke),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }
}

class _SurahSearchAction extends StatelessWidget {
  const _SurahSearchAction({
    required this.ayahs,
    required this.language,
    required this.onJumpToAyah,
    required this.selectedBg,
    required this.unselectedBg,
    required this.stroke,
  });

  final List<AyahModel> ayahs;
  final AppLanguage language;
  final ValueChanged<int> onJumpToAyah;
  final Color selectedBg;
  final Color unselectedBg;
  final Color stroke;

  @override
  Widget build(BuildContext context) {
    return _BottomNavAction(
      icon: Icons.search_rounded,
      selected: false,
      tooltip: context.l10n.readQuranSearchInsideSurahTitle,
      selectedBg: selectedBg,
      unselectedBg: unselectedBg,
      stroke: stroke,
      onTap: () => _openSurahSearchSheet(context),
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
                            prefixIcon: const Icon(Icons.search_rounded),
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
                                  icon: Icons.manage_search_rounded,
                                  title: context.l10n.readQuranSearchAyahsTitle,
                                  message:
                                      context.l10n.readQuranSearchAyahsBody,
                                )
                              : results.isEmpty
                              ? EmptyState(
                                  icon: Icons.search_off,
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
                                          Icons.arrow_downward_rounded,
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

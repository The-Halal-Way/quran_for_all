import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_details_search_button.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/surah_model.dart';
import '../../../common/app_pill.dart';
import 'surah_bottom_controls.dart';

class SurahMetaCard extends StatelessWidget {
  const SurahMetaCard({
    super.key,
    required this.surah,
    required this.titleText,
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
    this.totalSurahCount = 114,
    this.onPreviousSurah,
    this.onNextSurah,
  });

  final SurahModel surah;
  final String titleText;
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

  /// Total number of surahs in the Quran, shown as "Surah X of 114".
  final int totalSurahCount;

  /// Null when [surah] is the first/last surah, which disables the
  /// respective navigation arrow.
  final VoidCallback? onPreviousSurah;
  final VoidCallback? onNextSurah;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            Color.lerp(colorScheme.primary, colorScheme.tertiary, 0.48)!,
            colorScheme.tertiary,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -64,
            top: -76,
            child: IgnorePointer(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 34,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.chevron_back,
                          size: 20,
                          color: MyColors.textOnPrimary,
                        ),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.13),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          titleText,
                          textAlign: TextAlign.center,
                          style: AppTheme.surahArabicName(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                      SurahDetailsSearchButton(
                        ayahs: ayahs,
                        language: language,
                        onJumpToAyah: onJumpToAyah,
                      ),
                    ],
                  ),
                  if (surah.nameEnglish.trim().isNotEmpty &&
                      titleText.trim().toLowerCase() !=
                          surah.nameEnglish.trim().toLowerCase())
                    Text(
                      surah.nameEnglish,
                      textAlign: TextAlign.center,
                      style: AppTheme.text(context).bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    alignment: WrapAlignment.center,
                    children: [
                      AppPill.overlay(
                        icon: CupertinoIcons.square_stack_3d_up,
                        label:
                            '${surah.totalAyahs} ${context.l10n.readQuranAyahsLabel}',
                      ),
                      AppPill.overlay(
                        icon: surah.revelationType == 'Meccan'
                            ? CupertinoIcons.moon_stars
                            : CupertinoIcons.building_2_fill,
                        label: _localizedRevelationType(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _SurahNavArrow(
                        icon: CupertinoIcons.chevron_left,
                        tooltip: context.l10n.readQuranPreviousSurahTooltip,
                        onTap: onPreviousSurah,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            context.l10n.readQuranSurahOfTotal(
                              surah.id,
                              totalSurahCount,
                            ),
                            style: AppTheme.text(context).labelMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                        ),
                      ),
                      _SurahNavArrow(
                        icon: CupertinoIcons.chevron_right,
                        tooltip: context.l10n.readQuranNextSurahTooltip,
                        onTap: onNextSurah,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SurahBottomControls(
                    embedded: true,
                    readingViewMode: readingViewMode,
                    showPronunciation: showPronunciation,
                    showTranslation: showTranslation,
                    isPlayingFullSurah: isPlayingFullSurah,
                    ayahs: ayahs,
                    language: language,
                    onJumpToAyah: onJumpToAyah,
                    onToggleReadingMode: onToggleReadingMode,
                    onTogglePronunciation: onTogglePronunciation,
                    onToggleTranslation: onToggleTranslation,
                    onTogglePlayback: onTogglePlayback,
                  ),
                ],
              ),
            ),
          ),
        ],
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

/// Compact circular previous/next arrow used by the surah navigator strip.
/// Dims and disables itself when [onTap] is null (e.g. at surah 1 or 114).
class _SurahNavArrow extends StatelessWidget {
  const _SurahNavArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: enabled ? 0.16 : 0.06),
              ),
              child: Icon(
                icon,
                size: 19,
                color: Colors.white.withValues(alpha: enabled ? 0.95 : 0.32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

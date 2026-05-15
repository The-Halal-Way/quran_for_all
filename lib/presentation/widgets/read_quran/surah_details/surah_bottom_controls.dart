import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

class SurahBottomControls extends StatelessWidget {
  const SurahBottomControls({
    super.key,
    required this.readingViewMode,
    required this.showPronunciation,
    required this.showTranslation,
    required this.isPlayingFullSurah,
    required this.onToggleReadingMode,
    required this.onTogglePronunciation,
    required this.onToggleTranslation,
    required this.onSearch,
    required this.onTogglePlayback,
  });

  final ReadingViewMode readingViewMode;
  final bool showPronunciation;
  final bool showTranslation;
  final bool isPlayingFullSurah;
  final VoidCallback onToggleReadingMode;
  final VoidCallback onTogglePronunciation;
  final VoidCallback onToggleTranslation;
  final VoidCallback onSearch;
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
                tooltip: context.readQuranText('Reading mode'),
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
                tooltip: context.readQuranText('Show pronunciation'),
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
                tooltip: context.readQuranText('Show translations'),
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
                onTap: onToggleTranslation,
              ),
            ),
            Expanded(
              child: _BottomNavAction(
                icon: Icons.search_rounded,
                selected: false,
                tooltip: context.readQuranText('Search inside this surah'),
                selectedBg: selectedBg,
                unselectedBg: unselectedBg,
                stroke: stroke,
                onTap: onSearch,
              ),
            ),
            Expanded(
              child: _BottomNavAction(
                icon: isPlayingFullSurah
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_fill_rounded,
                selected: isPlayingFullSurah,
                tooltip: context.readQuranText(
                  isPlayingFullSurah ? 'Stop Surah Audio' : 'Play Full Surah',
                ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';

import '../../../../../../core/localization/l10n_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';

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
    this.embedded = false,
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

  /// When true, renders as a compact action row meant to be embedded inside
  /// another surface (e.g. [SurahMetaCard]) instead of as a standalone
  /// bottom navigation bar. Uses light, overlay-friendly colors suited for a
  /// dark gradient background and skips the surface container/SafeArea.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedBg = embedded
        ? Colors.white.withValues(alpha: 0.24)
        : colorScheme.primary.withValues(alpha: 0.14);
    final unselectedBg = embedded
        ? Colors.white.withValues(alpha: 0.12)
        : colorScheme.surface.withValues(alpha: 0.7);
    final stroke = embedded
        ? Colors.white.withValues(alpha: 0.28)
        : colorScheme.outline.withValues(alpha: 0.22);
    final selectedFg = embedded ? Colors.white : colorScheme.primary;
    final unselectedFg = embedded
        ? Colors.white.withValues(alpha: 0.85)
        : colorScheme.onSurface.withValues(alpha: 0.7);

    final row = Row(
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
            selectedFg: selectedFg,
            unselectedFg: unselectedFg,
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
            selectedFg: selectedFg,
            unselectedFg: unselectedFg,
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
            selectedFg: selectedFg,
            unselectedFg: unselectedFg,
            onTap: onToggleTranslation,
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
            selectedFg: selectedFg,
            unselectedFg: unselectedFg,
            onTap: onTogglePlayback,
          ),
        ),
      ],
    );

    if (embedded) {
      return row;
    }

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
        child: row,
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
    required this.selectedFg,
    required this.unselectedFg,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final String tooltip;
  final Color selectedBg;
  final Color unselectedBg;
  final Color stroke;
  final Color selectedFg;
  final Color unselectedFg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected ? selectedFg : unselectedFg;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        child: IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            iconSize: 18,
            backgroundColor: selected ? selectedBg : unselectedBg,
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


import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/presentation/widgets/common/app_snackbar.dart';
import 'package:quran_for_all/presentation/viewmodels/audio_control_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/ayah_tile.dart';

class SurahAyahList extends StatelessWidget {
  const SurahAyahList({
    super.key,
    required this.controller,
    required Map<int, GlobalKey> ayahKeys,
    required int? highlightedAyahNumber,
    required ValueChanged<int> onLastReadMarked,
    required Future<void> Function(
      BuildContext,
      SurahDetailsViewModel,
      AyahModel,
    )
    playAyahWithFeedback,
  }) : _ayahKeys = ayahKeys,
       _highlightedAyahNumber = highlightedAyahNumber,
       _onLastReadMarked = onLastReadMarked,
       _playAyahWithFeedback = playAyahWithFeedback;
  final ScrollController controller;
  final Map<int, GlobalKey> _ayahKeys;
  final int? _highlightedAyahNumber;
  final ValueChanged<int> _onLastReadMarked;
  final Future<void> Function(BuildContext, SurahDetailsViewModel, AyahModel)
  _playAyahWithFeedback;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurahDetailsViewModel>();
    final audioControl = context.watch<AudioControlViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);
    // regular view
    if (settings.readingViewMode == ReadingViewMode.regularView) {
      return ListView(
        controller: controller,
        padding: EdgeInsets.fromLTRB(
          responsive.padding,
          0,
          responsive.padding,
          AppSpacing.lg,
        ),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text.rich(
                TextSpan(
                  children: List.generate(viewModel.ayahs.length, (index) {
                    final ayah = viewModel.ayahs[index];
                    final colorScheme = Theme.of(context).colorScheme;
                    final isPlaying = viewModel.isAyahPlaying(
                      ayah.ayahNumber,
                    );
                    final isHighlighted =
                        ayah.ayahNumber == _highlightedAyahNumber;

                    // 1) The ayah text (tappable). While playing, only the
                    // portion of the ayah already recited is highlighted
                    // (progressing left-to-right through the text), mirroring
                    // the details-view word-by-word highlight behavior.
                    // While temporarily marked (e.g. last read), the whole
                    // ayah gets a flat highlight instead.
                    final ayahTextSpans = _buildAyahTextSpans(
                      ayah: ayah,
                      isPlaying: isPlaying,
                      isHighlighted: isHighlighted,
                      colorScheme: colorScheme,
                      audioControl: audioControl,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _showAyahDetailsSheet(
                          context,
                          ayah,
                          viewModel,
                          settings,
                        ),
                    );

                    // 2) The circled number
                    final numberSpan = WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        margin: const EdgeInsetsDirectional.only(
                          start: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.14),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          '${ayah.ayahNumber}',
                          style: AppTheme.text(context).labelSmall.copyWith(
                            fontWeight: AppTheme.weightBold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );

                    // 3) Invisible anchor widget for scrolling  ← NEW
                    final anchorSpan = WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: SizedBox(
                        key: _ayahKeyFor(
                          ayah.ayahNumber,
                        ), // same key used before
                        width: 0,
                        height: 0,
                      ),
                    );

                    return [...ayahTextSpans, numberSpan, anchorSpan];
                  }).expand((spans) => spans).toList(),
                ),
                textDirection: TextDirection.rtl,
                // 🔽 This adds the line spacing
                style: AppTheme.quranArabic(context).copyWith(height: 2.5.h),
              ),
            ),
          ),
        ],
      );
    }
    // details view
    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(
        responsive.padding,
        0,
        responsive.padding,
        AppSpacing.lg,
      ),
      children: [
        for (final ayah in viewModel.ayahs)
          Padding(
            key: _ayahKeyFor(ayah.ayahNumber),
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
            child: Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                final isPlaying = viewModel.isAyahPlaying(ayah.ayahNumber);
                final isHighlighted = ayah.ayahNumber == _highlightedAyahNumber;
                final showHighlight = isPlaying || isHighlighted;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? colorScheme.secondary.withValues(alpha: 0.12)
                        : (isHighlighted
                              ? colorScheme.primary.withValues(alpha: 0.08)
                              : null),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: showHighlight
                        ? Border.all(
                            color: isPlaying
                                ? colorScheme.secondary.withValues(alpha: 0.58)
                                : colorScheme.primary.withValues(alpha: 0.42),
                            width: isPlaying ? 1.4 : 1.2,
                          )
                        : null,
                  ),
                  child: _buildDetailsAyahTile(
                    context,
                    ayah,
                    viewModel,
                    settings,
                    audioControl.progress,
                    audioControl.position,
                    audioControl.duration,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsAyahTile(
    BuildContext context,
    AyahModel ayah,
    SurahDetailsViewModel viewModel,
    AppSettings settings,
    double playbackProgress,
    Duration playbackPosition,
    Duration playbackDuration,
  ) {
    return AyahTile(
      ayah: ayah,
      showPronunciation: settings.showPronunciation,
      showTranslation: settings.showTranslation,
      language: settings.language,
      isBookmarked: viewModel.isAyahBookmarked(ayah.ayahNumber),
      isLastReadAyah: viewModel.isLastReadAyah(ayah.ayahNumber),
      isPlaying: viewModel.isAyahPlaying(ayah.ayahNumber),
      playbackProgress: viewModel.isAyahPlaying(ayah.ayahNumber)
          ? playbackProgress
          : 0,
      playbackPosition: viewModel.isAyahPlaying(ayah.ayahNumber)
          ? playbackPosition
          : Duration.zero,
      playbackDuration: viewModel.isAyahPlaying(ayah.ayahNumber)
          ? playbackDuration
          : Duration.zero,
      onPlay: () => unawaited(
        viewModel.isAyahPlaying(ayah.ayahNumber)
            ? viewModel.stopPlayback()
            : _playAyahWithFeedback(context, viewModel, ayah),
      ),
      onToggleBookmark: () =>
          unawaited(_toggleAyahBookmarkWithFeedback(context, viewModel, ayah)),
      onMarkAsLastRead: () =>
          unawaited(_markAsLastReadWithFeedback(context, viewModel, ayah)),
    );
  }

  Future<void> _toggleAyahBookmarkWithFeedback(
    BuildContext context,
    SurahDetailsViewModel viewModel,
    AyahModel ayah,
  ) async {
    final wasBookmarked = viewModel.isAyahBookmarked(ayah.ayahNumber);

    try {
      await viewModel.toggleAyahBookmark(ayah);
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showInfo(
        context,
        wasBookmarked
            ? context.l10n.readQuranAyahBookmarkRemoved
            : context.l10n.readQuranAyahBookmarkAdded,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showError(
        context,
        context.l10n.readQuranCouldNotUpdateAyahBookmark,
      );
    }
  }

  Future<void> _markAsLastReadWithFeedback(
    BuildContext context,
    SurahDetailsViewModel viewModel,
    AyahModel ayah,
  ) async {
    try {
      await viewModel.markAsLastRead(ayah);
      _onLastReadMarked(ayah.ayahNumber);
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showInfo(context, context.l10n.readQuranMarkedLastRead);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showError(
        context,
        context.l10n.readQuranCouldNotMarkLastRead,
      );
    }
  }

  void _showAyahDetailsSheet(
    BuildContext context,
    AyahModel ayah,
    SurahDetailsViewModel viewModel,
    AppSettings settings,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Consumer3<
          SurahDetailsViewModel,
          SettingsViewModel,
          AudioControlViewModel
        >(
          builder:
              (sheetContext, liveViewModel, settingsVm, liveAudioControl, _) {
                return SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom:
                          MediaQuery.of(sheetContext).viewInsets.bottom +
                          AppSpacing.md,
                    ),
                    child: _buildDetailsAyahTile(
                      sheetContext,
                      ayah,
                      liveViewModel,
                      settingsVm.settings,
                      liveAudioControl.progress,
                      liveAudioControl.position,
                      liveAudioControl.duration,
                    ),
                  ),
                );
              },
        );
      },
    );
  }

  GlobalKey _ayahKeyFor(int ayahNumber) {
    return _ayahKeys.putIfAbsent(ayahNumber, GlobalKey.new);
  }

  // Mirrors AyahTile's early-completion easing so the regular-view highlight
  // finishes a moment before the audio actually ends.
  static const double _earlyHighlightPercent = 0.14;
  static const double _minEarlySeconds = 1.0;
  static const double _maxEarlySeconds = 6.0;

  double _acceleratedProgress(AudioControlViewModel audioControl) {
    final durationMs = audioControl.duration.inMilliseconds;
    final positionMs = audioControl.position.inMilliseconds;

    if (durationMs <= 0) {
      return (audioControl.progress.clamp(0.0, 1.0) * 1.35).clamp(0.0, 1.0);
    }

    final durationSeconds = durationMs / 1000.0;
    final earlySeconds = (durationSeconds * _earlyHighlightPercent).clamp(
      _minEarlySeconds,
      _maxEarlySeconds,
    );
    final effectiveDurationMs =
        ((durationSeconds - earlySeconds).clamp(0.25, durationSeconds) * 1000)
            .toDouble();
    final clampedPosition = positionMs.clamp(0, durationMs);
    return (clampedPosition / effectiveDurationMs).clamp(0.0, 1.0);
  }

  /// Builds the Arabic text spans for a single ayah in regular view.
  ///
  /// While the ayah is playing, only the portion already recited (from the
  /// start of the ayah up to the current playback position) is highlighted,
  /// so the user can visually track where the audio currently is. While
  /// temporarily marked (e.g. last read/jumped-to), the whole ayah gets a
  /// flat highlight instead.
  List<InlineSpan> _buildAyahTextSpans({
    required AyahModel ayah,
    required bool isPlaying,
    required bool isHighlighted,
    required ColorScheme colorScheme,
    required AudioControlViewModel audioControl,
    required TapGestureRecognizer recognizer,
  }) {
    if (isPlaying && audioControl.progress > 0) {
      final graphemes = ayah.arabicText.characters.toList();
      final total = graphemes.length;
      if (total == 0) {
        return [TextSpan(text: '${ayah.arabicText} ', recognizer: recognizer)];
      }

      final progress = _acceleratedProgress(audioControl);
      final highlightCount = (total * progress).ceil().clamp(0, total);
      final highlighted = graphemes.take(highlightCount).join();
      final remaining = graphemes.skip(highlightCount).join();

      return [
        TextSpan(
          text: highlighted,
          style: TextStyle(
            backgroundColor: colorScheme.secondary.withValues(alpha: 0.28),
          ),
          recognizer: recognizer,
        ),
        TextSpan(text: '$remaining ', recognizer: recognizer),
      ];
    }

    return [
      TextSpan(
        text: '${ayah.arabicText} ',
        style: isHighlighted
            ? TextStyle(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
              )
            : null,
        recognizer: recognizer,
      ),
    ];
  }
}

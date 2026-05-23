import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_text_styles.dart';
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

                    // 1) The ayah text (tappable)
                    final textSpan = TextSpan(
                      text: '${ayah.arabicText} ',
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
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

                    return [textSpan, numberSpan, anchorSpan];
                  }).expand((spans) => spans).toList(),
                ),
                textDirection: TextDirection.rtl,
                // 🔽 This adds the line spacing
                style: AppTextStyles.quranArabic(
                  context,
                ).copyWith(height: 2.5.h),
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
        context.readQuranText(
          wasBookmarked
              ? 'Ayah bookmark removed.'
              : 'Ayah bookmarked successfully.',
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showError(
        context,
        context.readQuranText('Could not update ayah bookmark right now.'),
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

      AppSnackbar.showInfo(
        context,
        context.readQuranText('Marked as last read.'),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showError(
        context,
        context.readQuranText('Could not mark this ayah as last read.'),
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
        return Consumer2<SurahDetailsViewModel, SettingsViewModel>(
          builder: (sheetContext, liveViewModel, settingsVm, _) {
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
                  context.watch<AudioControlViewModel>().progress,
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
}

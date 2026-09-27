import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/presentation/widgets/common/app_snackbar.dart';
import 'package:quran_for_all/presentation/viewmodels/audio_control_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/ayah_tile.dart';

import 'surah_bismillah_card.dart';
import 'surah_details_ayah_item.dart';
import 'surah_regular_ayah_text.dart';

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
    required this.playBismillahWithFeedback,
  }) : _ayahKeys = ayahKeys,
       _highlightedAyahNumber = highlightedAyahNumber,
       _onLastReadMarked = onLastReadMarked,
       _playAyahWithFeedback = playAyahWithFeedback;
  final ScrollController controller;
  final Future<void> Function(BuildContext, SurahDetailsViewModel)
  playBismillahWithFeedback;
  final Map<int, GlobalKey> _ayahKeys;
  final int? _highlightedAyahNumber;
  final ValueChanged<int> _onLastReadMarked;
  final Future<void> Function(BuildContext, SurahDetailsViewModel, AyahModel)
  _playAyahWithFeedback;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurahDetailsViewModel>();
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
          if (viewModel.openingBismillah != null)
            _buildBismillahCard(context, viewModel, settings),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SurahRegularAyahText(
                ayahs: viewModel.ayahs,
                ayahKeys: _ayahKeys,
                playingAyahNumber: viewModel.playingAyahNumber,
                highlightedAyahNumber: _highlightedAyahNumber,
                onAyahTap: (ayah) => _showAyahDetailsSheet(context, ayah),
              ),
            ),
          ),
        ],
      );
    }
    // details view
    final openingCount = viewModel.openingBismillah == null ? 0 : 1;
    return ListView.builder(
      controller: controller,
      cacheExtent: 200,
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.fromLTRB(
        responsive.padding,
        0,
        responsive.padding,
        AppSpacing.lg,
      ),
      itemCount: viewModel.ayahs.length + openingCount,
      itemBuilder: (context, index) {
        if (index < openingCount) {
          return _buildBismillahCard(context, viewModel, settings);
        }
        final ayah = viewModel.ayahs[index - openingCount];
        return SurahDetailsAyahItem(
          key: _ayahKeyFor(ayah.ayahNumber),
          ayah: ayah,
          language: settings.language,
          showPronunciation: settings.showPronunciation,
          showTranslation: settings.showTranslation,
          isBookmarked: viewModel.isAyahBookmarked(ayah.ayahNumber),
          isLastReadAyah: viewModel.isLastReadAyah(ayah.ayahNumber),
          isPlaying: viewModel.isAyahPlaying(ayah.ayahNumber),
          isHighlighted: ayah.ayahNumber == _highlightedAyahNumber,
          onPlay: () => unawaited(
            viewModel.isAyahPlaying(ayah.ayahNumber)
                ? viewModel.stopPlayback()
                : _playAyahWithFeedback(context, viewModel, ayah),
          ),
          onToggleBookmark: () => unawaited(
            _toggleAyahBookmarkWithFeedback(context, viewModel, ayah),
          ),
          onMarkAsLastRead: () =>
              unawaited(_markAsLastReadWithFeedback(context, viewModel, ayah)),
          loadTafsir: () => viewModel.loadTafsir(ayah, settings.language),
        );
      },
    );
  }

  Widget _buildBismillahCard(
    BuildContext context,
    SurahDetailsViewModel viewModel,
    AppSettings settings,
  ) {
    Widget card(double progress) => SurahBismillahCard(
      opening: viewModel.openingBismillah!,
      language: settings.language,
      showPronunciation: settings.showPronunciation,
      showTranslation: settings.showTranslation,
      isPlaying: viewModel.isPlayingBismillah,
      playbackProgress: progress,
      onPlay: () => unawaited(
        viewModel.isPlayingBismillah
            ? viewModel.stopPlayback()
            : playBismillahWithFeedback(context, viewModel),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      child: viewModel.isPlayingBismillah
          ? Consumer<AudioControlViewModel>(
              builder: (context, audioControl, _) =>
                  card(audioControl.progress),
            )
          : card(0),
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
      loadTafsir: () => viewModel.loadTafsir(ayah, settings.language),
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

  void _showAyahDetailsSheet(BuildContext context, AyahModel ayah) {
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
}

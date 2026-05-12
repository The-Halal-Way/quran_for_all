import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/ayah_tile.dart';

class SurahAyahList extends StatelessWidget {
  const SurahAyahList({
    super.key,
    required this.controller,
    required Map<int, GlobalKey> ayahKeys,
    required int? highlightedAyahNumber,
    required Future<void> Function(
      BuildContext,
      SurahDetailsViewModel,
      AyahModel,
    )
    playAyahWithFeedback,
  }) : _ayahKeys = ayahKeys,
       _highlightedAyahNumber = highlightedAyahNumber,
       _playAyahWithFeedback = playAyahWithFeedback;
  final ScrollController controller ;
  final Map<int, GlobalKey> _ayahKeys;
  final int? _highlightedAyahNumber;
  final Future<void> Function(BuildContext, SurahDetailsViewModel, AyahModel)
  _playAyahWithFeedback;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurahDetailsViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: ayah.ayahNumber == _highlightedAyahNumber
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.08)
                    : null,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: ayah.ayahNumber == _highlightedAyahNumber
                    ? Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.42),
                        width: 1.2,
                      )
                    : null,
              ),
              child: AyahTile(
                ayah: ayah,
                showPronunciation: settings.showPronunciation,
                showTranslation: settings.showTranslation,
                language: settings.language,
                isBookmarked: viewModel.isAyahBookmarked(ayah.ayahNumber),
                isPlaying: viewModel.isAyahPlaying(ayah.ayahNumber),
                onPlay: () => unawaited(
                  viewModel.isAyahPlaying(ayah.ayahNumber)
                      ? viewModel.stopPlayback()
                      : _playAyahWithFeedback(context, viewModel, ayah),
                ),
                onToggleBookmark: () =>
                    unawaited(viewModel.toggleAyahBookmark(ayah)),
                onMarkAsLastRead: () =>
                    unawaited(viewModel.markAsLastRead(ayah)),
              ),
            ),
          ),
      ],
    );
  }

  GlobalKey _ayahKeyFor(int ayahNumber) {
    return _ayahKeys.putIfAbsent(ayahNumber, GlobalKey.new);
  }
}

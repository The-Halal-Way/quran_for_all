import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_text_styles.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
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
  final ScrollController controller;
  final Map<int, GlobalKey> _ayahKeys;
  final int? _highlightedAyahNumber;
  final Future<void> Function(BuildContext, SurahDetailsViewModel, AyahModel)
      _playAyahWithFeedback;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurahDetailsViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);

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
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final ayah in viewModel.ayahs)
                    KeyedSubtree(
                      key: _ayahKeyFor(ayah.ayahNumber),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        onTap: () => _showAyahDetailsSheet(
                          context,
                          ayah,
                          viewModel,
                          settings,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            color: ayah.ayahNumber == _highlightedAyahNumber
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12)
                                : null,
                          ),
                          child: Text.rich(
                            TextSpan(
                              text: '${ayah.arabicText} ',
                              children: [
                                WidgetSpan(
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
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textDirection: TextDirection.rtl,
                            style: AppTextStyles.quranArabic(context),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    }

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
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                    : null,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: ayah.ayahNumber == _highlightedAyahNumber
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.42),
                        width: 1.2,
                      )
                    : null,
              ),
              child: _buildDetailsAyahTile(context, ayah, viewModel, settings),
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
  ) {
    return AyahTile(
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
      onToggleBookmark: () => unawaited(viewModel.toggleAyahBookmark(ayah)),
      onMarkAsLastRead: () => unawaited(viewModel.markAsLastRead(ayah)),
    );
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

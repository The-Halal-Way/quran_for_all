import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_bottom_controls.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_ayah_list.dart';

import '../../../../core/enums/playback_source.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/localization/read_quran_message_localizer.dart';
import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/enums/reading_view_mode.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/ayah_model.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/audio_control_viewmodel.dart';
import '../../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_snackbar.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/quran/read_quran/surah_details/surah_meta_card.dart';
import '../../../../services/permission_helper.dart';

class SurahDetailsView extends StatefulWidget {
  const SurahDetailsView({
    super.key,
    required this.surah,
    this.initialAyahNumber,
  });

  final SurahModel surah;
  final int? initialAyahNumber;

  @override
  State<SurahDetailsView> createState() => _SurahDetailsViewState();
}

class _SurahDetailsViewState extends State<SurahDetailsView> {
  late AudioControlViewModel _audioControlVm;
  late int? _pendingAyahNumber;
  int? _highlightedAyahNumber;
  ScrollController? _scrollController;
  int? _revealingAyahNumber;
  int _revealAttempts = 0;
  final Map<int, GlobalKey> _ayahKeys = <int, GlobalKey>{};
  static const int _maxRevealAttempts = 6;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioControlVm = context.read<AudioControlViewModel>();
  }

  @override
  void initState() {
    super.initState();
    _pendingAyahNumber = widget.initialAyahNumber;

    // Tell the mini-player that this page is now active so it hides itself
    // while the user is on the source page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _audioControlVm.setActivePage(PlaybackSource.surahDetails);
      }
    });
  }

  @override
  void dispose() {
    _audioControlVm.clearActivePage(PlaybackSource.surahDetails);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurahDetailsViewModel>();
    final settingsViewModel = context.read<SettingsViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);
    if (!viewModel.isLoading) _maybeRevealAyah(viewModel);

    final onTogglePlayback = viewModel.isPlayingFullSurah
        ? () => unawaited(viewModel.stopPlayback())
        : () => unawaited(_playFullSurahWithFeedback(context, viewModel));

    return Scaffold(
      bottomNavigationBar: viewModel.isLoading || viewModel.errorMessage != null
          ? null
          : SurahBottomControls(
              readingViewMode: settings.readingViewMode,
              showPronunciation: settings.showPronunciation,
              showTranslation: settings.showTranslation,
              isPlayingFullSurah: viewModel.isPlayingFullSurah,
              ayahs: viewModel.ayahs,
              language: settings.language,
              onJumpToAyah: _jumpToAyahFromSearch,
              onToggleReadingMode: () {
                final nextMode =
                    settings.readingViewMode == ReadingViewMode.detailsView
                    ? ReadingViewMode.regularView
                    : ReadingViewMode.detailsView;
                unawaited(settingsViewModel.setReadingViewMode(nextMode));
              },
              onTogglePronunciation: () => unawaited(
                settingsViewModel.setShowPronunciation(
                  !settings.showPronunciation,
                ),
              ),
              onToggleTranslation: () => unawaited(
                settingsViewModel.setShowTranslation(!settings.showTranslation),
              ),
              onTogglePlayback: onTogglePlayback,
            ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
          ? EmptyState(
              icon: Icons.error_outline,
              title: context.l10n.readQuranCouldNotLoadSurahTitle,
              message: localizeReadQuranMessage(
                context,
                viewModel.errorMessage!,
              ),
            )
          : Column(
              children: [
                // surah info and play full surah button
                SurahMetaCard(
                  surah: widget.surah,
                  titleText: widget.surah.localizedTitle(
                    context,
                    settings.language,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                // // Reading options: mode selector + pronunciation/translation.
                // const SurahReadingOptions(),
                // ayah list
                Expanded(
                  child: AppPageScrollbar(
                    builder: (context, controller) {
                      _scrollController = controller;
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: responsive.maxReadingContentWidth,
                          ),
                          child: SurahAyahList(
                            controller: controller,
                            ayahKeys: _ayahKeys,
                            highlightedAyahNumber: _highlightedAyahNumber,
                            onLastReadMarked: _onLastReadMarked,
                            playAyahWithFeedback: _playAyahWithFeedback,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _jumpToAyahFromSearch(int ayahNumber) {
    if (!mounted) {
      return;
    }

    setState(() {
      _pendingAyahNumber = ayahNumber;
      _revealingAyahNumber = null;
      _revealAttempts = 0;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _maybeRevealAyah(context.read<SurahDetailsViewModel>());
    });
  }

  Future<void> _playAyahWithFeedback(
    BuildContext context,
    SurahDetailsViewModel viewModel,
    AyahModel ayah,
  ) async {
    if (!await _ensureAudioPermissionWithFeedback(context)) {
      return;
    }

    try {
      await viewModel.playAyah(ayah);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showError(context, context.l10n.readQuranUnablePlayAyahAudio);
    }
  }

  Future<void> _playFullSurahWithFeedback(
    BuildContext context,
    SurahDetailsViewModel viewModel,
  ) async {
    if (!await _ensureAudioPermissionWithFeedback(context)) {
      return;
    }

    try {
      await viewModel.playFullSurah();
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      AppSnackbar.showError(
        context,
        context.l10n.readQuranUnablePlayFullSurahAudio,
      );
    }
  }

  Future<bool> _ensureAudioPermissionWithFeedback(BuildContext context) async {
    final permissionHelper = context.read<PermissionHelper>();
    final permissionResult = await permissionHelper
        .ensureAudioControlPermissions();

    if (permissionResult.allGranted) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    AppSnackbar.showError(
      context,
      context.l10n.readQuranAudioPermissionRequired,
      action: permissionResult.shouldPromptToOpenSettings
          ? SnackBarAction(
              label: context.l10n.readQuranGoToSettings,
              onPressed: () {
                unawaited(permissionHelper.openSettings());
              },
            )
          : null,
    );

    return false;
  }

  void _maybeRevealAyah(SurahDetailsViewModel viewModel) {
    final targetAyahNumber = _pendingAyahNumber;
    if (targetAyahNumber == null) {
      return;
    }

    if (_revealingAyahNumber != targetAyahNumber) {
      _revealingAyahNumber = targetAyahNumber;
      _revealAttempts = 0;
    }

    final hasTargetAyah = viewModel.ayahs.any(
      (ayah) => ayah.ayahNumber == targetAyahNumber,
    );
    if (!hasTargetAyah) {
      _pendingAyahNumber = null;
      _revealingAyahNumber = null;
      _revealAttempts = 0;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _pendingAyahNumber != targetAyahNumber) {
        return;
      }

      final targetContext = _ayahKeys[targetAyahNumber]?.currentContext;
      if (targetContext == null) {
        _scrollNearTargetAyah(viewModel, targetAyahNumber);
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
        alignment: 0.15,
      );

      setState(() {
        _pendingAyahNumber = null;
        _revealingAyahNumber = null;
        _revealAttempts = 0;
      });

      _highlightAyahTemporarily(targetAyahNumber);
    });
  }

  void _onLastReadMarked(int ayahNumber) {
    _highlightAyahTemporarily(ayahNumber);
  }

  void _highlightAyahTemporarily(int ayahNumber) {
    if (!mounted) {
      return;
    }

    setState(() {
      _highlightedAyahNumber = ayahNumber;
    });

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted || _highlightedAyahNumber != ayahNumber) {
        return;
      }

      setState(() {
        _highlightedAyahNumber = null;
      });
    });
  }

  void _scrollNearTargetAyah(
    SurahDetailsViewModel viewModel,
    int targetAyahNumber,
  ) {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) {
      return;
    }

    final targetIndex = viewModel.ayahs.indexWhere(
      (ayah) => ayah.ayahNumber == targetAyahNumber,
    );
    if (targetIndex < 0) {
      _pendingAyahNumber = null;
      _revealingAyahNumber = null;
      _revealAttempts = 0;
      return;
    }

    final totalAyahs = viewModel.ayahs.length;
    final targetFraction = totalAyahs <= 1
        ? 0.0
        : targetIndex / (totalAyahs - 1);
    final maxExtent = controller.position.maxScrollExtent;
    final targetOffset = (maxExtent * targetFraction).clamp(0.0, maxExtent);

    unawaited(
      controller.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      ),
    );

    _revealAttempts += 1;
    if (_revealAttempts >= _maxRevealAttempts) {
      _pendingAyahNumber = null;
      _revealingAyahNumber = null;
      return;
    }

    Future<void>.delayed(const Duration(milliseconds: 280), () {
      if (!mounted || _pendingAyahNumber != targetAyahNumber) {
        return;
      }

      _maybeRevealAyah(context.read<SurahDetailsViewModel>());
    });
  }
}

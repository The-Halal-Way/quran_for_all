import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_ayah_list.dart';

import '../../../../core/enums/playback_source.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/localization/read_quran_message_localizer.dart';
import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/enums/reading_view_mode.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/ayah_model.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/audio_control_viewmodel.dart';
import '../../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_snackbar.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/quran/read_quran/surah_details/surah_meta_card.dart';
import '../../../widgets/quran/read_quran/surah_details/surah_details_loading.dart';
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
  Timer? _revealTimer;
  Timer? _highlightTimer;
  final Map<int, GlobalKey> _ayahKeys = <int, GlobalKey>{};
  static const int _maxRevealAttempts = 12;

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
    _revealTimer?.cancel();
    _highlightTimer?.cancel();
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

    final allSurahs = context.watch<ReadQuranViewModel>().surahs;
    final previousSurah = _findSurah(allSurahs, widget.surah.id - 1);
    final nextSurah = _findSurah(allSurahs, widget.surah.id + 1);

    return Scaffold(
      body: viewModel.isLoading
          ? SurahDetailsLoading(
              surah: widget.surah,
              language: settings.language,
            )
          : viewModel.errorMessage != null
          ? EmptyState(
              icon: CupertinoIcons.exclamationmark_circle,
              title: context.l10n.readQuranCouldNotLoadSurahTitle,
              message: localizeReadQuranMessage(
                context,
                viewModel.errorMessage!,
              ),
            )
          : Column(
              children: [
                // surah info, reading options & playback controls
                SurahMetaCard(
                  surah: widget.surah,
                  titleText: widget.surah.localizedTitle(
                    context,
                    settings.language,
                  ),
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
                    settingsViewModel.setShowTranslation(
                      !settings.showTranslation,
                    ),
                  ),
                  onTogglePlayback: onTogglePlayback,
                  totalSurahCount: allSurahs.isNotEmpty
                      ? allSurahs.length
                      : 114,
                  onPreviousSurah: previousSurah == null
                      ? null
                      : () => unawaited(_goToSurah(previousSurah)),
                  onNextSurah: nextSurah == null
                      ? null
                      : () => unawaited(_goToSurah(nextSurah)),
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
                            playBismillahWithFeedback:
                                _playBismillahWithFeedback,
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

  SurahModel? _findSurah(List<SurahModel> surahs, int id) {
    for (final candidate in surahs) {
      if (candidate.id == id) {
        return candidate;
      }
    }
    return null;
  }

  Future<void> _goToSurah(SurahModel target) async {
    final viewModel = context.read<SurahDetailsViewModel>();
    if (viewModel.isPlayingFullSurah ||
        viewModel.isPlayingBismillah ||
        viewModel.playingAyahNumber != null) {
      await viewModel.stopPlayback();
    }
    if (!mounted) {
      return;
    }

    unawaited(viewModel.openSurah(target));
    await Navigator.of(context).pushReplacement(
      AppPageRoute<void>(builder: (_) => SurahDetailsView(surah: target)),
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
    _revealTimer?.cancel();

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

  Future<void> _playBismillahWithFeedback(
    BuildContext context,
    SurahDetailsViewModel viewModel,
  ) async {
    if (!await _ensureAudioPermissionWithFeedback(context)) return;
    try {
      await viewModel.playBismillah();
    } catch (_) {
      if (!context.mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.readQuranUnablePlayBismillahAudio,
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
      _revealTimer?.cancel();

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

    _highlightTimer?.cancel();
    _highlightTimer = Timer(const Duration(seconds: 2), () {
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

    // A lazy list has no render object for distant ayahs. Use the positions
    // and heights of its mounted cards to estimate the target, then correct
    // after the next layout. This also works when translations change height.
    final viewport = controller.position.context.storageContext
        .findRenderObject();
    final viewportTop = viewport is RenderBox
        ? viewport.localToGlobal(Offset.zero).dy
        : 0.0;
    final mountedAyahs = <(int, double, double)>[];
    for (var index = 0; index < viewModel.ayahs.length; index++) {
      final ayahNumber = viewModel.ayahs[index].ayahNumber;
      final renderObject = _ayahKeys[ayahNumber]?.currentContext
          ?.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        mountedAyahs.add((
          index,
          renderObject.localToGlobal(Offset.zero).dy - viewportTop,
          renderObject.size.height,
        ));
      }
    }

    if (mountedAyahs.isEmpty) {
      return;
    }

    final averageHeight =
        mountedAyahs.fold<double>(0, (sum, item) => sum + item.$3) /
        mountedAyahs.length;
    final anchor = mountedAyahs.reduce(
      (closest, item) => item.$2.abs() < closest.$2.abs() ? item : closest,
    );
    final maxExtent = controller.position.maxScrollExtent;
    final targetOffset =
        (controller.offset +
                anchor.$2 +
                (targetIndex - anchor.$1) * averageHeight)
            .clamp(0.0, maxExtent);
    controller.jumpTo(targetOffset);

    _revealAttempts += 1;
    if (_revealAttempts >= _maxRevealAttempts) {
      _pendingAyahNumber = null;
      _revealingAyahNumber = null;
      return;
    }

    _revealTimer?.cancel();
    _revealTimer = Timer(const Duration(milliseconds: 32), () {
      if (!mounted || _pendingAyahNumber != targetAyahNumber) {
        return;
      }

      _maybeRevealAyah(context.read<SurahDetailsViewModel>());
    });
  }
}

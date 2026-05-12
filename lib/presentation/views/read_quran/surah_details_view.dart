import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/widgets/read_quran/surah_details/surah_ayah_list.dart';
import 'package:quran_for_all/presentation/widgets/read_quran/surah_details/surah_reading_options.dart';

import '../../../core/enums/reading_view_mode.dart';
import '../../../core/enums/playback_source.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/models/ayah_model.dart';
import '../../../data/models/surah_model.dart';
import '../../viewmodels/audio_control_viewmodel.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/read_quran/surah_details/surah_meta_card.dart';
import '../../../services/permission_helper.dart';

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
  final Map<int, GlobalKey> _ayahKeys = <int, GlobalKey>{};

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
    final settingsViewModel = context.watch<SettingsViewModel>();
    final settings = settingsViewModel.settings;
    final responsive = AppResponsive.of(context);
    if (!viewModel.isLoading) _maybeRevealAyah(viewModel);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.surah.id}. ${widget.surah.nameEnglish}'),
        actions: [
          PopupMenuButton<ReadingViewMode>(
            tooltip: context.readQuranText('Reading mode'),
            initialValue: settings.readingViewMode,
            icon: Icon(
              settings.readingViewMode == ReadingViewMode.detailsView
                  ? Icons.view_agenda_rounded
                  : Icons.wrap_text_rounded,
            ),
            onSelected: (mode) {
              unawaited(settingsViewModel.setReadingViewMode(mode));
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: ReadingViewMode.detailsView,
                child: Row(
                  children: [
                    const Icon(Icons.view_agenda_rounded),
                    const SizedBox(width: AppSpacing.sm),
                    Text(context.readQuranText('Details view')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ReadingViewMode.regularView,
                child: Row(
                  children: [
                    const Icon(Icons.wrap_text_rounded),
                    const SizedBox(width: AppSpacing.sm),
                    Text(context.readQuranText('Regular view')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AppGradientBackground(
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewModel.errorMessage != null
            ? EmptyState(
                icon: Icons.error_outline,
                title: context.readQuranText('Could not load surah'),
                message: localizeReadQuranMessage(
                  context,
                  viewModel.errorMessage!,
                ),
              )
            : Column(
                children: [
                  // surah info and play full surah button
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsive.padding,
                      AppSpacing.sm,
                      responsive.padding,
                      AppSpacing.md,
                    ),
                    child: SurahMetaCard(
                      surah: widget.surah,
                      isPlayingFullSurah: viewModel.isPlayingFullSurah,
                      onTogglePlayback: viewModel.isPlayingFullSurah
                          ? () => unawaited(viewModel.stopPlayback())
                          : () => unawaited(
                              _playFullSurahWithFeedback(context, viewModel),
                            ),
                    ),
                  ),
                  // Reading options: mode selector + pronunciation/translation.
                  const SurahReadingOptions(),
                  // ayah list
                  Expanded(
                    child: AppPageScrollbar(
                      builder: (context, controller) => Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: responsive.maxReadingContentWidth,
                          ),
                          child: SurahAyahList(
                            controller: controller,
                            ayahKeys: _ayahKeys,
                            highlightedAyahNumber: _highlightedAyahNumber,
                            playAyahWithFeedback: _playAyahWithFeedback,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.readQuranText('Unable to play this ayah audio right now.'),
          ),
        ),
      );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.readQuranText('Unable to play full surah audio right now.'),
          ),
        ),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.readQuranText(
            'Notification permission is required for audio controls.',
          ),
        ),
        action: permissionResult.shouldPromptToOpenSettings
            ? SnackBarAction(
                label: context.readQuranText('Go to settings'),
                onPressed: () {
                  unawaited(permissionHelper.openSettings());
                },
              )
            : null,
      ),
    );

    return false;
  }

  void _maybeRevealAyah(SurahDetailsViewModel viewModel) {
    final targetAyahNumber = _pendingAyahNumber;
    if (targetAyahNumber == null) {
      return;
    }

    final hasTargetAyah = viewModel.ayahs.any(
      (ayah) => ayah.ayahNumber == targetAyahNumber,
    );
    if (!hasTargetAyah) {
      _pendingAyahNumber = null;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _pendingAyahNumber != targetAyahNumber) {
        return;
      }

      final targetContext = _ayahKeys[targetAyahNumber]?.currentContext;
      if (targetContext == null) {
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
        alignment: 0.15,
      );

      setState(() {
        _highlightedAyahNumber = targetAyahNumber;
        _pendingAyahNumber = null;
      });

      Future<void>.delayed(const Duration(seconds: 2), () {
        if (!mounted || _highlightedAyahNumber != targetAyahNumber) {
          return;
        }

        setState(() {
          _highlightedAyahNumber = null;
        });
      });
    });
  }
}

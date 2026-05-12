import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
import '../../widgets/ayah_tile.dart';
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
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);

    if (!viewModel.isLoading) {
      _maybeRevealAyah(viewModel);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.surah.id}. ${widget.surah.nameEnglish}'),
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
                  Expanded(
                    child: AppPageScrollbar(
                      builder: (context, controller) => Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: responsive.maxReadingContentWidth,
                          ),
                          child: ListView(
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
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm + 2,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeOut,
                                    decoration: BoxDecoration(
                                      color: ayah.ayahNumber ==
                                              _highlightedAyahNumber
                                          ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.08)
                                          : null,
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),
                                      border: ayah.ayahNumber ==
                                              _highlightedAyahNumber
                                          ? Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.42),
                                              width: 1.2,
                                            )
                                          : null,
                                    ),
                                    child: AyahTile(
                                      ayah: ayah,
                                      showPronunciation:
                                          settings.showPronunciation,
                                      showTranslation:
                                          settings.showTranslation,
                                      language: settings.language,
                                      isBookmarked: viewModel.isAyahBookmarked(
                                        ayah.ayahNumber,
                                      ),
                                      isPlaying: viewModel.isAyahPlaying(
                                        ayah.ayahNumber,
                                      ),
                                      onPlay: () => unawaited(
                                        viewModel.isAyahPlaying(ayah.ayahNumber)
                                            ? viewModel.stopPlayback()
                                            : _playAyahWithFeedback(
                                                context,
                                                viewModel,
                                                ayah,
                                              ),
                                      ),
                                      onToggleBookmark: () => unawaited(
                                        viewModel.toggleAyahBookmark(ayah),
                                      ),
                                      onMarkAsLastRead: () => unawaited(
                                        viewModel.markAsLastRead(ayah),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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

  GlobalKey _ayahKeyFor(int ayahNumber) {
    return _ayahKeys.putIfAbsent(ayahNumber, GlobalKey.new);
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../data/models/ayah_model.dart';
import '../../../data/models/surah_model.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/ayah_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/read_quran/surah_details/surah_meta_card.dart';

class SurahDetailsView extends StatelessWidget {
  const SurahDetailsView({super.key, required this.surah});

  final SurahModel surah;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SurahDetailsViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;

    return Scaffold(
      appBar: AppBar(title: Text('${surah.id}. ${surah.nameEnglish}')),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFCF4), Color(0xFFF2E9D8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (viewModel.errorMessage != null)
            EmptyState(
              icon: Icons.error_outline,
              title: context.readQuranText('Could not load surah'),
              message: localizeReadQuranMessage(context, viewModel.errorMessage!),
            )
          else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SurahMetaCard(
                    surah: surah,
                    isPlayingFullSurah: viewModel.isPlayingFullSurah,
                    onTogglePlayback: viewModel.isPlayingFullSurah
                        ? viewModel.stopPlayback
                        : viewModel.playFullSurah,
                  ),
                ),
                Expanded(
                  child: AppPageScrollbar(
                    builder: (context, controller) => ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: viewModel.ayahs.length,
                      itemBuilder: (context, index) {
                        final ayah = viewModel.ayahs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AyahTile(
                            ayah: ayah,
                            showPronunciation: settings.showPronunciation,
                            showTranslation: settings.showTranslation,
                            language: settings.language,
                            onPlay: () => unawaited(
                              _playAyahWithFeedback(context, viewModel, ayah),
                            ),
                            onMarkAsLastRead: () =>
                                viewModel.markAsLastRead(ayah),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _playAyahWithFeedback(
    BuildContext context,
    SurahDetailsViewModel viewModel,
    AyahModel ayah,
  ) async {
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
}

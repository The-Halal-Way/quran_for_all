import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/app_language.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../data/models/surah_model.dart';
import '../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../viewmodels/read_quran/search_viewmodel.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/read_quran/home/continue_reading_card.dart';
import '../../widgets/read_quran/home/read_quran_top_banner.dart';
import '../../widgets/read_quran/home/surah_card.dart';
import '../settings/settings_view.dart';
import 'search_view.dart';
import 'surah_details_view.dart';

class ReadQuranView extends StatelessWidget {
  const ReadQuranView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReadQuranViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final textTheme = Theme.of(context).textTheme;
    final isBangla = settings.language == AppLanguage.bangla;
    final banglaPreview = viewModel.lastReadAyah?.translationBn;
    final ayahPreview = isBangla &&
            banglaPreview != null &&
            banglaPreview.trim().isNotEmpty
        ? banglaPreview
        : viewModel.lastReadAyah?.translationEn;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.readQuranText('Read Quran'),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              context.readQuranText('Quran For All'),
              style: textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () => _openSearch(context),
            icon: const Icon(Icons.search_rounded),
            tooltip: context.readQuranText('Search'),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsView()),
            ),
            icon: const Icon(Icons.settings_outlined),
            tooltip: context.readQuranText('Settings'),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFAF0), Color(0xFFF2E8D3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            RefreshIndicator(
              onRefresh: viewModel.load,
              child: AppPageScrollbar(
                builder: (context, controller) => ListView(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  children: [
                    // Read Quran UI copy uses map-based localization for BN locale.
                    ReadQuranTopBanner(
                      onSearchTap: () => _openSearch(context),
                      surahCount: viewModel.surahs.length,
                    ),
                    const SizedBox(height: 14),
                    if (viewModel.lastRead != null &&
                        viewModel.lastReadSurah != null) ...[
                      ContinueReadingCard(
                        surah: viewModel.lastReadSurah!,
                        ayahNumber: viewModel.lastRead!.ayahNumber,
                        ayahPreview: ayahPreview,
                        onTap: () =>
                            _openSurah(context, viewModel.lastReadSurah!),
                      ),
                      const SizedBox(height: 14),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.readQuranText('All Surahs'),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${viewModel.surahs.length} ${context.readQuranText('total')}',
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final surah in viewModel.surahs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SurahCard(
                          surah: surah,
                          onTap: () => _openSurah(context, surah),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openSearch(BuildContext context) {
    unawaited(context.read<SearchViewModel>().initialize());

    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SearchView()));
  }

  void _openSurah(BuildContext context, SurahModel surah) {
    unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));

    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SurahDetailsView(surah: surah)),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/surah_model.dart';
import '../../../domain/repositories/audio_repository.dart';
import '../../../domain/repositories/quran_repository.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/surah_details_viewmodel.dart';
import '../../widgets/dashboard/continue_reading_card.dart';
import '../../widgets/dashboard/dashboard_top_banner.dart';
import '../../widgets/surah_card.dart';
import '../search/search_view.dart';
import '../settings/settings_view.dart';
import '../surah_details/surah_details_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Read Quran',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Quran For All', style: textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () => _openSearch(context),
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsView()),
            ),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
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
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: [
                  DashboardTopBanner(
                    onSearchTap: () => _openSearch(context),
                    surahCount: viewModel.surahs.length,
                  ),
                  const SizedBox(height: 14),
                  if (viewModel.lastRead != null &&
                      viewModel.lastReadSurah != null) ...[
                    ContinueReadingCard(
                      surah: viewModel.lastReadSurah!,
                      ayahNumber: viewModel.lastRead!.ayahNumber,
                      ayahPreview: viewModel.lastReadAyah?.translationEn,
                      onTap: () =>
                          _openSurah(context, viewModel.lastReadSurah!),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'All Surahs',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Chip(
                        label: Text('${viewModel.surahs.length} total'),
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
        ],
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
          create: (context) {
            final searchViewModel = SearchViewModel(
              context.read<QuranRepository>(),
            );
            unawaited(searchViewModel.initialize());
            return searchViewModel;
          },
          child: const SearchView(),
        ),
      ),
    );
  }

  void _openSurah(BuildContext context, SurahModel surah) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
          create: (context) {
            final surahDetailsViewModel = SurahDetailsViewModel(
              surah: surah,
              quranRepository: context.read<QuranRepository>(),
              audioRepository: context.read<AudioRepository>(),
            );
            unawaited(Future<void>.microtask(surahDetailsViewModel.load));
            return surahDetailsViewModel;
          },
          child: SurahDetailsView(surah: surah),
        ),
      ),
    );
  }
}

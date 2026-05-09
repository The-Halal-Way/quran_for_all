import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/app_language.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/surah_model.dart';
import '../../viewmodels/read_quran/bookmarks_viewmodel.dart';
import '../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../viewmodels/read_quran/search_viewmodel.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/read_quran/home/continue_reading_card.dart';
import '../../widgets/read_quran/home/read_quran_top_banner.dart';
import '../../widgets/read_quran/home/surah_card.dart';
import '../../../core/utils/app_page_route.dart';
import 'bookmarks_view.dart';
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
    final ayahPreview =
        isBangla && banglaPreview != null && banglaPreview.trim().isNotEmpty
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
          IconButton(
            onPressed: () => _openBookmarks(context),
            icon: const Icon(Icons.bookmarks_rounded),
            tooltip: context.readQuranText('Bookmarks'),
          ),
          IconButton.filledTonal(
            onPressed: () => _openSearch(context),
            icon: const Icon(Icons.search_rounded),
            tooltip: context.readQuranText('Search'),
          ),
        ],
      ),
      body: AppGradientBackground(
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: viewModel.load,
                child: AppPageScrollbar(
                  builder: (context, controller) => ListView(
                    controller: controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm + 2,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    children: [
                      ReadQuranTopBanner(
                        onSearchTap: () => _openSearch(context),
                        surahCount: viewModel.surahs.length,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (viewModel.lastRead != null &&
                          viewModel.lastReadSurah != null) ...[
                        ContinueReadingCard(
                          surah: viewModel.lastReadSurah!,
                          ayahNumber: viewModel.lastRead!.ayahNumber,
                          ayahPreview: ayahPreview,
                          onTap: () =>
                              _openSurah(context, viewModel.lastReadSurah!),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      SectionHeader(
                        title: context.readQuranText('All Surahs'),
                        trailing: Chip(
                          label: Text(
                            '${viewModel.surahs.length} ${context.readQuranText('total')}',
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      for (final surah in viewModel.surahs)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.sm + 2,
                          ),
                          child: SurahCard(
                            surah: surah,
                            onTap: () => _openSurah(context, surah),
                            isBookmarked: viewModel.isSurahBookmarked(surah.id),
                            onToggleBookmark: () =>
                                unawaited(viewModel.toggleSurahBookmark(surah)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    unawaited(context.read<SearchViewModel>().initialize());

    Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => const SearchView()));
  }

  void _openBookmarks(BuildContext context) {
    unawaited(context.read<BookmarksViewModel>().load());

    Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => const BookmarksView()));
  }

  void _openSurah(BuildContext context, SurahModel surah) {
    unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));

    Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => SurahDetailsView(surah: surah)));
  }
}

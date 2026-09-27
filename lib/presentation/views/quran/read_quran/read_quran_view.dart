import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/read_quran/bookmarks_viewmodel.dart';
import '../../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/search_viewmodel.dart';
import '../../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/common/app_gradient_background.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/quran/read_quran/home/read_quran_content_list.dart';
import '../../../../core/utils/app_page_route.dart';
import 'bookmarks_view.dart';
import 'search_view.dart';
import 'surah_details_view.dart';

class ReadQuranView extends StatelessWidget {
  const ReadQuranView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReadQuranViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final textTheme = AppTheme.text(context);
    final responsive = AppResponsive.of(context);
    final isBangla = settings.language == AppLanguage.bangla;
    final banglaPreview = viewModel.lastReadAyah?.translationBn;
    final ayahPreview =
        isBangla && banglaPreview != null && banglaPreview.trim().isNotEmpty
        ? banglaPreview
        : viewModel.lastReadAyah?.translationEn;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.readQuranTitle,
              style: textTheme.titleLarge.copyWith(
                fontWeight: AppTheme.weightBold,
              ),
            ),
            Text(context.l10n.readQuranSubtitle, style: textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openBookmarks(context),
            icon: const Icon(CupertinoIcons.bookmark_fill),
            tooltip: context.l10n.readQuranBookmarksTooltip,
          ),
          IconButton(
            onPressed: () => _openSearch(context),
            icon: const Icon(CupertinoIcons.search),
            tooltip: context.l10n.readQuranSearchTooltip,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
      body: AppGradientBackground(
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: viewModel.load,
                child: AppPageScrollbar(
                  builder: (context, controller) => Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: responsive.maxReadingContentWidth,
                      ),
                      child: ReadQuranContentList(
                        controller: controller,
                        surahs: viewModel.surahs,
                        bookmarkedSurahIds: viewModel.bookmarkedSurahIds,
                        lastReadSurah: viewModel.lastReadSurah,
                        lastReadAyahNumber: viewModel.lastRead?.ayahNumber,
                        lastReadPreview: ayahPreview,
                        onSearchTap: () => _openSearch(context),
                        onContinueTap: () => unawaited(
                          _openSurah(
                            context,
                            viewModel.lastReadSurah!,
                            initialAyahNumber: viewModel.lastRead!.ayahNumber,
                          ),
                        ),
                        onSurahTap: (surah) =>
                            unawaited(_openSurah(context, surah)),
                        onToggleBookmark: (surah) =>
                            unawaited(viewModel.toggleSurahBookmark(surah)),
                      ),
                    ),
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

  Future<void> _openSurah(
    BuildContext context,
    SurahModel surah, {
    int? initialAyahNumber,
  }) async {
    unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));

    await Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SurahDetailsView(
          surah: surah,
          initialAyahNumber: initialAyahNumber,
        ),
      ),
    );

    if (!context.mounted) {
      return;
    }

    await context.read<ReadQuranViewModel>().load(showLoading: false);
  }
}

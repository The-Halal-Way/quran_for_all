import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../data/models/bookmark_model.dart';
import '../../viewmodels/read_quran/bookmarks_viewmodel.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/read_quran/bookmarks/bookmark_list_tile.dart';
import 'surah_details_view.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final viewModel = context.read<BookmarksViewModel>();
      if (viewModel.bookmarks.isEmpty && !viewModel.isLoading) {
        unawaited(viewModel.load());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BookmarksViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.readQuranText('Bookmarks'))),
      body: AppGradientBackground(
        child: RefreshIndicator(
          onRefresh: viewModel.load,
          child: Builder(
            builder: (context) {
              if (viewModel.isLoading && viewModel.bookmarks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.errorMessage != null &&
                  viewModel.bookmarks.isEmpty) {
                return EmptyState(
                  icon: Icons.error_outline,
                  title: context.readQuranText('Could not load bookmarks'),
                  message: localizeReadQuranMessage(
                    context,
                    viewModel.errorMessage!,
                  ),
                );
              }

              if (viewModel.bookmarks.isEmpty) {
                return EmptyState(
                  icon: Icons.bookmarks_outlined,
                  title: context.readQuranText('No bookmarks yet'),
                  message: context.readQuranText(
                    'Save ayah or surah bookmarks to find them quickly later.',
                  ),
                );
              }

              return AppPageScrollbar(
                builder: (context, controller) => Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: responsive.maxReadingContentWidth,
                    ),
                    child: ListView.separated(
                      controller: controller,
                      padding: EdgeInsets.fromLTRB(
                        responsive.padding,
                        AppSpacing.sm + 2,
                        responsive.padding,
                        AppSpacing.lg,
                      ),
                      itemCount: viewModel.bookmarks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final bookmark = viewModel.bookmarks[index];
                        final surah = viewModel.surahFor(bookmark.surahId);
                        final ayahNumber = bookmark.ayahNumber;
                        final ayah = ayahNumber == null
                            ? null
                            : viewModel.ayahFor(bookmark.surahId, ayahNumber);

                        return BookmarkListTile(
                          bookmark: bookmark,
                          surah: surah,
                          ayah: ayah,
                          language: settings.language,
                          onTap: () => _openBookmark(context, bookmark),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openBookmark(BuildContext context, BookmarkModel bookmark) {
    final viewModel = context.read<BookmarksViewModel>();
    final surah = viewModel.surahFor(bookmark.surahId);

    if (surah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.readQuranText('Could not open this bookmark.')),
        ),
      );
      return;
    }

    final initialAyahNumber = bookmark.type == BookmarkType.ayah
        ? bookmark.ayahNumber
        : null;

    unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));

    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SurahDetailsView(
          surah: surah,
          initialAyahNumber: initialAyahNumber,
        ),
      ),
    );
  }
}

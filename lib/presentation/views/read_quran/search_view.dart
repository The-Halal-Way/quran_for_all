import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/localization/read_quran_message_localizer.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/models/search_result_model.dart';
import '../../../data/models/surah_model.dart';
import '../../viewmodels/read_quran/search_viewmodel.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_gradient_background.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/read_quran/search/search_query_panel.dart';
import '../../widgets/read_quran/search/search_result_tile.dart';
import '../../../core/utils/app_page_route.dart';
import 'surah_details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 260), () {
      context.read<SearchViewModel>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final responsive = AppResponsive.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.readQuranText('Search Quran'))),
      body: AppGradientBackground(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.sm + 2,
                responsive.padding,
                AppSpacing.md,
              ),
              child: SearchQueryPanel(
                controller: _controller,
                onChanged: _onQueryChanged,
                query: viewModel.query,
                resultCount: viewModel.results.length,
                isLoading: viewModel.isLoading,
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (viewModel.isLoading && viewModel.query.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.query.isEmpty) {
                    return EmptyState(
                      icon: Icons.manage_search_rounded,
                      title: context.readQuranText(
                        'Search Surah, Ayah, or Juz',
                      ),
                      message: context.readQuranText(
                        'Use query formats like 1:1, para 2, or any Bangla/English keyword.',
                      ),
                    );
                  }

                  if (viewModel.errorMessage != null) {
                    return EmptyState(
                      icon: Icons.error_outline,
                      title: context.readQuranText('Search failed'),
                      message: localizeReadQuranMessage(
                        context,
                        viewModel.errorMessage!,
                      ),
                    );
                  }

                  if (viewModel.results.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off,
                      title: context.readQuranText('No results'),
                      message: context.readQuranText(
                        'Try a shorter keyword or a direct ayah reference.',
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
                            0,
                            responsive.padding,
                            AppSpacing.lg,
                          ),
                          itemCount: viewModel.results.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final result = viewModel.results[index];
                            return SearchResultTile(
                              result: result,
                              translationLanguage: settings.language,
                              onTap: () =>
                                  _openResult(context, result, viewModel),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openResult(
    BuildContext context,
    SearchResultModel result,
    SearchViewModel searchViewModel,
  ) {
    final SurahModel? surah;
    int? initialAyahNumber;

    if (result.type == SearchResultType.surah) {
      surah = result.surah;
    } else {
      final ayah = result.ayah;
      if (ayah == null) {
        return;
      }
      surah = searchViewModel.surahById(ayah.surahId);
      initialAyahNumber = ayah.ayahNumber;
    }

    if (surah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.readQuranText('Could not open this result.')),
        ),
      );
      return;
    }

    final selectedSurah = surah;
    unawaited(context.read<SurahDetailsViewModel>().openSurah(selectedSurah));

    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SurahDetailsView(
          surah: selectedSurah,
          initialAyahNumber: initialAyahNumber,
        ),
      ),
    );
  }
}

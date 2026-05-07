import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/search_result_model.dart';
import '../../../data/models/surah_model.dart';
import '../../viewmodels/read_quran/search_viewmodel.dart';
import '../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/common/app_page_scrollbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/read_quran/search/search_query_panel.dart';
import '../../widgets/read_quran/search/search_result_tile.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Search Quran')),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFBEF), Color(0xFFF2E9D8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
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
                      return const EmptyState(
                        icon: Icons.manage_search_rounded,
                        title: 'Search Surah, Ayah, or Juz',
                        message:
                            'Use query formats like 1:1, para 2, or any Bangla/English keyword.',
                      );
                    }

                    if (viewModel.errorMessage != null) {
                      return EmptyState(
                        icon: Icons.error_outline,
                        title: 'Search failed',
                        message: viewModel.errorMessage!,
                      );
                    }

                    if (viewModel.results.isEmpty) {
                      return const EmptyState(
                        icon: Icons.search_off,
                        title: 'No results',
                        message:
                            'Try a shorter keyword or a direct ayah reference.',
                      );
                    }

                    return AppPageScrollbar(
                      builder: (context, controller) => ListView.separated(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: viewModel.results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openResult(
    BuildContext context,
    SearchResultModel result,
    SearchViewModel searchViewModel,
  ) {
    final SurahModel? surah;

    if (result.type == SearchResultType.surah) {
      surah = result.surah;
    } else {
      final ayah = result.ayah;
      if (ayah == null) {
        return;
      }
      surah = searchViewModel.surahById(ayah.surahId);
    }

    if (surah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this result.')),
      );
      return;
    }

    final selectedSurah = surah;
    unawaited(context.read<SurahDetailsViewModel>().openSurah(selectedSurah));

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SurahDetailsView(surah: selectedSurah),
      ),
    );
  }
}

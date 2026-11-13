import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/sunnah/sunnah_catalog.dart';
import '../../../viewmodels/sunnah/sunnah_library_viewmodel.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/sunnah_dua/catalog/dua_catalog_visuals.dart';
import '../../../widgets/sunnah_dua/catalog/dua_language_button.dart';
import '../../../widgets/sunnah_dua/sunnah_catalog/sunnah_category_browser.dart';
import '../../../widgets/sunnah_dua/sunnah_catalog/sunnah_entry_tile.dart';
import '../../../widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_section_search.dart';
import 'sunnah_entry_view.dart';

class SunnahLibraryView extends StatefulWidget {
  const SunnahLibraryView({super.key, this.initialCategory});
  final String? initialCategory;

  @override
  State<SunnahLibraryView> createState() => _SunnahLibraryViewState();
}

class _SunnahLibraryViewState extends State<SunnahLibraryView> {
  late final SunnahLibraryViewModel _model = SunnahLibraryViewModel(
    categoryId: widget.initialCategory,
  )..load();

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _model,
    builder: (context, _) => PopScope(
      canPop: _model.showingCategories || _model.catalog == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _model.selectCategory(null);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.sunnahLibraryTitle),
          actions: const [DuaLanguageButton()],
        ),
        body: AppPremiumPageBackground(child: _body(context)),
      ),
    ),
  );

  Widget _body(BuildContext context) {
    if (_model.loading && _model.catalog == null) {
      return _Status(message: context.l10n.sunnahLoading, loading: true);
    }
    if (_model.error != null || _model.catalog == null) {
      return _Status(
        message: context.l10n.sunnahLoadFailed,
        onRetry: _model.load,
      );
    }
    final catalog = _model.catalog!;
    final language = context.l10n.localeName;
    final padding = EdgeInsets.symmetric(
      horizontal: AppResponsive.of(context).padding,
    );
    final results = _model.showingCategories
        ? const <SunnahEntry>[]
        : _model.results;
    return AppPageScrollbar(
      key: ValueKey(
        'sunnah/${_model.showingCategories}/${_model.categoryId}/${_model.query}',
      ),
      builder: (context, controller) => CustomScrollView(
        controller: controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: padding,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_model.showingCategories) ...[
                    _LibraryHeader(catalog: catalog),
                    const SizedBox(height: AppSpacing.md),
                    SunnahDuaSectionSearch(
                      hint: context.l10n.sunnahLibrarySearchHint,
                      query: _model.query,
                      onChanged: _model.search,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SunnahCategoryBrowser(
                      catalog: catalog,
                      language: language,
                      countLabel: (count) => context.l10n.sunnahPracticeCount(
                        duaNumber(context, count),
                      ),
                      onSelected: _model.selectCategory,
                    ),
                  ] else ...[
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: () => _model.selectCategory(null),
                        icon: const Icon(Icons.grid_view_rounded, size: 18),
                        label: Text(context.l10n.sunnahCategories),
                      ),
                    ),
                    Text(
                      _model.category.title.inLanguage(language),
                      style: AppTheme.text(context).headlineMedium.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SunnahDuaSectionSearch(
                      hint: context.l10n.sunnahLibrarySearchHint,
                      query: _model.query,
                      onChanged: _model.search,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _CategoryChips(model: _model),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          if (!_model.showingCategories && results.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _Status(message: context.l10n.sunnahNoResults),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.of(context).padding,
                0,
                AppResponsive.of(context).padding,
                AppSpacing.huge,
              ),
              sliver: SliverList.separated(
                itemCount: results.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final entry = results[index];
                  return SunnahEntryTile(
                    entry: entry,
                    language: language,
                    typeLabel: (catalog.typeLabels[entry.type] ?? DuaText(null))
                        .inLanguage(language),
                    onTap: () => _open(entry),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _open(SunnahEntry entry) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SunnahEntryView(
          catalog: _model.catalog!,
          entry: entry,
          categoryId: _model.category.id,
          entryIds: _model.category.entryIds,
        ),
      ),
    );
  }
}

class _LibraryHeader extends StatelessWidget {
  const _LibraryHeader({required this.catalog});
  final SunnahCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final language = context.l10n.localeName;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.secondaryContainer],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Icon(Icons.spa_rounded, size: 42, color: scheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catalog.title.inLanguage(language),
                  style: AppTheme.text(context).headlineMedium.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(catalog.description.inLanguage(language)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.model});
  final SunnahLibraryViewModel model;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final category in model.catalog!.categories) ...[
          ChoiceChip(
            label: Text(category.title.inLanguage(context.l10n.localeName)),
            selected: category.id == model.category.id,
            onSelected: (_) =>
                model.selectCategory(category.id, clearSearch: false),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ],
    ),
  );
}

class _Status extends StatelessWidget {
  const _Status({required this.message, this.loading = false, this.onRetry});
  final String message;
  final bool loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const CircularProgressIndicator()
          else
            Icon(
              Icons.spa_rounded,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(height: AppSpacing.md),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(context.l10n.quizRetry)),
        ],
      ),
    ),
  );
}

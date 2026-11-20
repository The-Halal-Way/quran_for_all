import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import '../../../viewmodels/dua/dua_library_viewmodel.dart';
import '../../common/app_page_scrollbar.dart';
import 'dua_category_browser.dart';
import 'dua_category_overview.dart';
import 'dua_entry_tile.dart';
import 'dua_library_filters.dart';
import 'dua_library_header.dart';
import 'dua_library_status.dart';

class DuaLibraryContent extends StatelessWidget {
  const DuaLibraryContent({
    super.key,
    required this.model,
    required this.onOpen,
  });
  final DuaLibraryViewModel model;
  final ValueChanged<DuaEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: AppResponsive.of(context).padding,
    );
    final catalog = model.catalog!;
    final results = model.showingCategories
        ? const <DuaEntry>[]
        : model.results;
    return AppPageScrollbar(
      key: ValueKey(
        'dua/${model.showingCategories}/${model.categoryId}/${model.referenceOnly}/${model.query}',
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
                  if (model.showingCategories) ...[
                    DuaLibraryHeader(catalog: catalog),
                    const SizedBox(height: AppSpacing.lg),
                    DuaCategoryBrowser(
                      catalog: catalog,
                      onSelected: model.selectCategory,
                    ),
                  ] else ...[
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: () => model.selectCategory(null),
                        icon: const Icon(Icons.grid_view_rounded, size: 17),
                        label: Text(context.l10n.duaCategories),
                      ),
                    ),
                    DuaCategoryOverview(
                      category: model.category,
                      description: model.category.id == catalog.allId
                          ? context.l10n.duaLibraryInsightsHint
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DuaLibraryFilters(model: model),
                    const SizedBox(height: AppSpacing.md),
                    if (model.referenceOnly) ...[
                      Text(
                        DuaText(
                          catalog.sourceNotes['description'],
                        ).inLanguage(context.l10n.localeName),
                        style: AppTheme.text(context).bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    if (results.isEmpty) const DuaLibraryStatus(),
                  ],
                ],
              ),
            ),
          ),
          if (!model.showingCategories)
            SliverPadding(
              padding: padding,
              sliver: SliverList.builder(
                itemCount: results.length,
                itemBuilder: (context, index) => DuaEntryTile(
                  key: ValueKey(results[index].id),
                  entry: results[index],
                  categoryId: model.categoryId,
                  onTap: () => onOpen(results[index]),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.huge)),
        ],
      ),
    );
  }
}

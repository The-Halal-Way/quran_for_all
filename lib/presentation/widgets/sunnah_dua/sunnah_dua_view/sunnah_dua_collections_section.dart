import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../models/sunnah_dua_shortcut.dart';
import '../../common/app_premium_section_title.dart';
import 'sunnah_dua_empty_state.dart';
import 'sunnah_dua_section_search.dart';
import 'sunnah_dua_shortcut_carousel.dart';

class SunnahDuaCollectionsSection extends StatelessWidget {
  const SunnahDuaCollectionsSection({
    super.key,
    required this.items,
    required this.query,
    required this.onSearch,
    required this.onSelected,
  });

  final List<SunnahDuaShortcut> items;
  final String query;
  final ValueChanged<String> onSearch;
  final ValueChanged<SunnahDuaShortcut> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppPremiumSectionTitle(title: context.l10n.sunnahDuaCollectionsTitle),
      const SizedBox(height: AppSpacing.xs),
      Text(
        context.l10n.sunnahDuaCollectionsSubtitle,
        style: AppTheme.text(context).bodySmall,
      ),
      const SizedBox(height: AppSpacing.md),
      SunnahDuaSectionSearch(
        key: const ValueKey('collections-search'),
        hint: context.l10n.sunnahDuaSearchCollections,
        query: query,
        onChanged: onSearch,
      ),
      const SizedBox(height: AppSpacing.md),
      if (items.isEmpty)
        SunnahDuaEmptyState(onClear: () => onSearch(''))
      else
        SunnahDuaShortcutCarousel(items: items, onSelected: onSelected),
    ],
  );
}

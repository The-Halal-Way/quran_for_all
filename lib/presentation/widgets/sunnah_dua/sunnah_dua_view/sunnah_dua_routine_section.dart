import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../models/sunnah_dua_item.dart';
import '../../common/app_premium_section_title.dart';
import 'sunnah_dua_empty_state.dart';
import 'sunnah_dua_grid.dart';
import 'sunnah_dua_item_count.dart';
import 'sunnah_dua_phase_header.dart';
import 'sunnah_dua_section_search.dart';

class SunnahDuaRoutineSection extends StatelessWidget {
  const SunnahDuaRoutineSection({
    super.key,
    required this.items,
    required this.query,
    required this.onSearch,
    required this.onItemTap,
  });

  final List<SunnahDuaItem> items;
  final String query;
  final ValueChanged<String> onSearch;
  final ValueChanged<SunnahDuaItem> onItemTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppPremiumSectionTitle(
        title: context.l10n.sunnahDuaRoutineTitle,
        trailing: SunnahDuaItemCount(count: items.length),
      ),
      const SizedBox(height: AppSpacing.md),
      SunnahDuaSectionSearch(
        key: const ValueKey('routine-search'),
        hint: context.l10n.sunnahDuaSearchRoutine,
        query: query,
        onChanged: onSearch,
      ),
      if (items.isEmpty) ...[
        const SizedBox(height: AppSpacing.md),
        SunnahDuaEmptyState(onClear: () => onSearch('')),
      ],
      for (final phase in SunnahDayPhase.values)
        if (items.any((item) => item.phase == phase)) ...[
          SunnahDuaPhaseHeader(phase: phase),
          SunnahDuaGrid(
            items: items.where((item) => item.phase == phase).toList(),
            kindLabelBuilder: (_) => context.l10n.sunnahDuaKindSunnah,
            onItemTap: onItemTap,
          ),
        ],
    ],
  );
}

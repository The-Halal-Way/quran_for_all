import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../models/sunnah_dua_item.dart';
import '../../common/app_icon_grid_section.dart';

class SunnahDuaQuranSection extends StatelessWidget {
  const SunnahDuaQuranSection({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<SunnahDuaItem> items;
  final ValueChanged<SunnahDuaItem> onItemTap;

  @override
  Widget build(BuildContext context) => AppIconGridSection(
    title: context.l10n.sunnahDuaQuranTitle,
    subtitle: context.l10n.sunnahDuaQuranSubtitle,
    phoneColumns: 3,
    labelMaxLines: 3,
    items: [
      for (final item in items)
        AppIconGridItem(
          icon: item.icon,
          label: item.title,
          description:
              '${item.source}. ${item.benefits.isEmpty ? item.subtitle : item.benefits.first}',
          accent: item.accent,
          onTap: () => onItemTap(item),
        ),
    ],
  );
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../models/sunnah_dua_shortcut.dart';
import '../../common/app_icon_grid_section.dart';

class SunnahDuaMoreSection extends StatelessWidget {
  const SunnahDuaMoreSection({
    super.key,
    required this.items,
    required this.onSelected,
  });

  final List<SunnahDuaShortcut> items;
  final ValueChanged<SunnahDuaShortcut> onSelected;

  @override
  Widget build(BuildContext context) => AppIconGridSection(
    title: context.l10n.sunnahDuaMoreTitle,
    subtitle: context.l10n.sunnahDuaMoreSubtitle,
    items: [
      for (final item in items)
        AppIconGridItem(
          icon: item.icon,
          label: item.title,
          description: item.subtitle,
          accent: item.accent,
          onTap: () => onSelected(item),
        ),
    ],
  );
}

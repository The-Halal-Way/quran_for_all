import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../models/sunnah_dua_shortcut.dart';
import 'sunnah_dua_shortcut_card.dart';

class SunnahDuaShortcutCarousel extends StatelessWidget {
  const SunnahDuaShortcutCarousel({
    super.key,
    required this.items,
    required this.onSelected,
  });
  final List<SunnahDuaShortcut> items;
  final ValueChanged<SunnahDuaShortcut> onSelected;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return SizedBox(
      height: 164 + (scale - 1).clamp(0, 3) * 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => SizedBox(
          width: 174 + (scale - 1).clamp(0, 1) * 44,
          child: SunnahDuaShortcutCard(
            key: ValueKey(items[index].id),
            item: items[index],
            onTap: () => onSelected(items[index]),
          ),
        ),
      ),
    );
  }
}

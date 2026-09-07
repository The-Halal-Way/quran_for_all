import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../models/sunnah_dua_item.dart';
import 'sunnah_dua_card.dart';

class SunnahDuaGrid extends StatelessWidget {
  const SunnahDuaGrid({
    super.key,
    required this.items,
    required this.kindLabelBuilder,
    required this.onItemTap,
  });

  final List<SunnahDuaItem> items;
  final String Function(SunnahDuaKind kind) kindLabelBuilder;
  final ValueChanged<SunnahDuaItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final columns = constraints.maxWidth < 270 || scale > 1.6
            ? 1
            : constraints.maxWidth >= 940
            ? 4
            : constraints.maxWidth >= 680
            ? 3
            : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            mainAxisExtent: 216 + (scale - 1).clamp(0, 3) * 130,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return SunnahDuaCard(
              key: ValueKey(item.id),
              item: item,
              kindLabel: kindLabelBuilder(item.kind),
              onTap: () => onItemTap(item),
            );
          },
        );
      },
    );
  }
}

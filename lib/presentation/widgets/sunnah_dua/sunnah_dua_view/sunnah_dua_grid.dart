import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/sunnah_dua/sunnah_dua_models.dart';
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
        final columns = constraints.maxWidth >= 940
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
            mainAxisExtent: 148,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return SunnahDuaCard(
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

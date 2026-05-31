import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/data/models/sunnah_dua/sunnah_dua_models.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_card.dart';

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
        final width = constraints.maxWidth;
        final columns = width >= 940
            ? 4
            : width >= 680
            ? 3
            : 2;
        final extent = width >= 680 ? 198.0 : 186.0;

        // Fixed extents keep the navbar page stable as localized text changes.
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            mainAxisExtent: extent,
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

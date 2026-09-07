import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import 'powerful_duah_card.dart';
import 'powerful_duah_data.dart';

class PowerfulDuahGrid extends StatelessWidget {
  const PowerfulDuahGrid({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<PowerfulDuah> items;
  final ValueChanged<PowerfulDuah> onItemTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            mainAxisExtent: 174,
          ),
          itemBuilder: (context, index) => PowerfulDuahCard(
            duah: items[index],
            onTap: () => onItemTap(items[index]),
          ),
        );
      },
    );
  }
}

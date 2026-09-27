import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';
import 'eid_kind_option.dart';

class EidKindSwitcher extends StatelessWidget {
  const EidKindSwitcher({
    super.key,
    required this.selected,
    required this.bangla,
    required this.onSelected,
  });

  final EidKind selected;
  final bool bangla;
  final ValueChanged<EidKind> onSelected;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 360 || scale > 1.45;
        final fitr = EidKindOption(
          kind: EidKind.fitr,
          selected: selected == EidKind.fitr,
          bangla: bangla,
          onTap: () => onSelected(EidKind.fitr),
        );
        final adha = EidKindOption(
          kind: EidKind.adha,
          selected: selected == EidKind.adha,
          bangla: bangla,
          onTap: () => onSelected(EidKind.adha),
        );
        if (stacked) {
          return Column(
            children: [
              fitr,
              const SizedBox(height: AppSpacing.sm),
              adha,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: fitr),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: adha),
          ],
        );
      },
    );
  }
}

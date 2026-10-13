import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class TasbeehInfoGrid extends StatelessWidget {
  const TasbeehInfoGrid({
    super.key,
    required this.isWide,
    required this.targetSelector,
    required this.statsPanel,
  });
  final bool isWide;
  final Widget targetSelector;
  final Widget statsPanel;

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return Column(
        children: [
          targetSelector,
          const SizedBox(height: AppSpacing.sm),
          statsPanel,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: targetSelector),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: statsPanel),
      ],
    );
  }
}

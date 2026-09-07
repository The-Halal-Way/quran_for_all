import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';

class PowerfulDuahTextPanel extends StatelessWidget {
  const PowerfulDuahTextPanel({
    super.key,
    required this.accent,
    required this.child,
  });

  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: child,
    );
  }
}

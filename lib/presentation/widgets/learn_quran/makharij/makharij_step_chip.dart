import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

class MakharijStepChip extends StatelessWidget {
  const MakharijStepChip({super.key, required this.step, required this.label});

  final int step;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: colorScheme.primary,
            child: Text(
              '$step',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            context.learnText(label),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

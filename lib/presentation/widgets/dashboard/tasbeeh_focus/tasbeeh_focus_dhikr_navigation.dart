import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../tasbeeh/tasbeeh_visuals.dart';

class TasbeehFocusDhikrNavigation extends StatelessWidget {
  const TasbeehFocusDhikrNavigation({
    super.key,
    required this.index,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  final int index;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    final number = NumberFormat.decimalPattern(l10n.localeName);
    final style = IconButton.styleFrom(
      foregroundColor: TasbeehVisuals.mint,
      disabledForegroundColor: Colors.white.withValues(alpha: 0.2),
      backgroundColor: Colors.white.withValues(alpha: 0.06),
    );
    // Consume taps here so even a disabled arrow cannot increment the counter.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            key: const ValueKey('tasbeeh_focus_previous_dhikr'),
            tooltip: l10n.tasbeehPreviousDhikr,
            onPressed: index > 0 ? onPrevious : null,
            style: style,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.tasbeehSwipeDhikr,
                  textAlign: TextAlign.center,
                  style: text.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${number.format(index + 1)} / ${number.format(total)}',
                  style: text.labelSmall.copyWith(color: TasbeehVisuals.mint),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            key: const ValueKey('tasbeeh_focus_next_dhikr'),
            tooltip: l10n.tasbeehNextDhikr,
            onPressed: index < total - 1 ? onNext : null,
            style: style,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

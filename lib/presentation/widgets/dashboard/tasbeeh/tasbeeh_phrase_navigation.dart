import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import 'tasbeeh_visuals.dart';

enum TasbeehPhraseNavigationDirection { previous, next }

class TasbeehPhraseNavigationButton extends StatelessWidget {
  const TasbeehPhraseNavigationButton({
    super.key,
    required this.direction,
    required this.onPressed,
  });

  final TasbeehPhraseNavigationDirection direction;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isPrevious = direction == TasbeehPhraseNavigationDirection.previous;
    final foreground = onPressed == null
        ? Colors.white.withValues(alpha: 0.2)
        : TasbeehVisuals.mint;
    // Keep a disabled arrow from bubbling into the counter's outer tap area.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: () {},
      child: IconButton(
        onPressed: onPressed,
        tooltip: isPrevious
            ? context.l10n.tasbeehPreviousDhikr
            : context.l10n.tasbeehNextDhikr,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: foreground,
          disabledForegroundColor: foreground,
          backgroundColor: Colors.white.withValues(
            alpha: onPressed == null ? 0.035 : 0.09,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
          ),
        ),
        icon: Icon(
          isPrevious ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
          size: 25,
        ),
      ),
    );
  }
}

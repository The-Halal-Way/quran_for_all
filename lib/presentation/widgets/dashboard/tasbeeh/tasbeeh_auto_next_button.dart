import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_visuals.dart';

/// Advances selection at the target; counting always remains tap driven.
class TasbeehAutoNextButton extends StatelessWidget {
  const TasbeehAutoNextButton({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.onHero = false,
    this.compact = false,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;
  final bool onHero;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = onHero ? TasbeehVisuals.mint : scheme.primary;
    final foreground = enabled
        ? accent
        : onHero
        ? Colors.white70
        : scheme.onSurfaceVariant;
    final label = enabled
        ? context.l10n.tasbeehAutoNextOn
        : context.l10n.tasbeehAutoNextOff;
    final icon = Icon(
      enabled
          ? Icons.play_circle_fill_rounded
          : Icons.play_circle_outline_rounded,
      size: 23,
    );
    return Tooltip(
      message: '$label\n${context.l10n.tasbeehAutoNextDescription}',
      child: Semantics(
        toggled: enabled,
        label: compact ? label : null,
        child: compact
            ? IconButton(
                key: const ValueKey('tasbeeh_auto_next'),
                onPressed: () => onChanged(!enabled),
                icon: icon,
                style: IconButton.styleFrom(
                  foregroundColor: foreground,
                  backgroundColor: enabled
                      ? accent.withValues(alpha: .12)
                      : Colors.transparent,
                ),
              )
            : TextButton.icon(
                key: const ValueKey('tasbeeh_auto_next'),
                onPressed: () => onChanged(!enabled),
                icon: icon,
                label: Text(label),
                style: TextButton.styleFrom(
                  foregroundColor: foreground,
                  backgroundColor: enabled
                      ? accent.withValues(alpha: .12)
                      : Colors.transparent,
                  textStyle: AppTheme.text(
                    context,
                  ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';

class TasbeehUndoButton extends StatelessWidget {
  const TasbeehUndoButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FilledButton.tonalIcon(
      onPressed: enabled ? onPressed : null,
      icon: const Icon(CupertinoIcons.minus_circle, size: 18),
      label: Text(context.l10n.tasbeehUndo),
      style: FilledButton.styleFrom(
        backgroundColor: colors.secondaryContainer,
        foregroundColor: colors.onSecondaryContainer,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.08),
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        textStyle: AppTheme.text(
          context,
        ).labelMedium.copyWith(fontWeight: FontWeight.w800),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

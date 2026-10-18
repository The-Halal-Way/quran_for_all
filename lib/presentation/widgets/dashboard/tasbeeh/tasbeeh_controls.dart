import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/app_theme_colors.dart';
import 'tasbeeh_undo_button.dart';

class TasbeehControls extends StatelessWidget {
  const TasbeehControls({
    super.key,
    required this.isDark,
    required this.canUndo,
    required this.canResetCount,
    required this.canResetAll,
    required this.onUndo,
    required this.onResetCount,
    required this.onResetAll,
  });

  final bool isDark;
  final bool canUndo;
  final bool canResetCount;
  final bool canResetAll;
  final VoidCallback onUndo;
  final VoidCallback onResetCount;
  final VoidCallback onResetAll;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    final foreground = colors.onSurface;

    return Row(
      children: [
        Expanded(
          child: TasbeehUndoButton(enabled: canUndo, onPressed: onUndo),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canResetCount ? onResetCount : null,
            icon: const Icon(CupertinoIcons.arrow_counterclockwise, size: 17),
            label: Text(context.l10n.tasbeehReset),
            style: OutlinedButton.styleFrom(
              foregroundColor: foreground.withValues(alpha: 0.82),
              side: BorderSide(color: colors.outlineVariant),
              textStyle: text.labelMedium.copyWith(fontWeight: FontWeight.w800),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton.filledTonal(
          onPressed: canResetAll ? onResetAll : null,
          tooltip: context.l10n.tasbeehResetAll,
          icon: const Icon(CupertinoIcons.trash, size: 18),
          style: IconButton.styleFrom(
            foregroundColor: isDark
                ? colors.secondary
                : AppThemeColors.light.coral,
            minimumSize: const Size(42, 42),
          ),
        ),
      ],
    );
  }
}

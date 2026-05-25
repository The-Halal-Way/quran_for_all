import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class TasbeehControls extends StatelessWidget {
  const TasbeehControls({
    super.key,
    required this.isDark,
    required this.canUndo,
    required this.onUndo,
    required this.onResetCount,
    required this.onResetAll,
  });

  final bool isDark;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onResetCount;
  final VoidCallback onResetAll;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final foreground = isDark ? Colors.white : MyColors.textPrimary;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        OutlinedButton.icon(
          onPressed: canUndo ? onUndo : null,
          icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
          label: Text(context.l10n.tasbeehUndo),
          style: OutlinedButton.styleFrom(
            foregroundColor: foreground.withValues(alpha: 0.82),
            side: BorderSide(color: foreground.withValues(alpha: 0.14)),
            textStyle: text.labelMedium.copyWith(fontWeight: FontWeight.w800),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        FilledButton.icon(
          onPressed: onResetCount,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(context.l10n.tasbeehReset),
          style: FilledButton.styleFrom(
            backgroundColor: MyColors.primaryLight,
            foregroundColor: Colors.white,
            textStyle: text.labelMedium.copyWith(fontWeight: FontWeight.w800),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        TextButton.icon(
          onPressed: onResetAll,
          icon: const Icon(Icons.restart_alt_rounded, size: 18),
          label: Text(context.l10n.tasbeehResetAll),
          style: TextButton.styleFrom(
            foregroundColor: MyColors.secondary,
            textStyle: text.labelMedium.copyWith(fontWeight: FontWeight.w800),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

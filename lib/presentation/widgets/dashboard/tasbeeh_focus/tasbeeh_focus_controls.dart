import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../tasbeeh/tasbeeh_visuals.dart';

class TasbeehFocusControls extends StatelessWidget {
  const TasbeehFocusControls({
    super.key,
    required this.canUndo,
    required this.onUndo,
    required this.rounds,
  });

  final bool canUndo;
  final VoidCallback onUndo;
  final int rounds;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: AppSpacing.md,
    runSpacing: AppSpacing.sm,
    children: [
      OutlinedButton.icon(
        onPressed: canUndo ? onUndo : null,
        icon: const Icon(Icons.undo_rounded, size: 18),
        label: Text(context.l10n.tasbeehUndo),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.4),
          backgroundColor: Colors.white.withValues(alpha: 0.12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.26)),
          textStyle: AppTheme.text(
            context,
          ).labelMedium.copyWith(fontWeight: FontWeight.w800),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.full),
          color: Colors.white.withValues(alpha: 0.12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.all_inclusive_rounded,
              size: 18,
              color: TasbeehVisuals.gold,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                '${context.l10n.tasbeehRounds} · $rounds',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(context).labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

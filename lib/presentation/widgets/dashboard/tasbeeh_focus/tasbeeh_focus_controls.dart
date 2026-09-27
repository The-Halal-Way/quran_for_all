import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../tasbeeh/tasbeeh_undo_button.dart';

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
    spacing: 18,
    runSpacing: 8,
    children: [
      TasbeehUndoButton(enabled: canUndo, onPressed: onUndo),
      Text(
        '${context.l10n.tasbeehRounds} · $rounds',
        style: AppTheme.text(context).labelMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}

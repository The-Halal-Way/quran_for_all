import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import 'tasbeeh_session_actions.dart';

class TasbeehSessionMenu extends StatelessWidget {
  const TasbeehSessionMenu({super.key, required this.onSelected});

  final ValueChanged<TasbeehSessionAction> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<TasbeehSessionAction>(
    tooltip: context.l10n.tasbeehSessionOptions,
    onSelected: onSelected,
    icon: const Icon(Icons.more_horiz_rounded),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: TasbeehSessionAction.rename,
        child: Row(
          children: [
            const Icon(Icons.edit_outlined, size: 19),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(context.l10n.tasbeehRenameSession)),
          ],
        ),
      ),
      PopupMenuItem(
        value: TasbeehSessionAction.delete,
        child: Row(
          children: [
            Icon(
              Icons.delete_outline_rounded,
              size: 19,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.tasbeehDeleteSession,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

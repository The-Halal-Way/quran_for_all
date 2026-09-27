import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'tasbeeh_phrase_actions.dart';

class TasbeehPhraseMenu extends StatelessWidget {
  const TasbeehPhraseMenu({super.key, required this.onSelected});
  final ValueChanged<TasbeehPhraseAction> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<TasbeehPhraseAction>(
    tooltip: context.l10n.tasbeehPhraseOptions,
    onSelected: onSelected,
    icon: const Icon(Icons.more_horiz_rounded, size: 20),
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: TasbeehPhraseAction.edit,
        child: Text(context.l10n.tasbeehEditDhikr),
      ),
      PopupMenuItem(
        value: TasbeehPhraseAction.delete,
        child: Text(
          context.l10n.tasbeehDeleteDhikr,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ],
  );
}

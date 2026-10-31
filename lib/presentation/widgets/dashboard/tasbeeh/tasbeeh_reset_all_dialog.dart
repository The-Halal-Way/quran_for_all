import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

Future<bool> confirmTasbeehResetAll(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.tasbeehResetAllTitle),
        content: Text(context.l10n.tasbeehResetAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(context.l10n.tasbeehResetAll),
          ),
        ],
      ),
    ) ??
    false;

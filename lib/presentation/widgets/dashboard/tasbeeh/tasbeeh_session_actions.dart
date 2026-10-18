import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/tasbeeh_session.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'tasbeeh_session_editor.dart';

enum TasbeehSessionAction { rename, delete }

class TasbeehSessionActions {
  const TasbeehSessionActions._();

  static Future<void> handle(
    BuildContext context,
    TasbeehViewModel model,
    TasbeehSession session,
    TasbeehSessionAction action,
  ) async {
    if (session.isDefault) return;
    if (action == TasbeehSessionAction.rename) {
      await renameTasbeehSession(context, model, session);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.tasbeehDeleteSession),
        content: Text(context.l10n.tasbeehDeleteSessionConfirm(session.name)),
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
            child: Text(context.l10n.tasbeehDeleteSession),
          ),
        ],
      ),
    );
    if (confirmed ?? false) model.deleteSession(session.id);
  }
}

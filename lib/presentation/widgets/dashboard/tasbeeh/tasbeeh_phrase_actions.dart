import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'tasbeeh_phrase_editor_sheet.dart';
import 'tasbeeh_phrase_localizer.dart';

enum TasbeehPhraseAction { edit, delete }

class TasbeehPhraseActions {
  const TasbeehPhraseActions._();

  static Future<void> add(BuildContext context, TasbeehViewModel model) async {
    final draft = await showTasbeehPhraseEditor(context);
    if (draft != null) {
      model.addPhrase(
        name: draft.name,
        arabic: draft.arabic,
        meaning: draft.meaning,
        target: draft.target,
      );
    }
  }

  static Future<void> handle(
    BuildContext context,
    TasbeehViewModel model,
    TasbeehPhrase phrase,
    TasbeehPhraseAction action,
  ) async {
    if (phrase.isBuiltIn) return;
    if (action == TasbeehPhraseAction.edit) {
      final draft = await showTasbeehPhraseEditor(
        context,
        phrase: phrase,
        target: model.targetFor(phrase.id),
      );
      if (draft != null) {
        model.editPhrase(
          id: phrase.id,
          name: draft.name,
          arabic: draft.arabic,
          meaning: draft.meaning,
          target: draft.target,
        );
      }
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.tasbeehDeleteDhikr),
        content: Text(
          context.l10n.tasbeehDeleteConfirm(phrase.label(context.l10n)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.tasbeehDeleteDhikr),
          ),
        ],
      ),
    );
    if (confirmed ?? false) model.deletePhrase(phrase.id);
  }
}

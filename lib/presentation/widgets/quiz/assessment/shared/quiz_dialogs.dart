import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';

Future<bool> confirmQuizDiscard(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.quizDiscardTitle),
        content: Text(context.l10n.quizDiscardMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.quizDiscard),
          ),
        ],
      ),
    ) ??
    false;

Future<bool> confirmQuizSubmission(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.quizSubmitTitle),
        content: Text(context.l10n.quizSubmitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.quizKeepGoing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.quizSubmitAnyway),
          ),
        ],
      ),
    ) ??
    false;

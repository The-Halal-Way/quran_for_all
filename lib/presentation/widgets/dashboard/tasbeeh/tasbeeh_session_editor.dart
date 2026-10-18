import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/tasbeeh_session.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';

Future<void> createTasbeehSession(
  BuildContext context,
  TasbeehViewModel model,
) async {
  final name = await showDialog<String>(
    context: context,
    builder: (_) => const _SessionNameDialog(),
  );
  if (name != null) model.createSession(name);
}

Future<void> renameTasbeehSession(
  BuildContext context,
  TasbeehViewModel model,
  TasbeehSession session,
) async {
  if (session.isDefault) return;
  final name = await showDialog<String>(
    context: context,
    builder: (_) => _SessionNameDialog(initialName: session.name),
  );
  if (name != null) model.renameSession(session.id, name);
}

class _SessionNameDialog extends StatefulWidget {
  const _SessionNameDialog({this.initialName});

  final String? initialName;

  @override
  State<_SessionNameDialog> createState() => _SessionNameDialogState();
}

class _SessionNameDialogState extends State<_SessionNameDialog> {
  late final _controller = TextEditingController(
    text: widget.initialName ?? '',
  );
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.initialName == null
          ? context.l10n.tasbeehNewSession
          : context.l10n.tasbeehRenameSession,
    ),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialName == null
                ? context.l10n.tasbeehNewSessionDescription
                : context.l10n.tasbeehRenameSessionDescription,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: const ValueKey('tasbeeh_session_name'),
            controller: _controller,
            autofocus: true,
            maxLength: TasbeehSession.maxNameLength,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: context.l10n.tasbeehSessionName,
              hintText: context.l10n.tasbeehSessionNameHint,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.tasbeehSessionNameRequired
                : null,
            onFieldSubmitted: (_) => _submit(),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
      ),
      FilledButton(
        onPressed: _submit,
        child: Text(
          widget.initialName == null
              ? context.l10n.tasbeehCreateSession
              : context.l10n.tasbeehSaveSessionTitle,
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'science_in_quran_labels.dart';

class ScienceInQuranJumpDialog extends StatefulWidget {
  const ScienceInQuranJumpDialog({
    super.key,
    required this.page,
    required this.pageCount,
  });

  final int page;
  final int pageCount;

  @override
  State<ScienceInQuranJumpDialog> createState() =>
      _ScienceInQuranJumpDialogState();
}

class _ScienceInQuranJumpDialogState extends State<ScienceInQuranJumpDialog> {
  final _form = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: '${widget.page}');

  int? _parsePage(String value) {
    final page = int.tryParse(value.trim());
    return page != null && page >= 1 && page <= widget.pageCount ? page : null;
  }

  void _submit() {
    if (_form.currentState!.validate()) {
      Navigator.pop(context, _parsePage(_controller.text));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(context.l10n.scienceInQuranJump),
    content: Form(
      key: _form,
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.go,
        onFieldSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: context.l10n.scienceInQuranPageField,
          helperText: context.l10n.scienceInQuranPageRange(
            scienceNumber(context, widget.pageCount),
          ),
        ),
        validator: (value) => _parsePage(value ?? '') == null
            ? context.l10n.scienceInQuranPageRange(
                scienceNumber(context, widget.pageCount),
              )
            : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.scienceInQuranCancel),
      ),
      FilledButton(
        onPressed: _submit,
        child: Text(context.l10n.scienceInQuranGo),
      ),
    ],
  );
}

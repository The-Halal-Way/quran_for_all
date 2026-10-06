import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import 'nurani_quran_labels.dart';

class NuraniQuranJumpDialog extends StatefulWidget {
  const NuraniQuranJumpDialog({
    super.key,
    required this.page,
    required this.pageCount,
  });

  final int page;
  final int pageCount;

  @override
  State<NuraniQuranJumpDialog> createState() => _NuraniQuranJumpDialogState();
}

class _NuraniQuranJumpDialogState extends State<NuraniQuranJumpDialog> {
  final _form = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: '${widget.page}');

  int? _parsePage(String value) {
    final ascii = value.trim().replaceAllMapped(RegExp(r'[০-৯٠-٩۰-۹]'), (
      match,
    ) {
      final code = match.group(0)!.runes.single;
      final offset = code >= 0x09E6 && code <= 0x09EF
          ? 0x09E6
          : code >= 0x0660 && code <= 0x0669
          ? 0x0660
          : 0x06F0;
      return '${code - offset}';
    });
    final page = int.tryParse(ascii);
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
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(context.l10n.nuraniQuranJump),
      content: Form(
        key: _form,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: context.l10n.nuraniQuranPageField,
            helperText: context.l10n.nuraniQuranPageRange(
              nuraniNumber(context, widget.pageCount),
            ),
            helperMaxLines: 2,
            errorMaxLines: 2,
          ),
          validator: (value) => _parsePage(value ?? '') == null
              ? context.l10n.nuraniQuranPageRange(
                  nuraniNumber(context, widget.pageCount),
                )
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.nuraniQuranCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(context.l10n.nuraniQuranGo),
        ),
      ],
    );
  }
}

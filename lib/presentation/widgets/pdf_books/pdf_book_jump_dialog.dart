import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import 'pdf_book_labels.dart';

class PdfBookJumpDialog extends StatefulWidget {
  const PdfBookJumpDialog({
    super.key,
    required this.page,
    required this.pageCount,
  });

  final int page;
  final int pageCount;

  @override
  State<PdfBookJumpDialog> createState() => _PdfBookJumpDialogState();
}

class _PdfBookJumpDialogState extends State<PdfBookJumpDialog> {
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
    title: Text(context.l10n.pdfBookJump),
    content: Form(
      key: _form,
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.go,
        onFieldSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: context.l10n.pdfBookPageField,
          helperText: context.l10n.pdfBookPageRange(
            pdfBookNumber(context, widget.pageCount),
          ),
        ),
        validator: (value) => _parsePage(value ?? '') == null
            ? context.l10n.pdfBookPageRange(
                pdfBookNumber(context, widget.pageCount),
              )
            : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.pdfBookCancel),
      ),
      FilledButton(onPressed: _submit, child: Text(context.l10n.pdfBookGo)),
    ],
  );
}

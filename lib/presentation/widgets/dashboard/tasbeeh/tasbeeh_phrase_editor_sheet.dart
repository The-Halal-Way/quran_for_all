import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import '../../../models/tasbeeh_phrase_draft.dart';
import 'tasbeeh_target_field.dart';

Future<TasbeehPhraseDraft?> showTasbeehPhraseEditor(
  BuildContext context, {
  TasbeehPhrase? phrase,
  int target = 33,
}) {
  if (phrase?.isBuiltIn ?? false) return Future.value(null);
  return showModalBottomSheet<TasbeehPhraseDraft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => TasbeehPhraseEditorSheet(phrase: phrase, target: target),
  );
}

class TasbeehPhraseEditorSheet extends StatefulWidget {
  const TasbeehPhraseEditorSheet({super.key, this.phrase, this.target = 33});
  final TasbeehPhrase? phrase;
  final int target;

  @override
  State<TasbeehPhraseEditorSheet> createState() =>
      _TasbeehPhraseEditorSheetState();
}

class _TasbeehPhraseEditorSheetState extends State<TasbeehPhraseEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.phrase?.name ?? '');
  late final _arabic = TextEditingController(text: widget.phrase?.arabic ?? '');
  late final _target = TextEditingController(text: '${widget.target}');

  @override
  void dispose() {
    _name.dispose();
    _arabic.dispose();
    _target.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(
      context,
      TasbeehPhraseDraft(
        name: _name.text.trim(),
        arabic: _arabic.text.trim(),
        target: int.parse(_target.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.phrase == null
                    ? context.l10n.tasbeehAddDhikr
                    : context.l10n.tasbeehEditDhikr,
                style: text.titleLarge.copyWith(fontWeight: FontWeight.w800),
              ),
              if (widget.phrase != null) ...[
                const SizedBox(height: 6),
                Text(
                  context.l10n.tasbeehEditPreservesCount,
                  style: text.bodySmall,
                ),
              ],
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('tasbeeh_name_field'),
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLength: TasbeehPhrase.maxNameLength,
                decoration: InputDecoration(
                  labelText: context.l10n.tasbeehNameLabel,
                  hintText: context.l10n.tasbeehNameHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.tasbeehNameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('tasbeeh_arabic_field'),
                controller: _arabic,
                textDirection: TextDirection.rtl,
                minLines: 1,
                maxLines: 3,
                maxLength: TasbeehPhrase.maxArabicLength,
                style: AppTheme.amiri(context, fontSize: 23),
                decoration: InputDecoration(
                  labelText: context.l10n.tasbeehArabicLabel,
                ),
              ),
              const SizedBox(height: 12),
              TasbeehTargetField(controller: _target),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(context.l10n.tasbeehSaveDhikr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

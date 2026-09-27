import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_target_field.dart';

Future<int?> showTasbeehTargetSheet(BuildContext context, int target) =>
    showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => TasbeehTargetSheet(target: target),
    );

class TasbeehTargetSheet extends StatefulWidget {
  const TasbeehTargetSheet({super.key, required this.target});
  final int target;

  @override
  State<TasbeehTargetSheet> createState() => _TasbeehTargetSheetState();
}

class _TasbeehTargetSheetState extends State<TasbeehTargetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _target = TextEditingController(text: '${widget.target}');

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
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
              context.l10n.tasbeehCustomTarget,
              style: AppTheme.text(context).titleLarge,
            ),
            const SizedBox(height: 20),
            TasbeehTargetField(controller: _target),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, int.parse(_target.text.trim()));
                  }
                },
                child: Text(context.l10n.tasbeehApplyTarget),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

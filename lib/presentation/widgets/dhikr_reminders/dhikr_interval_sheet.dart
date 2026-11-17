import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';

Future<int?> showDhikrIntervalSheet(BuildContext context, int current) =>
    showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _IntervalSheet(current: current),
    );

class _IntervalSheet extends StatefulWidget {
  const _IntervalSheet({required this.current});
  final int current;

  @override
  State<_IntervalSheet> createState() => _IntervalSheetState();
}

class _IntervalSheetState extends State<_IntervalSheet> {
  final _form = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: '${widget.current}');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_form.currentState!.validate()) {
      Navigator.pop(context, int.parse(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = NumberFormat.decimalPattern(l10n.localeName);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.dhikrIntervalTitle,
              style: AppTheme.text(context).titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.dhikrIntervalHelp),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final minutes in [1, 5, 15, 30, 60, 120, 240])
                  ChoiceChip(
                    label: Text(l10n.dhikrMinutes(format.format(minutes))),
                    selected: _controller.text == '$minutes',
                    onSelected: (_) =>
                        setState(() => _controller.text = '$minutes'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              onFieldSubmitted: (_) => _save(),
              decoration: InputDecoration(labelText: l10n.dhikrCustomMinutes),
              validator: (value) {
                final minutes = int.tryParse(value ?? '');
                return minutes == null ||
                        minutes < DhikrReminder.minIntervalMinutes ||
                        minutes > DhikrReminder.maxIntervalMinutes
                    ? l10n.dhikrIntervalInvalid
                    : null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: _save, child: Text(l10n.dhikrApply)),
          ],
        ),
      ),
    );
  }
}

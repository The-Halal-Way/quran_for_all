import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

/// The result of confirming the "add custom task" bottom sheet.
class AddCustomTaskResult {
  const AddCustomTaskResult({
    required this.title,
    required this.subtitle,
    required this.isOptional,
  });

  final String title;
  final String subtitle;
  final bool isOptional;
}

/// Opens the bottom sheet used to create a custom Daily Tracker task.
/// Returns `null` if the user cancels.
Future<AddCustomTaskResult?> showAddCustomTaskSheet(BuildContext context) {
  return showModalBottomSheet<AddCustomTaskResult>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const _AddCustomTaskSheet(),
  );
}

class _AddCustomTaskSheet extends StatefulWidget {
  const _AddCustomTaskSheet();

  @override
  State<_AddCustomTaskSheet> createState() => _AddCustomTaskSheetState();
}

class _AddCustomTaskSheetState extends State<_AddCustomTaskSheet> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  bool _isOptional = false;
  String? _errorText;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = context.l10n.dailyTrackerAddTaskNameEmptyError);
      return;
    }

    Navigator.pop(
      context,
      AddCustomTaskResult(
        title: title,
        subtitle: _subtitleController.text.trim(),
        isOptional: _isOptional,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.dailyTrackerAddTaskSheetTitle,
              style: text.titleLarge.copyWith(fontWeight: AppTheme.weightBold),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.l10n.dailyTrackerAddTaskNameLabel,
                hintText: context.l10n.dailyTrackerAddTaskNameHint,
                errorText: _errorText,
              ),
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _subtitleController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.l10n.dailyTrackerAddTaskSubtitleLabel,
                hintText: context.l10n.dailyTrackerAddTaskSubtitleHint,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.xs),
            SwitchListTile.adaptive(
              value: _isOptional,
              onChanged: (value) => setState(() => _isOptional = value),
              contentPadding: EdgeInsets.zero,
              title: Text(
                context.l10n.dailyTrackerAddTaskOptionalLabel,
                style: text.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      MaterialLocalizations.of(context).cancelButtonLabel,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(context.l10n.dailyTrackerAddTaskSaveAction),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

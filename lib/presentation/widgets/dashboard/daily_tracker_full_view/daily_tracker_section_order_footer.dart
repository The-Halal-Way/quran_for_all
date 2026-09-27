import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';

class DailyTrackerSectionOrderFooter extends StatelessWidget {
  const DailyTrackerSectionOrderFooter({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FilledButton(
            onPressed: onSave,
            child: Text(context.l10n.dailyTrackerSaveSectionOrderAction),
          ),
        ),
      ],
    ),
  );
}

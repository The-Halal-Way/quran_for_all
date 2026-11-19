import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class DhikrRemindersNotice extends StatelessWidget {
  const DhikrRemindersNotice({
    super.key,
    required this.message,
    this.action,
    this.onAction,
  });
  final String message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    ),
  );
}

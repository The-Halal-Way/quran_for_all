import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class IslamicDayActionTile extends StatelessWidget {
  const IslamicDayActionTile({
    super.key,
    required this.text,
    required this.completed,
    required this.onToggle,
  });
  final String text;
  final bool completed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
    value: completed,
    onChanged: (_) => onToggle(),
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    checkboxShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    title: Text(
      text,
      style: AppTheme.text(context).bodyMedium.copyWith(
        height: 1.5,
        decoration: completed ? TextDecoration.lineThrough : null,
        color: completed
            ? Theme.of(context).colorScheme.onSurfaceVariant
            : null,
      ),
    ),
  );
}

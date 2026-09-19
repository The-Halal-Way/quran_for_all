import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.title,
    required this.semanticDescription,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String semanticDescription;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      toggled: value,
      label: '$title. $semanticDescription',
      excludeSemantics: true,
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.onSurface.withValues(alpha: 0.58),
            size: 19,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.text(
                context,
              ).bodyMedium.copyWith(fontWeight: AppTheme.weightSemiBold),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

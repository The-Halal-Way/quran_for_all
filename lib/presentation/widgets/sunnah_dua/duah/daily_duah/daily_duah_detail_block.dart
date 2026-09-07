import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';

class DailyDuahDetailBlock extends StatelessWidget {
  const DailyDuahDetailBlock({
    super.key,
    required this.color,
    required this.text,
    this.italic = false,
    this.icon,
  });

  final Color color;
  final String text;
  final bool italic;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.075),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 17),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              text,
              style: AppTheme.text(context).bodyMedium.copyWith(
                height: 1.55,
                fontStyle: italic ? FontStyle.italic : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

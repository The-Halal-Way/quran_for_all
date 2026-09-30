import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class TasbeehStatsMetric extends StatelessWidget {
  const TasbeehStatsMetric({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.foreground,
  });

  final String label;
  final String value;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.titleLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.labelSmall.copyWith(
            color: foreground.withValues(alpha: 0.58),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

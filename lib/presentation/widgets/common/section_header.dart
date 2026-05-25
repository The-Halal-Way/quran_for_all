import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../core/theme/app_spacing.dart';

/// A section header row: bold title on the left, optional trailing widget.
///
/// Used in list pages to label groups (e.g. "All Surahs", "Learning Tracks").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: textTheme.titleLarge.copyWith(
                  fontWeight: AppTheme.weightBold,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
        ],
      ],
    );
  }
}

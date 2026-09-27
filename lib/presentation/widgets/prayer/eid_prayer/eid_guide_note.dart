import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class EidGuideNote extends StatelessWidget {
  const EidGuideNote({super.key, required this.bangla});

  final bool bangla;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              bangla
                  ? 'অতিরিক্ত তাকবীরের পদ্ধতিতে মতভেদ আছে। স্থানীয় ইমাম ও নির্ভরযোগ্য আলেমের নির্দেশনা অনুসরণ করুন।'
                  : 'Methods for the additional takbeers vary. Follow your local imam and trusted scholars.',
              style: AppTheme.text(
                context,
              ).bodySmall.copyWith(color: colors.onSurfaceVariant, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

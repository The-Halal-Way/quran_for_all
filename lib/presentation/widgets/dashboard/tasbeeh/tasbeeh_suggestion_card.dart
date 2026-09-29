import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_suggestions.dart';

class TasbeehSuggestionCard extends StatelessWidget {
  const TasbeehSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  final TasbeehSuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.secondary.withValues(alpha: 0.09),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: colors.secondary.withValues(alpha: 0.26)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(
          width: 210,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  suggestion.arabic,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: AppTheme.amiri(
                    context,
                    fontSize: 21,
                    color: colors.onSurface,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  suggestion.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: colors.onSurface,
                    fontWeight: AppTheme.weightSemiBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  suggestion.meaning,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(
                    context,
                  ).labelSmall.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

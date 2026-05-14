import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SearchQueryPanel extends StatelessWidget {
  const SearchQueryPanel({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.query,
    required this.resultCount,
    required this.isLoading,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String query;
  final int resultCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg - 2),
      decoration: BoxDecoration(
        color: MyColors.surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: context.readQuranText(
                'Try: Al-Baqarah, 2:255, para 1, mercy',
              ),
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
          if (query.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm + 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isLoading
                      ? Icons.hourglass_bottom_rounded
                      : Icons.tune_rounded,
                  size: 18.sp.clamp(16.0, 19.0),
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    isLoading
                        ? context.readQuranText('Searching...')
                        : '${context.readQuranText('Results')}: $resultCount · "$query"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

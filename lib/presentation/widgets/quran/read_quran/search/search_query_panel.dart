import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/my_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_responsive.dart';

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
    final responsive = AppResponsive.of(context);
    final statusIconSize = responsive.pick(
      mobile: 18,
      tablet: 16.5,
      desktop: 18.5,
    );

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
              hintText: context.l10n.readQuranSearchHint,
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
                  size: statusIconSize,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    isLoading
                        ? context.l10n.readQuranSearchingLabel
                        : context.l10n.readQuranSearchResultsSummary(
                            resultCount,
                            query,
                          ),
                    style: AppTheme.text(context).bodySmall.copyWith(
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

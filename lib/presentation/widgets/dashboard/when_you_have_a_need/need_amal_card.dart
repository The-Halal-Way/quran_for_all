import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';
import 'need_completion_button.dart';
import 'need_progress_control.dart';

class NeedAmalCard extends StatelessWidget {
  const NeedAmalCard({
    super.key,
    required this.amal,
    required this.isBangla,
    required this.onOpenMethod,
    required this.onOpenDua,
  });

  final NeedAmal amal;
  final bool isBangla;
  final VoidCallback onOpenMethod;
  final VoidCallback onOpenDua;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.tertiary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(amal.category.icon, color: scheme.tertiary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amal.title.of(isBangla),
                        style: AppTheme.text(context).titleMedium.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        amal.category.title.of(isBangla),
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: scheme.tertiary,
                          fontWeight: AppTheme.weightBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              amal.description.of(isBangla),
              style: AppTheme.text(context).bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            if (amal.progressKind != NeedProgressKind.daily) ...[
              const SizedBox(height: AppSpacing.md),
              NeedProgressControl(kind: amal.progressKind, isBangla: isBangla),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onOpenMethod,
                  icon: const Icon(
                    Icons.format_list_numbered_rounded,
                    size: 18,
                  ),
                  label: Text(isBangla ? 'পদ্ধতি দেখুন' : 'How to perform'),
                ),
                TextButton.icon(
                  onPressed: onOpenDua,
                  icon: const Icon(Icons.auto_stories_rounded, size: 18),
                  label: Text(isBangla ? 'দোয়া পড়ুন' : 'Read dua'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            NeedCompletionButton(amalId: amal.id, isBangla: isBangla),
          ],
        ),
      ),
    );
  }
}

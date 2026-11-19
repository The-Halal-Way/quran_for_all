import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_source_link.dart';

class DuaEntryBenefits extends StatelessWidget {
  const DuaEntryBenefits({super.key, required this.entry});
  final DuaEntry entry;

  @override
  Widget build(BuildContext context) {
    if (entry.benefits.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          scheme.secondary.withValues(alpha: .08),
          scheme.surface,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.secondary.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.sunnahDuaBenefitsLabel,
            style: text.titleSmall.copyWith(fontWeight: AppTheme.weightBold),
          ),
          for (final benefit in entry.benefits) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.duaBenefitKind(benefit.kind),
              style: text.labelSmall.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              benefit.text.inLanguage(l10n.localeName),
              style: text.bodyMedium.copyWith(height: 1.5),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: DuaSourceLink(
                label: benefit.sourceLabel.inLanguage(l10n.localeName),
                url: benefit.sourceUrl,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

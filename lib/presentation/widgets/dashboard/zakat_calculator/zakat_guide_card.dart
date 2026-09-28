import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class ZakatGuideCard extends StatelessWidget {
  const ZakatGuideCard({super.key});

  static final Uri _source = Uri.parse(
    'https://islamic-relief.org/zakat-calculator/',
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: scheme.tertiary.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    CupertinoIcons.info_circle,
                    color: scheme.tertiary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    context.l10n.zakatGuideTitle,
                    style: AppTheme.text(
                      context,
                    ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.zakatGuideBody,
              style: AppTheme.text(
                context,
              ).bodySmall.copyWith(color: scheme.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: scheme.tertiary,
              ),
              onPressed: () =>
                  launchUrl(_source, mode: LaunchMode.externalApplication),
              icon: const Icon(CupertinoIcons.arrow_up_right_square, size: 16),
              label: Text(context.l10n.zakatGuideSource),
            ),
          ],
        ),
      ),
    );
  }
}

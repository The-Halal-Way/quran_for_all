import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class SettingsOfflineBadge extends StatelessWidget {
  const SettingsOfflineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${context.l10n.settingsOfflineTitle}. ${context.l10n.settingsOfflineBody}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.tertiary.withValues(alpha: 0.14),
              MyColors.primaryLight.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: MyColors.tertiary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: MyColors.tertiary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.offline_bolt_rounded,
                color: MyColors.tertiary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                context.l10n.settingsOfflineTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(
                  context,
                ).labelMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: MyColors.tertiary,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

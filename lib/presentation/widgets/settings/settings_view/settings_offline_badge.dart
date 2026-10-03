import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../viewmodels/splash_viewmodel.dart';

class SettingsOfflineBadge extends StatelessWidget {
  const SettingsOfflineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final quranReady = context.watch<SplashViewModel?>()?.hasQuranData ?? true;
    final title = quranReady
        ? context.l10n.settingsOfflineTitle
        : context.l10n.quranDownloadTitle;
    final body = quranReady
        ? context.l10n.settingsOfflineBody
        : context.l10n.quranDownloadBody;
    return Semantics(
      label: '$title. $body',
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
              child: Icon(
                quranReady
                    ? Icons.offline_bolt_rounded
                    : Icons.cloud_download_outlined,
                color: MyColors.tertiary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(
                  context,
                ).labelMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
            ),
            Icon(
              quranReady
                  ? Icons.check_circle_rounded
                  : Icons.cloud_download_outlined,
              color: MyColors.tertiary,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

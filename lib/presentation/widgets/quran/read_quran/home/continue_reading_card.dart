import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/localization/surah_name_localizer.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../data/models/surah_model.dart';
import '../../../../viewmodels/settings_viewmodel.dart';
import '../../../common/app_continue_box.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    super.key,
    required this.surah,
    required this.ayahNumber,
    required this.onTap,
    this.ayahPreview,
  });

  final SurahModel surah;
  final int ayahNumber;
  final String? ayahPreview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final language = context.watch<SettingsViewModel>().settings.language;
    final localizedTitle = surah.localizedTitle(context, language);

    return AppContinueBox(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.18),
          ),
        ),
        child: Icon(
          Icons.bookmark_added_rounded,
          color: colorScheme.primary,
          size: 23,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.readQuranContinueReadingTitle,
            style: AppTheme.text(context).labelLarge.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs - 1),
          Text(
            localizedTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
          const SizedBox(height: AppSpacing.sm - 2),
          Text(
            '${surah.nameArabic} · ${context.l10n.readQuranAyahLabel} $ayahNumber',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text(context).bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          // if (ayahPreview != null && ayahPreview!.trim().isNotEmpty) ...[
          //   const SizedBox(height: AppSpacing.sm),
          //   Text(
          //     ayahPreview!,
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //     style: AppTheme.text(context).bodySmall.copyWith(
          //       color: colorScheme.onSurface.withValues(alpha: 0.72),
          //     ),
          //   ),
          // ],
        ],
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Icon(
          CupertinoIcons.chevron_forward,
          size: 15,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

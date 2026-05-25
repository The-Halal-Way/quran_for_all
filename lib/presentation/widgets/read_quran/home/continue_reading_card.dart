import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../common/app_continue_box.dart';
import '../../common/common_painters.dart';

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
    final responsive = AppResponsive.of(context);
    final leadingWidth = responsive.pick(mobile: 62, tablet: 56, desktop: 64);
    final leadingHeight = responsive.pick(mobile: 58, tablet: 52, desktop: 60);
    final leadingIconSize = responsive.pick(
      mobile: 25,
      tablet: 22,
      desktop: 26,
    );
    final trailingSize = responsive.pick(mobile: 32, tablet: 30, desktop: 34);
    final trailingIconSize = responsive.pick(
      mobile: 16,
      tablet: 14.5,
      desktop: 16.5,
    );

    return AppContinueBox(
      onTap: onTap,
      leading: SizedBox(
        width: leadingWidth,
        height: leadingHeight,
        child: CustomPaint(
          painter: YShapePainter(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.16),
            shadowColor: colorScheme.primary.withValues(alpha: 0.12),
            bumpWidth: 30,
            bumpHeight: 9,
            shadowBlurRadius: 5,
          ),
          child: Center(
            child: Icon(
              Icons.bookmark_added_rounded,
              color: colorScheme.primary,
              size: leadingIconSize,
            ),
          ),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.readQuranText('Continue Reading'),
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
            '${surah.nameArabic} · ${context.readQuranText('Ayah')} $ayahNumber',
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
        width: trailingSize,
        height: trailingSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: trailingIconSize,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

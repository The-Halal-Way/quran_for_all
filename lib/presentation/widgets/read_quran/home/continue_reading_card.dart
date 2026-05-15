import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/theme/app_spacing.dart';
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

    return AppContinueBox(
      onTap: onTap,
      leading: SizedBox(
        width: 62.w.clamp(56.0, 68.0),
        height: 58.h.clamp(50.0, 64.0),
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
              size: 25.sp.clamp(22.0, 27.0),
            ),
          ),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.readQuranText('Continue Reading'),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs - 1),
          Text(
            localizedTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm - 2),
          Text(
            '${surah.nameArabic} · ${context.readQuranText('Ayah')} $ayahNumber',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          // if (ayahPreview != null && ayahPreview!.trim().isNotEmpty) ...[
          //   const SizedBox(height: AppSpacing.sm),
          //   Text(
          //     ayahPreview!,
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //       color: colorScheme.onSurface.withValues(alpha: 0.72),
          //     ),
          //   ),
          // ],
        ],
      ),
      trailing: Container(
        width: 32.w.clamp(30.0, 36.0),
        height: 32.w.clamp(30.0, 36.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.sp.clamp(14.0, 17.0),
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/models/sunnah_dua_item.dart';

class SunnahDuaRelatedContent extends StatelessWidget {
  const SunnahDuaRelatedContent({super.key, required this.item});

  final SunnahDuaItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.relatedDuaTitle,
          style: text.labelMedium.copyWith(
            color: item.accent,
            fontWeight: AppTheme.weightBlack,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: SelectableText(
            item.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: text.duahCardArabic.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 0,
            ),
          ),
        ),
        if (item.pronunciation.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.pronunciation,
            style: text.duahCardBodyItalic.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
              letterSpacing: 0,
            ),
          ),
        ],
        if (item.translation.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.translation,
            style: text.duahCardBody.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 0,
            ),
          ),
        ],
      ],
    );
  }
}

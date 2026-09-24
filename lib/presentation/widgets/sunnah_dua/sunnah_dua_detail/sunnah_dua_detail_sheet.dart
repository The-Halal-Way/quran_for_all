import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/models/sunnah_dua_item.dart';

import 'sunnah_dua_point_list.dart';
import 'sunnah_dua_benefits_panel.dart';
import 'sunnah_dua_related_content.dart';
import 'sunnah_dua_detail_header.dart';
import 'sunnah_dua_detail_block.dart';

class SunnahDuaDetailSheet extends StatelessWidget {
  const SunnahDuaDetailSheet({
    super.key,
    required this.item,
    required this.kindLabel,
    this.controller,
  });

  final SunnahDuaItem item;
  final String kindLabel;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SunnahDuaDetailHeader(item: item, kindLabel: kindLabel),
            const SizedBox(height: AppSpacing.lg),
            if (item.sunnahPoints.isNotEmpty)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaSunnahPointsLabel,
                child: SunnahDuaPointList(points: item.sunnahPoints),
              ),
            if (item.hasRelatedDua)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaRelatedDuaLabel,
                child: SunnahDuaRelatedContent(item: item),
              )
            else if (item.arabic.isNotEmpty)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaArabicLabel,
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
            if (!item.hasRelatedDua && item.pronunciation.isNotEmpty)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaPronunciationLabel,
                child: Text(
                  item.pronunciation,
                  style: text.duahCardBodyItalic.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.78),
                    letterSpacing: 0,
                  ),
                ),
              ),
            if (!item.hasRelatedDua && item.translation.isNotEmpty)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaTranslationLabel,
                child: Text(
                  item.translation,
                  style: text.duahCardBody.copyWith(
                    color: colorScheme.onSurface,
                    letterSpacing: 0,
                  ),
                ),
              ),
            if (item.benefits.isNotEmpty)
              SunnahDuaBenefitsPanel(benefits: item.benefits),
            SunnahDuaDetailBlock(
              label: context.l10n.sunnahDuaPracticeLabel,
              child: Text(
                item.practice,
                style: text.bodyMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.74),
                  height: 1.45,
                  letterSpacing: 0,
                ),
              ),
            ),
            if (item.hadithReferences.isNotEmpty)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaEvidenceLabel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final reference in item.hadithReferences)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${reference.collection} ${reference.reference}'
                              '${reference.grade == null ? '' : ' • ${reference.grade}'}',
                              style: text.labelMedium.copyWith(
                                color: colorScheme.primary,
                                fontWeight: AppTheme.weightBold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              reference.text,
                              style: text.bodySmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            if (item.authenticityNotes.isNotEmpty)
              SunnahDuaDetailBlock(
                label: context.l10n.sunnahDuaAuthenticityLabel,
                child: Text(
                  item.authenticityNotes,
                  style: text.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

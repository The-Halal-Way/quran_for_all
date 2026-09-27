import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';

class EidArabicPanel extends StatelessWidget {
  const EidArabicPanel({
    super.key,
    required this.arabic,
    required this.pronunciation,
    required this.meaning,
    required this.bangla,
  });

  final String arabic;
  final EidText pronunciation;
  final EidText meaning;
  final bool bangla;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: dark ? 0.23 : 0.065),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.primary.withValues(alpha: 0.11)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTheme.amiri(
                context,
                fontSize: 26,
                color: colors.onSurface,
                height: 1.75,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: colors.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            bangla ? 'উচ্চারণ' : 'PRONUNCIATION',
            style: AppTheme.text(context).labelSmall.copyWith(
              color: colors.primary,
              fontWeight: AppTheme.weightExtraBold,
              letterSpacing: bangla ? 0 : 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            pronunciation.inLanguage(bangla),
            style: AppTheme.text(
              context,
            ).bodyMedium.copyWith(color: colors.onSurface, height: 1.55),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            bangla ? 'অর্থ' : 'MEANING',
            style: AppTheme.text(context).labelSmall.copyWith(
              color: colors.primary,
              fontWeight: AppTheme.weightExtraBold,
              letterSpacing: bangla ? 0 : 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            meaning.inLanguage(bangla),
            style: AppTheme.text(
              context,
            ).bodyMedium.copyWith(color: colors.onSurfaceVariant, height: 1.55),
          ),
        ],
      ),
    );
  }
}

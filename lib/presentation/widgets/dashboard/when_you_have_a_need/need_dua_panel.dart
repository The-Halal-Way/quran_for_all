import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedDuaPanel extends StatelessWidget {
  const NeedDuaPanel({super.key, required this.amal, required this.isBangla});

  final NeedAmal amal;
  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.tertiary.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isBangla ? 'দোয়া ও অর্থ' : 'Dua and meaning',
            style: AppTheme.text(
              context,
            ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          const SizedBox(height: AppSpacing.md),
          if (amal.arabic != null) ...[
            Text(
              amal.arabic!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTheme.amiri(
                context,
                fontSize: 25,
                color: scheme.onSurface,
                height: 1.9,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              amal.transliteration!,
              style: AppTheme.text(
                context,
              ).bodyMedium.copyWith(color: scheme.tertiary, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              amal.meaning!.en,
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.5),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              amal.meaning!.bn,
              style: AppTheme.text(context).bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
          if (amal.duaNote != null) ...[
            if (amal.arabic != null) const SizedBox(height: AppSpacing.md),
            Text(
              amal.duaNote!.of(isBangla),
              style: AppTheme.text(
                context,
              ).bodySmall.copyWith(color: scheme.onSurfaceVariant, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

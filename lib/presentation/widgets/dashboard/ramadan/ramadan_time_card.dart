import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';
import 'ramadan_time_point.dart';

class RamadanTimeCard extends StatelessWidget {
  const RamadanTimeCard({
    super.key,
    required this.isBangla,
    required this.times,
  });

  final bool isBangla;
  final Map<String, String>? times;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ramadanLabel(
              isBangla,
              'Today’s fasting landmarks',
              'আজকের রোজার সময়সীমা',
            ),
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: RamadanTimePoint(
                  icon: Icons.wb_twilight_rounded,
                  label: ramadanLabel(isBangla, 'Fajr begins', 'ফজর শুরু'),
                  time: times?['Fajr'] ?? '—',
                  accent: scheme.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: RamadanTimePoint(
                  icon: Icons.nights_stay_rounded,
                  label: ramadanLabel(
                    isBangla,
                    'Maghrib / iftar',
                    'মাগরিব / ইফতার',
                  ),
                  time: times?['Maghrib'] ?? '—',
                  accent: scheme.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            times == null || times!.isEmpty
                ? ramadanLabel(
                    isBangla,
                    'Enable location and prayer times to see today’s times.',
                    'আজকের সময় দেখতে লোকেশন ও নামাজের সময় চালু করুন।',
                  )
                : ramadanLabel(
                    isBangla,
                    'Based on your prayer-time settings. Confirm locally when needed.',
                    'আপনার নামাজের সময়ের সেটিংস অনুযায়ী। প্রয়োজনে স্থানীয়ভাবে নিশ্চিত করুন।',
                  ),
            style: AppTheme.text(
              context,
            ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

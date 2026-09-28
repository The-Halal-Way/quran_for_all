import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanJourneyMap extends StatelessWidget {
  const RamadanJourneyMap({required this.isBangla});

  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stages = [
      (
        ramadanLabel(isBangla, 'Prepare', 'প্রস্তুতি'),
        ramadanLabel(
          isBangla,
          'Sighting • intention • plan',
          'চাঁদ দেখা • নিয়ত • পরিকল্পনা',
        ),
      ),
      (
        ramadanLabel(isBangla, 'Each day', 'প্রতিদিন'),
        ramadanLabel(
          isBangla,
          'Fast • pray • read • give',
          'রোজা • নামাজ • কুরআন • দান',
        ),
      ),
      (
        ramadanLabel(isBangla, 'Final nights', 'শেষ রাতগুলো'),
        ramadanLabel(
          isBangla,
          'Qadr • du’a • reflection',
          'কদর • দোয়া • আত্মসমালোচনা',
        ),
      ),
      (
        ramadanLabel(isBangla, 'Eid & beyond', 'ঈদ ও এরপর'),
        ramadanLabel(
          isBangla,
          'Fitr • gratitude • habits',
          'ফিতরা • কৃতজ্ঞতা • অভ্যাস',
        ),
      ),
    ];
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
            ramadanLabel(isBangla, 'The month at a glance', 'এক নজরে পুরো মাস'),
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var index = 0; index < stages.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == stages.length - 1 ? 0 : AppSpacing.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (index.isEven ? scheme.tertiary : scheme.secondary)
                          .withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: AppTheme.text(context).labelMedium.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stages[index].$1,
                          style: AppTheme.text(context).titleSmall.copyWith(
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                        Text(
                          stages[index].$2,
                          style: AppTheme.text(
                            context,
                          ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

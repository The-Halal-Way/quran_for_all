import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanSourceNote extends StatelessWidget {
  const RamadanSourceNote({super.key, required this.isBangla});

  final bool isBangla;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_outlined, color: scheme.secondary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              ramadanLabel(
                isBangla,
                'Religious guidance includes source links. Moon-sighting, health and school-specific rulings require current local guidance.',
                'ধর্মীয় নির্দেশনার সঙ্গে সূত্রের লিংক আছে। চাঁদ দেখা, স্বাস্থ্য ও মাযহাবভিত্তিক বিধানে হালনাগাদ স্থানীয় নির্দেশনা নিন।',
              ),
              style: AppTheme.text(context).bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanOverviewSectionTile extends StatelessWidget {
  const RamadanOverviewSectionTile({
    required this.section,
    required this.isBangla,
    required this.count,
    required this.onTap,
  });

  final RamadanSection section;
  final bool isBangla;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      key: ValueKey('ramadan_section_${section.name}'),
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(section.icon, color: scheme.tertiary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  section.title.of(isBangla),
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
              ),
              Text(
                '$count',
                style: AppTheme.text(
                  context,
                ).labelMedium.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(CupertinoIcons.chevron_forward, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

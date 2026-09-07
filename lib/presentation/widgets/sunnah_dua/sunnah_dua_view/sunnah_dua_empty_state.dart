import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SunnahDuaEmptyState extends StatelessWidget {
  const SunnahDuaEmptyState({super.key, required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 32,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.sunnahDuaNoResults,
            style: AppTheme.text(context).titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.sunnahDuaNoResultsBody,
            textAlign: TextAlign.center,
            style: AppTheme.text(context).bodySmall,
          ),
          TextButton(
            onPressed: onClear,
            child: Text(context.l10n.sunnahDuaClearSearch),
          ),
        ],
      ),
    ),
  );
}

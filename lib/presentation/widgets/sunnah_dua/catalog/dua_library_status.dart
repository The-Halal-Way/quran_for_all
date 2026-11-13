import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class DuaLibraryStatus extends StatelessWidget {
  const DuaLibraryStatus({
    super.key,
    this.loading = false,
    this.failed = false,
    this.onRetry,
  });
  final bool loading, failed;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const CircularProgressIndicator()
          else
            Icon(
              failed ? Icons.cloud_off_rounded : Icons.search_off_rounded,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            loading
                ? context.l10n.duaLoading
                : failed
                ? context.l10n.duaLoadFailed
                : context.l10n.duaNoResults,
            textAlign: TextAlign.center,
            style: AppTheme.text(context).bodyMedium,
          ),
          if (failed)
            TextButton(onPressed: onRetry, child: Text(context.l10n.quizRetry)),
        ],
      ),
    ),
  );
}

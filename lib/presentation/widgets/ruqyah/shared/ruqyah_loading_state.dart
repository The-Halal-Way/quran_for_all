import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

class RuqyahLoadingState extends StatelessWidget {
  const RuqyahLoadingState({super.key, this.failed = false, this.onRetry});
  final bool failed;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
    child: Center(
      child: failed
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.ruqyahLoadError, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.ruqyahRetry),
                ),
              ],
            )
          : const CircularProgressIndicator(),
    ),
  );
}

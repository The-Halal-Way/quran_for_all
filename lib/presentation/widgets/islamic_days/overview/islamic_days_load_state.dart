import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

class IslamicDaysLoadState extends StatelessWidget {
  const IslamicDaysLoadState({
    super.key,
    required this.hasError,
    required this.onRetry,
  });
  final bool hasError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(30),
    child: Center(
      child: hasError
          ? Column(
              children: [
                const Icon(Icons.menu_book_outlined, size: 36),
                const SizedBox(height: 16),
                Text(
                  context.l10n.islamicDaysLoadError,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.islamicDaysRetry),
                ),
              ],
            )
          : const CircularProgressIndicator.adaptive(),
    ),
  );
}

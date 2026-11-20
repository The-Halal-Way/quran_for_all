import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../shared/ruqyah_style.dart';

class RuqyahReadingComplete extends StatelessWidget {
  const RuqyahReadingComplete({super.key, required this.onRestart});
  final VoidCallback onRestart;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RuqyahStyle.accent(context).withValues(alpha: .12),
            ),
            child: Icon(
              Icons.spa_rounded,
              color: RuqyahStyle.accent(context),
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.ruqyahSessionComplete,
            textAlign: TextAlign.center,
            style: AppTheme.text(
              context,
            ).titleLarge.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.ruqyahCompleteBody,
            textAlign: TextAlign.center,
            style: AppTheme.text(context).bodyLarge.copyWith(height: 1.6),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ruqyahBackToLibrary),
          ),
          TextButton(
            onPressed: onRestart,
            child: Text(context.l10n.ruqyahRestart),
          ),
        ],
      ),
    ),
  );
}

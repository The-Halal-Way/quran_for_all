import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_visuals.dart';

class TasbeehSessionEmpty extends StatelessWidget {
  const TasbeehSessionEmpty({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xxl,
      vertical: AppSpacing.huge,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: TasbeehVisuals.heroColors(context),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.xxl),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.add_circle_outline_rounded,
          color: TasbeehVisuals.mint,
          size: 50,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          context.l10n.tasbeehEmptySessionTitle,
          textAlign: TextAlign.center,
          style: AppTheme.text(context).titleLarge.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.weightExtraBold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.tasbeehEmptySessionDescription,
          textAlign: TextAlign.center,
          style: AppTheme.text(
            context,
          ).bodyMedium.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: AppSpacing.xxl),
        FilledButton.icon(
          key: const ValueKey('tasbeeh_session_add_first'),
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: Text(context.l10n.tasbeehAddDhikr),
          style: FilledButton.styleFrom(
            backgroundColor: TasbeehVisuals.mint,
            foregroundColor: TasbeehVisuals.heroColors(context).first,
          ),
        ),
      ],
    ),
  );
}

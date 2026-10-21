import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../shared/quiz_orbit_artwork.dart';

class QuizSelectionHeader extends StatelessWidget {
  const QuizSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        gradient: const LinearGradient(
          colors: [Color(0xFF293A7C), Color(0xFF6239A5), Color(0xFF8C4FA3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quizSelectionEyebrow,
                  style: text.labelSmall.copyWith(
                    color: const Color(0xFF9CE5EC),
                    letterSpacing: 1.1,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const QuizOrbitArtwork(size: 62),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.quizSelectionTitle,
            style: text.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightExtraBold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.quizSelectionDescription,
            style: text.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
        ],
      ),
    );
  }
}

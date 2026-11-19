import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class DhikrRemindersIntro extends StatelessWidget {
  const DhikrRemindersIntro({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF123B43), Color(0xFF353963)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.xl),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.notifications_active_outlined,
          color: Color(0xFF9ADACD),
          size: 34,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            context.l10n.dhikrRemindersSubtitle,
            style: AppTheme.text(
              context,
            ).bodyLarge.copyWith(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

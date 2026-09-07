import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import 'hadith_reader_navigation_button.dart';

class HadithReaderBottomBar extends StatelessWidget {
  const HadithReaderBottomBar({
    super.key,
    required this.previousLabel,
    required this.nextLabel,
    required this.centerLabel,
    required this.centerIcon,
    required this.accent,
    required this.canPrevious,
    required this.canNext,
    required this.onPrevious,
    required this.onNext,
    this.onCenter,
    this.centerSelected = false,
  });

  final String previousLabel;
  final String nextLabel;
  final String centerLabel;
  final IconData centerIcon;
  final Color accent;
  final bool canPrevious;
  final bool canNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onCenter;
  final bool centerSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF171126).withValues(alpha: 0.96)
              : Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: accent.withValues(alpha: 0.20)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            HadithReaderNavigationButton(
              label: previousLabel,
              icon: Icons.arrow_back_ios_new_rounded,
              enabled: canPrevious,
              accent: accent,
              onTap: onPrevious,
            ),
            Expanded(
              child: Semantics(
                button: onCenter != null,
                selected: centerSelected,
                child: InkWell(
                  onTap: onCenter,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          centerIcon,
                          size: 19,
                          color: centerSelected
                              ? accent
                              : colorScheme.onSurface.withValues(alpha: 0.48),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          centerLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).labelSmall.copyWith(
                            color: centerSelected
                                ? accent
                                : colorScheme.onSurface.withValues(alpha: 0.55),
                            fontWeight: AppTheme.weightBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            HadithReaderNavigationButton(
              label: nextLabel,
              icon: Icons.arrow_forward_ios_rounded,
              enabled: canNext,
              accent: accent,
              iconAfter: true,
              onTap: onNext,
            ),
          ],
        ),
      ),
    );
  }
}

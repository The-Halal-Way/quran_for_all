import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

/// A compact dashboard destination with room for localized, enlarged text.
class DashboardFeatureCard extends StatelessWidget {
  const DashboardFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.leading,
    required this.onTap,
    this.eyebrow,
  });

  final String title, subtitle;
  final String? eyebrow;
  final Color accent;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final foreground = dark
        ? Color.lerp(accent, Colors.white, .4)!
        : Color.lerp(accent, scheme.onSurface, .28)!;
    final radius = BorderRadius.circular(AppRadius.xl);

    return Semantics(
      button: true,
      child: Material(
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: accent.withValues(alpha: dark ? .3 : .2)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                Color.alphaBlend(accent.withValues(alpha: .09), scheme.surface),
                Color.alphaBlend(
                  accent.withValues(alpha: .025),
                  scheme.surface,
                ),
              ],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ExcludeSemantics(child: leading),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eyebrow != null) ...[
                          Text(
                            eyebrow!,
                            style: text.labelSmall.copyWith(
                              color: foreground,
                              fontWeight: AppTheme.weightSemiBold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        Text(
                          title,
                          style: text.titleSmall.copyWith(
                            fontSize: AppTheme.scaledFontSize(context, 15),
                            fontWeight: AppTheme.weightExtraBold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          style: text.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ExcludeSemantics(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .09),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: foreground,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

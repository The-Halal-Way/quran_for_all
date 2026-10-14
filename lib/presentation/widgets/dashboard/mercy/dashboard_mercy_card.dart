import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/mercy/mercy_collection.dart';

/// A compact reading card with the Books preview's cover and title styling.
class DashboardMercyCard extends StatelessWidget {
  const DashboardMercyCard({
    super.key,
    required this.kind,
    required this.onTap,
  });

  final MercyCollectionKind kind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final scheme = Theme.of(context).colorScheme;
    final isHadith = kind == MercyCollectionKind.hadith;
    final accent = isHadith ? colors.coral : colors.violet;
    final secondary = isHadith ? colors.violet : colors.cyan;
    final title = isHadith
        ? context.l10n.dashboardMercyHadithTitle
        : context.l10n.dashboardMercyStoriesTitle;
    final subtitle = isHadith
        ? context.l10n.dashboardMercyHadithSubtitle
        : context.l10n.dashboardMercyStoriesSubtitle;

    return Semantics(
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      label: '$title. $subtitle. ${context.l10n.dashboardMercyOpen}',
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.alphaBlend(
                  accent.withValues(alpha: 0.08),
                  scheme.surface,
                ),
                Color.alphaBlend(
                  secondary.withValues(alpha: 0.08),
                  scheme.surface,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 128),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _MercyIcon(
                          icon: isHadith
                              ? Icons.favorite_rounded
                              : Icons.auto_stories_rounded,
                          accent: accent,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_outward_rounded,
                          color: accent,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.text(context).labelLarge.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: accent,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.text(context).labelSmall.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MercyIcon extends StatelessWidget {
  const _MercyIcon({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent,
            Color.lerp(accent, AppThemeColors.light.brand, 0.42)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PositionedDirectional(
            top: 8,
            end: 7,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withValues(alpha: 0.55),
              size: 10,
            ),
          ),
          Icon(icon, color: Colors.white, size: 22),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/mercy/mercy_collection.dart';
import '../../../views/dashboard/mercy/mercy_collection_view.dart';
import 'dashboard_mercy_card.dart';

/// A compact, two-card shelf for the heart-focused reading collections.
///
/// Both collections are visible at once so the dashboard does not grow by a
/// full horizontal carousel height. The JSON remains lazy: navigation only
/// happens after a card is tapped.
class DashboardMercySection extends StatelessWidget {
  const DashboardMercySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          colors.coral.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark
                ? 0.12
                : 0.045,
          ),
          scheme.surface,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.coral.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colors.coral.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -30,
            top: -48,
            child: _MercyGlow(
              color: colors.violet.withValues(alpha: 0.13),
              size: 116,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MercySectionHeader(
                title: context.l10n.dashboardMercyTitle,
                subtitle: context.l10n.dashboardMercySubtitle,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 124,
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardMercyCard(
                        kind: MercyCollectionKind.hadith,
                        onTap: () => _openCollection(
                          context,
                          MercyCollectionKind.hadith,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DashboardMercyCard(
                        kind: MercyCollectionKind.stories,
                        onTap: () => _openCollection(
                          context,
                          MercyCollectionKind.stories,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openCollection(BuildContext context, MercyCollectionKind kind) {
    Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => MercyCollectionView(kind: kind)));
  }
}

class _MercySectionHeader extends StatelessWidget {
  const _MercySectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.coral, colors.violet],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: colors.coral.withValues(alpha: 0.22),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite_rounded,
            size: 21,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(
                  context,
                ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.text(
                  context,
                ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Icon(Icons.auto_awesome_rounded, color: colors.violet, size: 20),
      ],
    );
  }
}

class _MercyGlow extends StatelessWidget {
  const _MercyGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 16),
          boxShadow: [BoxShadow(color: color, blurRadius: 26, spreadRadius: 8)],
        ),
      ),
    );
  }
}

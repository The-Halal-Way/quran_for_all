import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/mercy/mercy_collection.dart';
import '../../../views/dashboard/mercy/mercy_collection_view.dart';
import '../dashboard_view/dashboard_section_title.dart';
import 'dashboard_mercy_card.dart';

/// Two independent reading cards below the Mercy heading and subtitle.
class DashboardMercySection extends StatelessWidget {
  const DashboardMercySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: context.l10n.dashboardMercyTitle,
          icon: Icons.favorite_rounded,
          accent: colors.coral,
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4),
          child: Text(
            context.l10n.dashboardMercySubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text(context).bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const DashboardMercyShelf(),
      ],
    );
  }
}

class DashboardMercyShelf extends StatelessWidget {
  const DashboardMercyShelf({super.key});

  static const _collections = [
    MercyCollectionKind.hadith,
    MercyCollectionKind.stories,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;
    return Container(
      constraints: const BoxConstraints(minHeight: 128),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(
              colors.coral.withValues(alpha: 0.08),
              scheme.surface,
            ),
            Color.alphaBlend(
              colors.violet.withValues(alpha: 0.08),
              scheme.surface,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          _MercyShelfGlow(
            alignment: Alignment(-1.12, -1.35),
            color: colors.coral,
          ),
          _MercyShelfGlow(
            alignment: Alignment(1.1, 1.45),
            color: colors.violet,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 128),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < _collections.length; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DashboardMercyCard(
                        kind: _collections[index],
                        onTap: () => Navigator.of(context).push(
                          AppPageRoute<void>(
                            builder: (_) =>
                                MercyCollectionView(kind: _collections[index]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MercyShelfGlow extends StatelessWidget {
  const _MercyShelfGlow({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    child: IgnorePointer(
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.07),
        ),
      ),
    ),
  );
}

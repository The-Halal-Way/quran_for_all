import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/hadith_integrity/hadith_integrity_view.dart';
import '../dashboard_view/dashboard_section_title.dart';

/// Compact dashboard invitation for the Hadith Integrity library.
///
/// This widget intentionally has no data loader. The JSON pack is read only
/// by [HadithIntegrityView] after the user taps the card.
class DashboardHadithIntegritySection extends StatelessWidget {
  const DashboardHadithIntegritySection({super.key});

  static final _accent = AppThemeColors.light.cyan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: context.l10n.hadithIntegritySectionTitle,
          icon: Icons.fact_check_rounded,
          accent: _accent,
        ),
        const SizedBox(height: AppSpacing.sm),
        _IntegrityLaunchCard(onTap: () => _open(context)),
      ],
    );
  }

  void _open(BuildContext context) {
    Navigator.of(
      context,
    ).push(AppPageRoute<void>(builder: (_) => const HadithIntegrityView()));
  }
}

class _IntegrityLaunchCard extends StatelessWidget {
  const _IntegrityLaunchCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;
    final text = AppTheme.text(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.alphaBlend(
                  colors.cyan.withValues(alpha: 0.16),
                  scheme.surface,
                ),
                Color.alphaBlend(
                  colors.violet.withValues(alpha: 0.12),
                  scheme.surface,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: colors.cyan.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: colors.cyan.withValues(alpha: 0.09),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                right: -18,
                top: -34,
                child: _IntegrityOrb(size: 124, opacity: 0.10),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    _IntegrityMark(color: colors.cyan),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.hadithIntegritySectionSubtitle,
                            style: text.labelMedium.copyWith(
                              color: colors.cyan,
                              fontWeight: AppTheme.weightBold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.l10n.hadithIntegritySectionDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: [
                              _IntegrityChip(
                                icon: Icons.search_rounded,
                                label: context.l10n.hadithIntegrityPopularLabel,
                              ),
                              _IntegrityChip(
                                icon: Icons.warning_amber_rounded,
                                label: context
                                    .l10n
                                    .hadithIntegrityMisconceptionLabel,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.cyan.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: colors.cyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntegrityMark extends StatelessWidget {
  const _IntegrityMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color, Color.lerp(color, AppThemeColors.light.violet, 0.45)!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: [
        BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 14),
      ],
    ),
    child: const Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Icon(Icons.fact_check_rounded, color: Colors.white, size: 28),
    ),
  );
}

class _IntegrityChip extends StatelessWidget {
  const _IntegrityChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = AppThemeColors.light.cyan;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTheme.text(context).labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntegrityOrb extends StatelessWidget {
  const _IntegrityOrb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppThemeColors.light.violet.withValues(alpha: opacity),
    ),
  );
}

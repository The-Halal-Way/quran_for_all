import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/sunnah_dua/sunnah_dua_models.dart';

class SunnahDuaCard extends StatelessWidget {
  const SunnahDuaCard({
    super.key,
    required this.item,
    required this.kindLabel,
    required this.onTap,
  });

  final SunnahDuaItem item;
  final String kindLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final surface = isDark
        ? MyColors.darkCardFill.withValues(alpha: 0.88)
        : colorScheme.surface.withValues(alpha: 0.94);
    final border = item.isFeatured
        ? item.accent.withValues(alpha: 0.55)
        : colorScheme.outline.withValues(alpha: isDark ? 0.22 : 0.18);

    return Semantics(
      button: true,
      label: item.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Ink(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  color: item.accent.withValues(alpha: isDark ? 0.16 : 0.10),
                  blurRadius: item.isFeatured ? 18 : 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: item.gradientColors),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    top: 10,
                    child: Icon(
                      item.icon,
                      size: 58,
                      color: item.accent.withValues(
                        alpha: isDark ? 0.09 : 0.07,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 11, 11, 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _IconTile(item: item),
                            const Spacer(),
                            _KindBadge(label: kindLabel, color: item.accent),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: AppTheme.weightBlack,
                            height: 1.15,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.66,
                            ),
                            fontWeight: AppTheme.weightMedium,
                            height: 1.25,
                            letterSpacing: 0,
                          ),
                        ),
                        const Spacer(),
                        if (item.sunnahPoints.isNotEmpty)
                          _SunnahPreview(item: item)
                        else if (item.arabic.isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              item.arabic,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              style: text.duahArabic.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.86,
                                ),
                                fontSize: AppTheme.scaledFontSize(context, 16),
                                height: 1.2,
                                fontWeight: AppTheme.weightBold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                        Row(
                          children: [
                            Container(
                              width: 22,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: item.gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: item.accent,
                            ),
                          ],
                        ),
                      ],
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

class _SunnahPreview extends StatelessWidget {
  const _SunnahPreview({required this.item});

  final SunnahDuaItem item;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;
    final previewPoints = item.sunnahPoints.take(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final point in previewPoints)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 7, right: 6),
                  decoration: BoxDecoration(
                    color: item.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: AppTheme.scaledFontSize(context, 11),
                      fontWeight: AppTheme.weightSemiBold,
                      height: 1.25,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (item.hasRelatedDua) ...[
          const SizedBox(height: 1),
          Row(
            children: [
              Icon(
                Icons.volunteer_activism_rounded,
                size: 13,
                color: item.accent,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '${context.l10n.sunnahDuaDuaIncludedLabel}: ${item.relatedDuaTitle}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall.copyWith(
                    color: item.accent,
                    fontWeight: AppTheme.weightBlack,
                    letterSpacing: 0,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 4),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.item});

  final SunnahDuaItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: item.gradientColors),
        borderRadius: BorderRadius.circular(AppRadius.compact),
        boxShadow: [
          BoxShadow(
            color: item.accent.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(item.icon, color: Colors.white, size: 17),
    );
  }
}

class _KindBadge extends StatelessWidget {
  const _KindBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 76),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withValues(alpha: 0.26)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: text.labelSmall.copyWith(
          color: color,
          fontWeight: AppTheme.weightBlack,
          letterSpacing: 0,
          height: 1,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/surah_model.dart';
import '../../common/common_painters.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    super.key,
    required this.surah,
    required this.ayahNumber,
    required this.onTap,
    this.ayahPreview,
  });

  final SurahModel surah;
  final int ayahNumber;
  final String? ayahPreview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.14),
                MyColors.secondaryLight.withValues(alpha: 0.22),
                colorScheme.tertiary.withValues(alpha: 0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.34),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -24,
                right: -18,
                child: _DecorOrb(
                  size: 72.w.clamp(64.0, 82.0),
                  color: colorScheme.primary.withValues(alpha: 0.10),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -12,
                child: _DecorOrb(
                  size: 52.w.clamp(46.0, 60.0),
                  color: colorScheme.secondary.withValues(alpha: 0.16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 62.w.clamp(56.0, 68.0),
                      height: 58.h.clamp(50.0, 64.0),
                      child: CustomPaint(
                        painter: YShapePainter(
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.16,
                          ),
                          shadowColor: colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          bumpWidth: 30,
                          bumpHeight: 9,
                          shadowBlurRadius: 5,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.bookmark_added_rounded,
                            color: colorScheme.primary,
                            size: 25.sp.clamp(22.0, 27.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.readQuranText('Continue Reading'),
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.1,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs - 1),
                          Text(
                            surah.nameEnglish,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm - 2),
                          Text(
                            '${surah.nameArabic} · ${context.readQuranText('Ayah')} $ayahNumber',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.72,
                                  ),
                                ),
                          ),
                          if (ayahPreview != null &&
                              ayahPreview!.trim().isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              ayahPreview!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.72,
                                    ),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 32.w.clamp(30.0, 36.0),
                      height: 32.w.clamp(30.0, 36.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp.clamp(14.0, 17.0),
                        color: colorScheme.primary,
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

class _DecorOrb extends StatelessWidget {
  const _DecorOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

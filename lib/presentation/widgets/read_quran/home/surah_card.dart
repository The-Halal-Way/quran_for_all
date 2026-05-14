import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/surah_model.dart';
import '../../common/app_pill.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    required this.isBookmarked,
    required this.onToggleBookmark,
  });

  final SurahModel surah;
  final VoidCallback onTap;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 390;

            return Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.w.clamp(42.0, 52.0),
                    height: 48.w.clamp(42.0, 52.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      gradient: LinearGradient(
                        colors: [
                          MyColors.primary.withValues(alpha: 0.22),
                          MyColors.tertiary.withValues(alpha: 0.16),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        surah.id.toString(),
                        style: textTheme.titleMedium?.copyWith(
                          color: MyColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                surah.nameEnglish,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: AppPill.surface(
                                icon: Icons.layers_rounded,
                                label:
                                    '${surah.totalAyahs} ${context.readQuranText('ayahs')}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          context.readQuranText(surah.nameTranslated),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: MyColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm + 2),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: compact ? AppSpacing.xs : 6,
                          children: [
                            AppPill.surface(
                              label: context.readQuranText(
                                surah.revelationType,
                              ),
                              imgIcon: surah.revelationType == 'Meccan'
                                  ? MyIcons.meccaIcon
                                  : MyIcons.medinaIcon,
                              backgroundColor: colorScheme.surface.withValues(
                                alpha: 0.9,
                              ),
                              borderColor: colorScheme.outline.withValues(
                                alpha: 0.35,
                              ),
                            ),
                            AppPill.surface(
                              label: surah.nameArabic,
                              backgroundColor: colorScheme.surface.withValues(
                                alpha: 0.9,
                              ),
                              borderColor: colorScheme.outline.withValues(
                                alpha: 0.35,
                              ),
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Column(
                    children: [
                      IconButton(
                        onPressed: onToggleBookmark,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_add_outlined,
                          color: isBookmarked
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        tooltip: isBookmarked
                            ? context.readQuranText('Remove surah bookmark')
                            : context.readQuranText('Save surah bookmark'),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp.clamp(14.0, 17.0),
                        color: MyColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

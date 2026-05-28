import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';

import '../../../../core/localization/surah_name_localizer.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/settings_viewmodel.dart';
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
    final textTheme = AppTheme.text(context);
    final language = context.watch<SettingsViewModel>().settings.language;
    final localizedTitle = surah.localizedTitle(context, language);
    final responsive = AppResponsive.of(context);
    final leadingSize = responsive.pick(mobile: 48, tablet: 42, desktop: 50);
    final trailingArrowSize = responsive.pick(
      mobile: 16,
      tablet: 14.5,
      desktop: 16.5,
    );

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
                    width: leadingSize,
                    height: leadingSize,
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
                        style: textTheme.titleMedium.copyWith(
                          color: MyColors.primary,
                          fontWeight: AppTheme.weightExtraBold,
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
                                localizedTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium.copyWith(
                                  fontWeight: AppTheme.weightBold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: AppPill.surface(
                                icon: Icons.layers_rounded,
                                label:
                                    '${surah.totalAyahs} ${context.l10n.readQuranAyahsLabel}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          context.readQuranText(surah.nameTranslated),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall.copyWith(
                            color: MyColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm + 2),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: compact ? AppSpacing.xs : 6,
                          children: [
                            AppPill.surface(
                              label: _localizedRevelationType(context),
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
                            ? context.l10n.readQuranRemoveSurahBookmarkTooltip
                            : context.l10n.readQuranSaveSurahBookmarkTooltip,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: trailingArrowSize,
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

  String _localizedRevelationType(BuildContext context) {
    return switch (surah.revelationType) {
      'Meccan' => context.l10n.readQuranMeccan,
      'Medinan' => context.l10n.readQuranMedinan,
      _ => context.readQuranText(surah.revelationType),
    };
  }
}

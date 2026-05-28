import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_images.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/surah_model.dart';
import '../../common/app_pill.dart';

class SurahMetaCard extends StatelessWidget {
  const SurahMetaCard({
    super.key,
    required this.surah,
    required this.titleText,
  });

  final SurahModel surah;
  final String titleText;

  static const List<String> _backgroundImages = <String>[
    MyImages.background1,
    MyImages.background2,
    MyImages.background3,
    MyImages.background4,
    MyImages.background5,
    MyImages.background6,
    MyImages.background7,
    MyImages.background8,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgImage =
        _backgroundImages[(surah.id - 1) % _backgroundImages.length];

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.34),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.72),
                    colorScheme.tertiary.withValues(alpha: 0.68),
                    Colors.black.withValues(alpha: 0.42),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.52, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl - 2,
                AppSpacing.sm * 2.5,
                AppSpacing.xl - 2,
                AppSpacing.xl - 2,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: MyColors.textOnPrimary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          surah.nameArabic,
                          textAlign: TextAlign.center,
                          style: AppTheme.surahArabicName(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs + 1),
                  Text(
                    titleText,
                    style: AppTheme.text(
                      context,
                    ).titleLarge.copyWith(color: Colors.white),
                  ),
                  if (surah.nameEnglish.trim().isNotEmpty &&
                      titleText.trim().toLowerCase() !=
                          surah.nameEnglish.trim().toLowerCase()) ...[
                    const SizedBox(height: AppSpacing.xs + 1),
                    Text(
                      surah.nameEnglish,
                      textAlign: TextAlign.center,
                      style: AppTheme.text(context).bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg - 2),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    alignment: WrapAlignment.center,
                    children: [
                      AppPill.overlay(
                        icon: Icons.layers_outlined,
                        label:
                            '${surah.totalAyahs} ${context.l10n.readQuranAyahsLabel}',
                      ),
                      AppPill.overlay(
                        imgIcon: surah.revelationType == 'Meccan'
                            ? MyIcons.meccaIcon
                            : MyIcons.medinaIcon,
                        label: _localizedRevelationType(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_images.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_details_search_button.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/surah_model.dart';
import '../../../common/app_pill.dart';
import 'surah_bottom_controls.dart';

class SurahMetaCard extends StatelessWidget {
  const SurahMetaCard({
    super.key,
    required this.surah,
    required this.titleText,
    required this.readingViewMode,
    required this.showPronunciation,
    required this.showTranslation,
    required this.isPlayingFullSurah,
    required this.ayahs,
    required this.language,
    required this.onJumpToAyah,
    required this.onToggleReadingMode,
    required this.onTogglePronunciation,
    required this.onToggleTranslation,
    required this.onTogglePlayback,
  });

  final SurahModel surah;
  final String titleText;
  final ReadingViewMode readingViewMode;
  final bool showPronunciation;
  final bool showTranslation;
  final bool isPlayingFullSurah;
  final List<AyahModel> ayahs;
  final AppLanguage language;
  final ValueChanged<int> onJumpToAyah;
  final VoidCallback onToggleReadingMode;
  final VoidCallback onTogglePronunciation;
  final VoidCallback onToggleTranslation;
  final VoidCallback onTogglePlayback;

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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.34),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
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
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
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
                          titleText,
                          textAlign: TextAlign.center,
                          style: AppTheme.surahArabicName(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                      SurahDetailsSearchButton(
                        ayahs: ayahs,
                        language: language,
                        onJumpToAyah: onJumpToAyah,
                      ),
                    ],
                  ),
                  if (surah.nameEnglish.trim().isNotEmpty &&
                      titleText.trim().toLowerCase() !=
                          surah.nameEnglish.trim().toLowerCase())
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        surah.nameEnglish,
                        textAlign: TextAlign.center,
                        style: AppTheme.text(context).bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
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
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: Container(
                      width: 56,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(AppRadius.tiny),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SurahBottomControls(
                    embedded: true,
                    readingViewMode: readingViewMode,
                    showPronunciation: showPronunciation,
                    showTranslation: showTranslation,
                    isPlayingFullSurah: isPlayingFullSurah,
                    ayahs: ayahs,
                    language: language,
                    onJumpToAyah: onJumpToAyah,
                    onToggleReadingMode: onToggleReadingMode,
                    onTogglePronunciation: onTogglePronunciation,
                    onToggleTranslation: onToggleTranslation,
                    onTogglePlayback: onTogglePlayback,
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

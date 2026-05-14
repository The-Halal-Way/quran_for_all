import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/my_icons.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/surah_model.dart';
import '../../common/app_pill.dart';

class SurahMetaCard extends StatefulWidget {
  const SurahMetaCard({
    super.key,
    required this.surah,
    required this.isPlayingFullSurah,
    required this.onTogglePlayback,
  });

  final SurahModel surah;
  final bool isPlayingFullSurah;
  final VoidCallback onTogglePlayback;

  @override
  State<SurahMetaCard> createState() => _SurahMetaCardState();
}

class _SurahMetaCardState extends State<SurahMetaCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl - 2,
        AppSpacing.sm * 2.5,
        AppSpacing.xl - 2,
        AppSpacing.xl - 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                  widget.surah.nameArabic,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.surahArabicName(context),
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                ),
                tooltip: context.readQuranText(
                  _isExpanded ? 'Shrink card' : 'Expand card',
                ),
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const SizedBox(height: AppSpacing.xs + 1),
                Text(
                  widget.surah.nameEnglish,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xs + 1),
                Text(
                  context.readQuranText(widget.surah.nameTranslated),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg - 2),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    AppPill.overlay(
                      icon: Icons.layers_outlined,
                      label:
                          '${widget.surah.totalAyahs} ${context.readQuranText('ayahs')}',
                    ),
                    AppPill.overlay(
                      imgIcon: widget.surah.revelationType == 'Meccan'
                          ? MyIcons.meccaIcon
                          : MyIcons.medinaIcon,
                      label: context.readQuranText(widget.surah.revelationType),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg - 2),
                FilledButton.tonalIcon(
                  onPressed: widget.onTogglePlayback,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary,
                  ),
                  icon: Icon(
                    widget.isPlayingFullSurah
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_fill_rounded,
                  ),
                  label: Text(
                    context.readQuranText(
                      widget.isPlayingFullSurah
                          ? 'Stop Surah Audio'
                          : 'Play Full Surah',
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!_isExpanded) ...[
            const SizedBox(height: AppSpacing.sm),
            FilledButton.tonalIcon(
              onPressed: widget.onTogglePlayback,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorScheme.primary,
              ),
              icon: Icon(
                widget.isPlayingFullSurah
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_fill_rounded,
              ),
              label: Text(
                context.readQuranText(
                  widget.isPlayingFullSurah
                      ? 'Stop Surah Audio'
                      : 'Play Full Surah',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

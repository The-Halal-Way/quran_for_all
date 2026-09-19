import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/tasbeeh/tasbeeh_phrase_localizer.dart';

class TasbeehPhraseSelector extends StatelessWidget {
  const TasbeehPhraseSelector({
    super.key,
    required this.phrases,
    required this.selectedKey,
    required this.counts,
    required this.targets,
    required this.isDark,
    required this.onSelected,
  });

  final List<TasbeehPhrase> phrases;
  final TasbeehPhraseKey selectedKey;
  final Map<TasbeehPhraseKey, int> counts;
  final Map<TasbeehPhraseKey, int> targets;
  final bool isDark;
  final ValueChanged<TasbeehPhraseKey> onSelected;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final foreground = isDark ? Colors.white : MyColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          icon: CupertinoIcons.sparkles,
          title: context.l10n.tasbeehPhraseTitle,
          color: MyColors.secondary,
          foreground: foreground,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final phrase in phrases) ...[
                _PhraseOptionCard(
                  phrase: phrase,
                  isSelected: selectedKey == phrase.key,
                  count: counts[phrase.key] ?? 0,
                  target: targets[phrase.key] ?? 33,
                  isDark: isDark,
                  text: text,
                  onTap: () => onSelected(phrase.key),
                ),
                if (phrase != phrases.last) const SizedBox(width: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
    required this.foreground,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: text.dashboardSectionTitle.copyWith(color: foreground),
        ),
      ],
    );
  }
}

class _PhraseOptionCard extends StatelessWidget {
  const _PhraseOptionCard({
    required this.phrase,
    required this.isSelected,
    required this.count,
    required this.target,
    required this.isDark,
    required this.text,
    required this.onTap,
  });

  final TasbeehPhrase phrase;
  final bool isSelected;
  final int count;
  final int target;
  final bool isDark;
  final AppTypography text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isDark ? Colors.white : MyColors.textPrimary;
    final borderColor = isSelected
        ? MyColors.secondary
        : (isDark ? Colors.white : MyColors.divider).withValues(
            alpha: isDark ? 0.08 : 0.82,
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.relaxed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 184,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? MyColors.secondary.withValues(alpha: isDark ? 0.16 : 0.1)
              : (isDark ? MyColors.darkCardFill : Colors.white).withValues(
                  alpha: isDark ? 0.86 : 0.92,
                ),
          borderRadius: BorderRadius.circular(AppRadius.relaxed),
          border: Border.all(color: borderColor, width: isSelected ? 1.2 : 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    phrase.arabic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.amiri(
                      context,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                      height: 1.1,
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.circle,
                  color: isSelected
                      ? MyColors.secondary
                      : foreground.withValues(alpha: 0.35),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              phrase.key.label(context.l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelMedium.copyWith(
                color: foreground.withValues(alpha: 0.72),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: foreground.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '$count / $target',
                    style: text.labelSmall.copyWith(
                      color: isSelected
                          ? MyColors.secondary
                          : foreground.withValues(alpha: 0.68),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

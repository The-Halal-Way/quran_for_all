import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

import 'powerful_duah_data.dart';

class PowerfulAppBar extends StatelessWidget {
  const PowerfulAppBar({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppTheme.text(context);
    final colorScheme = theme.colorScheme;
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(
        context.l10n.duahPowerfulTitle,
        style: text.powerfulDuahAppBarTitle.copyWith(color: Colors.white),
      ),
      actions: const [_LanguageToggleAction()],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPORTANT NOTE BANNER
// ─────────────────────────────────────────────────────────────────────────────

class NoteBanner extends StatefulWidget {
  const NoteBanner({super.key, required this.isDark});
  final bool isDark;

  @override
  State<NoteBanner> createState() => NoteBannerState();
}

class NoteBannerState extends State<NoteBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final text = AppTheme.text(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: _dismissed
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 4),
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(
                      0xFF4B30A1,
                    ).withValues(alpha: widget.isDark ? 0.18 : 0.08),
                    const Color(
                      0xFF00BFA5,
                    ).withValues(alpha: widget.isDark ? 0.10 : 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF4B30A1).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B30A1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF4B30A1),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.duahPowerfulImportantNoteTitle,
                          style: text.powerfulDuahNoteTitle.copyWith(
                            color: const Color(0xFF4B30A1),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          context.l10n.duahPowerfulImportantNoteBody,
                          style: text.powerfulDuahNoteBody.copyWith(
                            color: widget.isDark
                                ? const Color(0xFFB39DDB)
                                : const Color(0xFF4C425C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _dismissed = true),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: widget.isDark
                          ? const Color(0xFF7E57C2)
                          : const Color(0xFF7A7288),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER ROW
// ─────────────────────────────────────────────────────────────────────────────

class FilterRow extends StatelessWidget {
  const FilterRow({
    super.key,
    required this.selected,
    required this.featuredOnly,
    required this.isDark,
    required this.onSituationChanged,
    required this.onFeaturedToggled,
  });

  final DuahSituation selected;
  final bool featuredOnly;
  final bool isDark;
  final ValueChanged<DuahSituation> onSituationChanged;
  final VoidCallback onFeaturedToggled;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Best 5" toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
          child: GestureDetector(
            onTap: onFeaturedToggled,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: featuredOnly
                    ? const Color(0xFFD50057).withValues(alpha: 0.14)
                    : (isDark ? const Color(0xFF1D1238) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: featuredOnly
                      ? const Color(0xFFD50057).withValues(alpha: 0.45)
                      : borderC,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: featuredOnly
                        ? const Color(0xFFD50057)
                        : (isDark
                              ? const Color(0xFF7E57C2)
                              : const Color(0xFF7A7288)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.duahPowerfulBestFive,
                    style: text.powerfulDuahFilterButton.copyWith(
                      color: featuredOnly
                          ? const Color(0xFFD50057)
                          : (isDark
                                ? const Color(0xFFB39DDB)
                                : const Color(0xFF4C425C)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Situation chips (horizontal scroll)
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: DuahSituation.values.map((s) {
              final isActive = selected == s;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onSituationChanged(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? s.color.withValues(alpha: isDark ? 0.20 : 0.12)
                          : (isDark ? const Color(0xFF1D1238) : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? s.color.withValues(alpha: 0.50)
                            : borderC,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          s.icon,
                          size: 13,
                          color: isActive
                              ? s.color
                              : (isDark
                                    ? const Color(0xFF7E57C2)
                                    : const Color(0xFF7A7288)),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          s.label(context),
                          style: text
                              .powerfulDuahFilterChip(isActive: isActive)
                              .copyWith(
                                color: isActive
                                    ? s.color
                                    : (isDark
                                          ? const Color(0xFFB39DDB)
                                          : const Color(0xFF4C425C)),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUNT BAR
// ─────────────────────────────────────────────────────────────────────────────

class CountBar extends StatelessWidget {
  const CountBar({
    super.key,
    required this.count,
    required this.total,
    required this.situation,
    required this.isDark,
  });

  final int count;
  final int total;
  final DuahSituation situation;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: situation.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.duahCountLabel(count),
            style: text.powerfulDuahCount.copyWith(
              color: isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288),
            ),
          ),
          if (count < total)
            Expanded(
              child: Text(
                context.l10n.duahCountOfTotal(count, total),
                textAlign: TextAlign.end,
                style: text.powerfulDuahCountMeta.copyWith(
                  color: isDark
                      ? const Color(0xFF382E54)
                      : const Color(0xFFD9D1E8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POWERFUL DUAH CARD
// ─────────────────────────────────────────────────────────────────────────────

class PowerfulDuahCard extends StatefulWidget {
  const PowerfulDuahCard({
    super.key,
    required this.duah,
    required this.isDark,
    required this.situationColor,
  });

  final PowerfulDuah duah;
  final bool isDark;
  final Color situationColor;

  @override
  State<PowerfulDuahCard> createState() => PowerfulDuahCardState();
}

class PowerfulDuahCardState extends State<PowerfulDuahCard> {
  bool _copied = false;
  bool _showPronunciation = true;

  void _copy() {
    Clipboard.setData(
      ClipboardData(
        text:
            '${widget.duah.arabic}\n\n${widget.duah.localizedPronunciation(context)}\n\n${widget.duah.localizedTranslation(context)}',
      ),
    );
    setState(() => _copied = true);
    Future.delayed(
      const Duration(seconds: 2),
      () => mounted ? setState(() => _copied = false) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final duah = widget.duah;
    final isDark = widget.isDark;

    final cardBg = isDark ? const Color(0xFF120A2B) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    // Featured cards get a faint fuchsia top-border glow
    final featuredBorder = duah.isFeatured
        ? Border.all(color: const Color(0xFFD50057).withValues(alpha: 0.35))
        : Border.all(color: borderC);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: featuredBorder,
        boxShadow: duah.isFeatured
            ? [
                BoxShadow(
                  color: const Color(0xFFD50057).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header strip ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
            decoration: BoxDecoration(
              color:
                  (duah.isFeatured
                          ? const Color(0xFFD50057)
                          : const Color(0xFF4B30A1))
                      .withValues(alpha: isDark ? 0.10 : 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color:
                        (duah.isFeatured
                                ? const Color(0xFFD50057)
                                : const Color(0xFF4B30A1))
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${duah.number}',
                    style: text.powerfulDuahNumber.copyWith(
                      color: duah.isFeatured
                          ? const Color(0xFFD50057)
                          : const Color(0xFF4B30A1),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        duah.localizedTitle(context),
                        style: text.titleMedium.copyWith(
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                        ),
                      ),
                      if (duah.source != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          duah.source!,
                          style: text.powerfulDuahSource.copyWith(
                            color: isDark
                                ? const Color(0xFF7E57C2)
                                : const Color(0xFF7A7288),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Featured star
                if (duah.isFeatured)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.star_rounded,
                      color: Color(0xFFD50057),
                      size: 16,
                    ),
                  ),
                // Situation tags
                ...duah.situations
                    .where((s) => s != DuahSituation.all)
                    .take(2)
                    .map(
                      (s) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: s.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(s.icon, size: 11, color: s.color),
                      ),
                    ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E0A3C,
                    ).withValues(alpha: isDark ? 0.45 : 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(
                        0xFF4B30A1,
                      ).withValues(alpha: isDark ? 0.18 : 0.08),
                    ),
                  ),
                  child: Text(
                    duah.arabic,
                    textAlign: TextAlign.center,
                    textDirection: ui.TextDirection.rtl,
                    style: text.powerfulDuahArabic.copyWith(
                      color: isDark
                          ? const Color(0xFFEDE7F6)
                          : const Color(0xFF120B24),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Pronunciation toggle
                GestureDetector(
                  onTap: () =>
                      setState(() => _showPronunciation = !_showPronunciation),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 13,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B30A1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _showPronunciation
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Text(
                            duah.localizedPronunciation(context),
                            style: text.powerfulDuahPronunciation.copyWith(
                              color: isDark
                                  ? const Color(0xFFB39DDB)
                                  : const Color(0xFF4C425C),
                            ),
                          ),
                          secondChild: Text(
                            context.l10n.duahTapToShowPronunciation,
                            style: text.powerfulDuahPronunciationHidden
                                .copyWith(
                                  color: isDark
                                      ? const Color(0xFF382E54)
                                      : const Color(0xFFD9D1E8),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Translation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: 13,
                      margin: const EdgeInsets.only(right: 8, top: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        duah.localizedTranslation(context),
                        style: text.powerfulDuahTranslation.copyWith(
                          color: isDark
                              ? const Color(0xFFEDE7F6)
                              : const Color(0xFF120B24),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom action row
                Row(
                  children: [
                    // Situation tag pills
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: duah.situations
                            .where((s) => s != DuahSituation.all)
                            .map(
                              (s) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: s.color.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: s.color.withValues(alpha: 0.22),
                                  ),
                                ),
                                child: Text(
                                  s.label(context),
                                  style: text.powerfulDuahTag.copyWith(
                                    color: s.color,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    // Copy button
                    GestureDetector(
                      onTap: _copy,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _copied
                              ? const Color(0xFF00BFA5).withValues(alpha: 0.12)
                              : (isDark
                                    ? const Color(0xFF1D1238)
                                    : const Color(0xFFF5F2FF)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _copied
                                ? const Color(0xFF00BFA5).withValues(alpha: 0.4)
                                : borderC,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _copied
                                  ? Icons.check_rounded
                                  : Icons.copy_rounded,
                              size: 14,
                              color: _copied
                                  ? const Color(0xFF00BFA5)
                                  : (isDark
                                        ? const Color(0xFF7E57C2)
                                        : const Color(0xFF7A7288)),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _copied
                                  ? context.l10n.duahCopied
                                  : context.l10n.duahCopy,
                              style: text.powerfulDuahCopyAction.copyWith(
                                color: _copied
                                    ? const Color(0xFF00BFA5)
                                    : (isDark
                                          ? const Color(0xFF7E57C2)
                                          : const Color(0xFF7A7288)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggleAction extends StatelessWidget {
  const _LanguageToggleAction();

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    final current = settingsVm.settings.language;
    final text = AppTheme.text(context);

    return PopupMenuButton<AppLanguage>(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      icon: const Icon(Icons.language_rounded, color: Colors.white),
      onSelected: (language) => settingsVm.setLanguage(language),
      itemBuilder: (context) => [
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.english,
          child: Text(
            context.appLanguageLabel(AppLanguage.english),
            style: current == AppLanguage.english
                ? text.labelMedium
                : text.bodyMedium,
          ),
        ),
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.bangla,
          child: Text(
            context.appLanguageLabel(AppLanguage.bangla),
            style: current == AppLanguage.bangla
                ? text.labelMedium
                : text.bodyMedium,
          ),
        ),
      ],
    );
  }
}

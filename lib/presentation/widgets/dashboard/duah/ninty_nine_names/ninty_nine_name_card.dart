import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/dashboard/ninety_nine_names.dart'
    as names_model;

import 'ninty_nine_names_localized.dart';

class NintyNineNameCard extends StatelessWidget {
  const NintyNineNameCard({
    super.key,
    required this.name,
    required this.language,
    required this.isDark,
  });

  final names_model.Name name;
  final AppLanguage language;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final accent = _accentFor(name.id);
    final cardBg = isDark ? MyColors.darkCardFill : MyColors.cardFill;
    final borderC = isDark ? MyColors.darkDivider : MyColors.divider;
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subtitleColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return GestureDetector(
      onTap: () => _showDetails(context, accent),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: borderC.withValues(alpha: isDark ? 0.8 : 1),
          ),
          boxShadow: AppShadows.card(tint: accent),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, MyColors.primaryLight],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -8,
                top: 8,
                child: Text(
                  name.id.toString().padLeft(2, '0'),
                  style: text.displaySmall.copyWith(
                    color: accent.withValues(alpha: isDark ? 0.14 : 0.08),
                    fontWeight: AppTheme.weightBlack,
                    height: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _IndexDiamond(number: name.id, accent: accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelSmall.copyWith(
                              color: subtitleColor,
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 52,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            name.arabic,
                            textAlign: TextAlign.center,
                            textDirection: ui.TextDirection.rtl,
                            style: AppTheme.amiri(
                              context,
                              fontSize: 33,
                              fontWeight: AppTheme.weightBold,
                              color: titleColor,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name.transliterationFor(language),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge.copyWith(
                        color: accent,
                        fontWeight: AppTheme.weightBlack,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      name.meaningFor(language),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall.copyWith(
                        color: subtitleColor,
                        height: 1.32,
                        fontWeight: AppTheme.weightMedium,
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

  void _showDetails(BuildContext context, Color accent) {
    final theme = Theme.of(context);
    final sheetBg = isDark ? MyColors.darkCardFill : MyColors.cardFill;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: sheetBg,
      barrierColor: Colors.black.withValues(alpha: 0.36),
      builder: (sheetContext) => NintyNineNameDetailsSheet(
        name: name,
        language: language,
        accent: accent,
        isDark: theme.brightness == Brightness.dark,
      ),
    );
  }
}

class NintyNineNameDetailsSheet extends StatelessWidget {
  const NintyNineNameDetailsSheet({
    super.key,
    required this.name,
    required this.language,
    required this.accent,
    required this.isDark,
  });

  final names_model.Name name;
  final AppLanguage language;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: _IndexDiamond(number: name.id, accent: accent, size: 42),
          ),
          const SizedBox(height: 14),
          Text(
            name.arabic,
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: AppTheme.amiri(
              context,
              fontSize: 44,
              fontWeight: AppTheme.weightBold,
              color: titleColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name.transliterationFor(language),
            textAlign: TextAlign.center,
            style: text.titleLarge.copyWith(
              color: accent,
              fontWeight: AppTheme.weightBlack,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name.meaningFor(language),
            textAlign: TextAlign.center,
            style: text.bodyLarge.copyWith(
              color: titleColor,
              fontWeight: AppTheme.weightSemiBold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.16 : 0.10),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: accent.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.category_rounded, color: accent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name.category,
                    style: text.labelMedium.copyWith(
                      color: bodyColor,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexDiamond extends StatelessWidget {
  const _IndexDiamond({
    required this.number,
    required this.accent,
    this.size = 30,
  });

  final int number;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Transform.rotate(
      angle: 0.785398,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, MyColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(7),
          boxShadow: AppShadows.glow(accent, intensity: 0.16),
        ),
        child: Center(
          child: Transform.rotate(
            angle: -0.785398,
            child: Text(
              number.toString().padLeft(2, '0'),
              style: text.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.weightBlack,
                fontSize: size <= 30 ? 9.5 : 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _accentFor(int id) {
  const accents = [
    MyColors.secondary,
    MyColors.tertiary,
    MyColors.primaryLight,
    MyColors.info,
    Color(0xFF8E24AA),
  ];
  return accents[id % accents.length];
}

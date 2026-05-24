import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

class PrayerNowCard extends StatelessWidget {
  const PrayerNowCard({super.key, required this.content});

  final PrayerFocusContent content;

  @override
  Widget build(BuildContext context) {
    final accent = PrayerVisuals.accentFor(content.prayer);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      gradient: LinearGradient(
        colors: [
          accent.withValues(alpha: isDark ? 0.16 : 0.08),
          MyColors.secondary.withValues(alpha: isDark ? 0.11 : 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: accent.withValues(alpha: 0.22),
      shadowColor: accent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.18 : 0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: accent.withValues(alpha: 0.32)),
            ),
            child: Icon(Icons.route_rounded, color: accent, size: 23),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.now.title,
                  style: GoogleFonts.sora(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  content.now.body,
                  style: GoogleFonts.manrope(
                    color: subColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
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

class PrayerSuggestionsSection extends StatelessWidget {
  const PrayerSuggestionsSection({
    super.key,
    required this.items,
    required this.accent,
  });

  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _GuidanceLine(
              icon: Icons.auto_awesome_rounded,
              marker: '${index + 1}',
              body: items[index],
              accent: accent,
            ),
            if (index != items.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class HowToPraySection extends StatelessWidget {
  const HowToPraySection({super.key, required this.steps});

  final List<PrayerGuidanceItem> steps;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      child: Column(
        children: [
          for (var index = 0; index < steps.length; index++) ...[
            _PrayerStepLine(index: index, step: steps[index]),
            if (index != steps.length - 1)
              const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class BestPracticesSection extends StatelessWidget {
  const BestPracticesSection({
    super.key,
    required this.items,
    required this.accent,
  });

  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return PrayerCardShell(
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _GuidanceLine(
              icon: Icons.check_rounded,
              body: items[index],
              accent: accent,
            ),
            if (index != items.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class PrayerFiqhNote extends StatelessWidget {
  const PrayerFiqhNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      margin: const EdgeInsets.only(top: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: MyColors.tertiary.withValues(alpha: 0.22),
      gradient: LinearGradient(
        colors: [
          MyColors.tertiary.withValues(alpha: isDark ? 0.12 : 0.06),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: MyColors.tertiary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.prayerViewFiqhNoteTitle,
                  style: GoogleFonts.sora(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.prayerViewFiqhNoteBody,
                  style: GoogleFonts.manrope(
                    color: subColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
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

class PrayerStateCard extends StatelessWidget {
  const PrayerStateCard.loading({super.key})
    : title = '',
      body = '',
      icon = Icons.hourglass_empty_rounded,
      isLoading = true,
      onRetry = null;

  const PrayerStateCard.error({
    super.key,
    required this.title,
    required this.body,
    required this.onRetry,
  }) : icon = Icons.location_off_rounded,
       isLoading = false;

  final String title;
  final String body;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.secondary,
                  strokeWidth: 2.4,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: MyColors.secondary, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.sora(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            body,
                            style: GoogleFonts.manrope(
                              color: subColor,
                              fontSize: 12.5,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 17),
                    label: Text(context.l10n.dashboardRetry),
                  ),
                ),
              ],
            ),
    );
  }
}

class _GuidanceLine extends StatelessWidget {
  const _GuidanceLine({
    required this.icon,
    required this.body,
    required this.accent,
    this.marker,
  });

  final IconData icon;
  final String? marker;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: marker == null
              ? Icon(icon, size: 17, color: accent)
              : Center(
                  child: Text(
                    marker!,
                    style: GoogleFonts.sora(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            body,
            style: GoogleFonts.manrope(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrayerStepLine extends StatelessWidget {
  const _PrayerStepLine({required this.index, required this.step});

  final int index;
  final PrayerGuidanceItem step;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final accent = index.isEven ? MyColors.secondary : MyColors.tertiary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.32)),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: GoogleFonts.sora(
                color: accent,
                fontSize: 13,
                fontWeight: FontWeight.w900,
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
                step.title,
                style: GoogleFonts.sora(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                step.body,
                style: GoogleFonts.manrope(
                  color: subColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

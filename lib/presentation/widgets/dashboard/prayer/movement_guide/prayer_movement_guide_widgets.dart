import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/theme/my_images.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';

// MARK: Prayer - Movement Guide Hero
class PrayerMovementGuideHero extends StatelessWidget {
  const PrayerMovementGuideHero({super.key, required this.stepCount});

  final int stepCount;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final heroCopy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeroEyebrow(label: context.l10n.prayerMovementsHeroEyebrow),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.prayerMovementsHeroTitle,
              style: text.prayerHeroTitle.copyWith(
                color: Colors.white,
                height: 1.08,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.prayerMovementsHeroBody,
              style: text.prayerHeroSubtitle.copyWith(
                color: Colors.white.withValues(alpha: 0.84),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _HeroStatChip(
                  icon: Icons.self_improvement_rounded,
                  label: context.l10n.prayerMovementsHeroStepsCount(stepCount),
                ),
                _HeroStatChip(
                  icon: Icons.record_voice_over_rounded,
                  label: context.l10n.prayerMovementsHeroArabicLabel,
                ),
                _HeroStatChip(
                  icon: Icons.menu_book_rounded,
                  label: context.l10n.prayerMovementsHeroHadithLabel,
                ),
              ],
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: const LinearGradient(
              colors: [
                MyColors.primaryDark,
                MyColors.primary,
                MyColors.secondaryDark,
                MyColors.tertiaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: AppShadows.card(tint: MyColors.secondary),
          ),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: isWide
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (isWide) Expanded(flex: 6, child: heroCopy) else heroCopy,
              if (isWide) const SizedBox(width: AppSpacing.xxl),
              if (!isWide) const SizedBox(height: AppSpacing.xl),
              if (isWide)
                const Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _HeroImageStage(),
                  ),
                )
              else
                const Align(
                  alignment: Alignment.center,
                  child: _HeroImageStage(),
                ),
            ],
          ),
        );
      },
    );
  }
}

// MARK: Prayer - Movement Flow Chips
class PrayerMovementFlowChips extends StatelessWidget {
  const PrayerMovementFlowChips({super.key, required this.steps});

  final List<PrayerMovementStep> steps;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final step in steps)
          _FlowChip(
            number: step.number,
            label: step.title,
            accent: _accentFor(step.number),
          ),
      ],
    );
  }
}

// MARK: Prayer - Movement Step Card
class PrayerMovementStepCard extends StatelessWidget {
  const PrayerMovementStepCard({
    super.key,
    required this.step,
    required this.reverseOnWide,
  });

  final PrayerMovementStep step;
  final bool reverseOnWide;

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(step.number);

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: accent.withValues(alpha: 0.22),
      shadowColor: accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final image = _MovementImageFrame(step: step, accent: accent);
          final details = _MovementStepDetails(step: step, accent: accent);

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                image,
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: details,
                ),
              ],
            );
          }

          final children = [
            SizedBox(width: 274, child: image),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: details,
              ),
            ),
          ];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reverseOnWide ? children.reversed.toList() : children,
          );
        },
      ),
    );
  }
}

// MARK: Prayer - Movement Hadith Panel
class PrayerMovementHadithPanel extends StatelessWidget {
  const PrayerMovementHadithPanel({super.key, required this.hadiths});

  final List<PrayerHadithReference> hadiths;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      borderColor: MyColors.tertiary.withValues(alpha: 0.22),
      shadowColor: MyColors.tertiary,
      gradient: LinearGradient(
        colors: [
          MyColors.tertiary.withValues(alpha: isDark ? 0.14 : 0.07),
          MyColors.secondary.withValues(alpha: isDark ? 0.10 : 0.04),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: MyColors.tertiary.withValues(
                    alpha: isDark ? 0.20 : 0.13,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: MyColors.tertiary.withValues(alpha: 0.30),
                  ),
                ),
                child: const Icon(
                  Icons.format_quote_rounded,
                  color: MyColors.tertiary,
                  size: 21,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.prayerMovementsHadithTitle,
                      style: text.prayerCardTitle.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.prayerMovementsHadithSubtitle,
                      style: text.prayerCardBody.copyWith(
                        color: bodyColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var index = 0; index < hadiths.length; index++) ...[
            _HadithLine(reference: hadiths[index]),
            if (index != hadiths.length - 1)
              Divider(
                height: AppSpacing.xxl,
                color: (isDark ? MyColors.darkDivider : MyColors.divider)
                    .withValues(alpha: 0.62),
              ),
          ],
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Fiqh Note
class PrayerMovementFiqhNote extends StatelessWidget {
  const PrayerMovementFiqhNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return PrayerCardShell(
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: MyColors.secondary.withValues(alpha: 0.20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: MyColors.secondaryLight,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.prayerMovementsFiqhNoteTitle,
                  style: text.prayerStepIndex.copyWith(
                    color: titleColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.prayerMovementsFiqhNoteBody,
                  style: text.bodySmall.copyWith(color: bodyColor, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Step Details
class _MovementStepDetails extends StatelessWidget {
  const _MovementStepDetails({required this.step, required this.accent});

  final PrayerMovementStep step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _StepNumberBadge(number: step.number, accent: accent),
            _StepBadge(label: step.badge, accent: accent),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          step.title,
          style: text.prayerHeroTitle.copyWith(
            color: titleColor,
            fontSize: AppTheme.scaledFontSize(context, 23),
            height: 1.13,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          step.body,
          style: text.prayerCardBodyEmphasis.copyWith(
            color: bodyColor,
            height: 1.55,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ArabicRecitationBlock(arabic: step.arabic, accent: accent),
        const SizedBox(height: AppSpacing.md),
        _LabeledTextBlock(
          icon: Icons.record_voice_over_rounded,
          label: context.l10n.prayerMovementsPronunciationLabel,
          value: step.pronunciation,
          accent: accent,
        ),
        const SizedBox(height: AppSpacing.md),
        _LabeledTextBlock(
          icon: Icons.translate_rounded,
          label: context.l10n.prayerMovementsTranslationLabel,
          value: step.translation,
          accent: MyColors.tertiary,
        ),
        const SizedBox(height: AppSpacing.md),
        _MovementNote(note: step.note, accent: accent),
      ],
    );
  }
}

// MARK: Prayer - Movement Arabic Recitation Block
class _ArabicRecitationBlock extends StatelessWidget {
  const _ArabicRecitationBlock({required this.arabic, required this.accent});

  final String arabic;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final arabicSize = arabic.length > 220 ? 21.0 : 25.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BlockLabel(
            icon: Icons.auto_stories_rounded,
            label: context.l10n.prayerMovementsArabicLabel,
            accent: accent,
          ),
          const SizedBox(height: AppSpacing.md),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SelectableText(
              arabic,
              textAlign: TextAlign.right,
              style: AppTheme.amiri(
                context,
                fontSize: arabicSize,
                fontWeight: AppTheme.weightBold,
                height: 1.85,
                color: isDark ? MyColors.darkTextPrimary : MyColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Labeled Text Block
class _LabeledTextBlock extends StatelessWidget {
  const _LabeledTextBlock({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final color = isDark ? MyColors.darkTextSecondary : MyColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BlockLabel(icon: icon, label: label, accent: accent),
        const SizedBox(height: AppSpacing.xs),
        SelectableText(
          value,
          style: text.prayerCardBodyEmphasis.copyWith(
            color: color,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

// MARK: Prayer - Movement Note
class _MovementNote extends StatelessWidget {
  const _MovementNote({required this.note, required this.accent});

  final String note;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates_rounded, color: accent, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.prayerMovementsNoteLabel,
                  style: text.prayerStatusChip.copyWith(color: accent),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  note,
                  style: text.bodySmall.copyWith(
                    color: isDark
                        ? MyColors.darkTextSecondary
                        : MyColors.textSecondary,
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

// MARK: Prayer - Movement Image Frame
class _MovementImageFrame extends StatelessWidget {
  const _MovementImageFrame({required this.step, required this.accent});

  final PrayerMovementStep step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 316,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: isDark ? 0.34 : 0.18),
            MyColors.primaryLight.withValues(alpha: isDark ? 0.30 : 0.12),
            MyColors.secondary.withValues(alpha: isDark ? 0.25 : 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _MovementFramePainter(accent: accent)),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Text(
              step.number.toString().padLeft(2, '0'),
              style: AppTheme.sora(
                context,
                fontSize: 46,
                fontWeight: AppTheme.weightBlack,
                color: Colors.white.withValues(alpha: 0.17),
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 0,
            child: _StepBadge(label: step.badge, accent: Colors.white),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              step.imageAsset,
              height: 276,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.self_improvement_rounded,
                  size: 96,
                  color: Colors.white.withValues(alpha: 0.80),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Hero Image Stage
class _HeroImageStage extends StatelessWidget {
  const _HeroImageStage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 286,
      height: 238,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MovementFramePainter(accent: MyColors.tertiaryLight),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 0,
            child: Image.asset(
              MyImages.sajjadah,
              height: 168,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 8,
            bottom: 0,
            child: Image.asset(
              MyImages.takbeerh,
              height: 226,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Hero Eyebrow
class _HeroEyebrow extends StatelessWidget {
  const _HeroEyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: text.prayerHeroChip.copyWith(color: Colors.white),
      ),
    );
  }
}

// MARK: Prayer - Movement Hero Stat Chip
class _HeroStatChip extends StatelessWidget {
  const _HeroStatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: text.prayerHeroChip.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Flow Chip
class _FlowChip extends StatelessWidget {
  const _FlowChip({
    required this.number,
    required this.label,
    required this.accent,
  });

  final int number;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TinyNumber(number: number, accent: accent),
          const SizedBox(width: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 172),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.prayerStatusChip.copyWith(color: accent),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: Prayer - Movement Step Number Badge
class _StepNumberBadge extends StatelessWidget {
  const _StepNumberBadge({required this.number, required this.accent});

  final int number;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: text.prayerStepIndex.copyWith(color: accent),
        ),
      ),
    );
  }
}

// MARK: Prayer - Movement Step Badge
class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isWhite = accent == Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isWhite ? 0.13 : 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.prayerStatusChip.copyWith(color: accent),
      ),
    );
  }
}

// MARK: Prayer - Movement Tiny Number
class _TinyNumber extends StatelessWidget {
  const _TinyNumber({required this.number, required this.accent});

  final int number;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: text.prayerStatusChip.copyWith(color: accent, height: 1),
        ),
      ),
    );
  }
}

// MARK: Prayer - Movement Block Label
class _BlockLabel extends StatelessWidget {
  const _BlockLabel({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: accent),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.prayerStatusChip.copyWith(color: accent),
          ),
        ),
      ],
    );
  }
}

// MARK: Prayer - Movement Hadith Row
class _HadithLine extends StatelessWidget {
  const _HadithLine({required this.reference});

  final PrayerHadithReference reference;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: MyColors.secondary.withValues(alpha: isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: MyColors.secondary,
            size: 16,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reference.body,
                style: text.prayerCardBodyEmphasis.copyWith(color: bodyColor),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${context.l10n.prayerMovementsHadithSourceLabel}: '
                '${reference.source}',
                style: text.prayerStatusChip.copyWith(
                  color: MyColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// MARK: Prayer - Movement Decorative Frame Painter
class _MovementFramePainter extends CustomPainter {
  const _MovementFramePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    final accentPaint = Paint()
      ..color = accent.withValues(alpha: 0.20)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 4; i++) {
      final top = size.height * (0.18 + i * 0.17);
      canvas.drawLine(
        Offset(size.width * 0.08, top),
        Offset(size.width * 0.92, top + 28),
        paint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.10,
          size.height * 0.13,
          size.width * 0.76,
          size.height * 0.68,
        ),
        const Radius.circular(AppRadius.lg),
      ),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MovementFramePainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}

// MARK: Prayer - Movement Accent
Color _accentFor(int number) {
  switch (number % 4) {
    case 0:
      return MyColors.info;
    case 1:
      return MyColors.secondary;
    case 2:
      return MyColors.tertiary;
    default:
      return MyColors.primaryLight;
  }
}

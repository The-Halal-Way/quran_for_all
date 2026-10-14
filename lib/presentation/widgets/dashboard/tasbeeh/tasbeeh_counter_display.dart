import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'tasbeeh_counter_ring.dart';
import 'tasbeeh_ornament.dart';
import 'tasbeeh_phrase_navigation.dart';
import 'tasbeeh_visuals.dart';

class TasbeehCounterDisplay extends StatelessWidget {
  const TasbeehCounterDisplay({
    super.key,
    required this.count,
    required this.target,
    required this.progress,
    required this.phraseArabic,
    required this.phraseId,
    required this.phraseLabel,
    required this.phraseMeaning,
    required this.isTargetReached,
    required this.isDark,
    required this.onTap,
    required this.onPhraseTap,
    required this.onAddPhrase,
    required this.onPreviousPhrase,
    required this.onNextPhrase,
    this.phraseMenu,
  });

  final int count;
  final int target;
  final double progress;
  final String phraseArabic;
  final String phraseId;
  final String phraseLabel;
  final String phraseMeaning;
  final bool isTargetReached;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onPhraseTap;
  final VoidCallback onAddPhrase;
  final VoidCallback? onPreviousPhrase;
  final VoidCallback? onNextPhrase;
  final Widget? phraseMenu;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = TasbeehVisuals.heroColors(context);
    return Semantics(
      button: true,
      label: '$phraseLabel, $count, ${context.l10n.tasbeehTarget} $target',
      child: GestureDetector(
        key: const ValueKey('tasbeeh_count_area'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: colors.last.withValues(alpha: isDark ? 0.16 : 0.22),
                blurRadius: 25,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: TasbeehOrnament()),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
                child: Column(
                  children: [
                    KeyedSubtree(
                      key: ValueKey(phraseId),
                      child: _TasbeehCounterHeader(
                        target: target,
                        phraseMenu: phraseMenu,
                        onAddPhrase: onAddPhrase,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TasbeehPhraseNavigationButton(
                          key: const ValueKey('tasbeeh_previous_dhikr'),
                          direction: TasbeehPhraseNavigationDirection.previous,
                          onPressed: onPreviousPhrase,
                        ),
                        Expanded(
                          child: Semantics(
                            button: true,
                            label: context.l10n.tasbeehPhraseOptions,
                            child: GestureDetector(
                              onTap: onPhraseTap,
                              onHorizontalDragEnd: (details) {
                                final velocity = details.primaryVelocity ?? 0;
                                if (velocity > 0) {
                                  onPreviousPhrase?.call();
                                } else if (velocity < 0) {
                                  onNextPhrase?.call();
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                child: Column(
                                  children: [
                                    if (phraseArabic.isNotEmpty) ...[
                                      Text(
                                        phraseArabic,
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                        style: AppTheme.amiri(
                                          context,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                    ],
                                    Text(
                                      phraseLabel,
                                      textAlign: TextAlign.center,
                                      style: text.titleSmall.copyWith(
                                        color: TasbeehVisuals.gold,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (phraseMeaning.isNotEmpty) ...[
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        phraseMeaning,
                                        textAlign: TextAlign.center,
                                        style: text.bodySmall.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.78,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        TasbeehPhraseNavigationButton(
                          key: const ValueKey('tasbeeh_next_dhikr'),
                          direction: TasbeehPhraseNavigationDirection.next,
                          onPressed: onNextPhrase,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TasbeehCounterRing(
                      count: count,
                      target: target,
                      progress: progress,
                      isTargetReached: isTargetReached,
                      onHero: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.touch_app_rounded,
                          size: 18,
                          color: TasbeehVisuals.mint,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                          child: Text(
                            context.l10n.tasbeehTapToCount,
                            textAlign: TextAlign.center,
                            style: text.labelMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}

class _TasbeehCounterHeader extends StatelessWidget {
  const _TasbeehCounterHeader({
    required this.target,
    required this.phraseMenu,
    required this.onAddPhrase,
  });

  final int target;
  final Widget? phraseMenu;
  final VoidCallback onAddPhrase;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final controls = <Widget>[
      IconButton(
        key: const ValueKey('tasbeeh_add'),
        onPressed: onAddPhrase,
        tooltip: context.l10n.tasbeehAddDhikr,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        color: TasbeehVisuals.mint,
        icon: const Icon(Icons.add_rounded, size: 19),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Text(
          '${context.l10n.tasbeehTarget} $target',
          style: text.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];

    final title = Row(
      children: [
        const Icon(
          Icons.auto_awesome_rounded,
          color: TasbeehVisuals.gold,
          size: 17,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            context.l10n.tasbeehCurrent,
            style: text.labelSmall.copyWith(
              color: TasbeehVisuals.gold,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ),
        ?phraseMenu,
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: AppSpacing.xs),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: controls),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: title),
            ...controls,
          ],
        );
      },
    );
  }
}

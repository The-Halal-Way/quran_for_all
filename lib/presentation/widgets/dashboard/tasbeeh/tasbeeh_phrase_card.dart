import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/tasbeeh/tasbeeh_phrase.dart';
import 'tasbeeh_phrase_actions.dart';
import 'tasbeeh_phrase_localizer.dart';
import 'tasbeeh_phrase_menu.dart';

class TasbeehPhraseCard extends StatelessWidget {
  static const width = 196.0;
  const TasbeehPhraseCard({
    super.key,
    required this.phrase,
    required this.isSelected,
    required this.count,
    required this.target,
    required this.onTap,
    required this.onAction,
  });
  final TasbeehPhrase phrase;
  final bool isSelected;
  final int count;
  final int target;
  final VoidCallback onTap;
  final ValueChanged<TasbeehPhraseAction> onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final label = phrase.label(context.l10n);
    final meaning = phrase.localizedMeaning(context.l10n);
    final progress = count == 0
        ? 0.0
        : (count % target == 0 ? 1.0 : (count % target) / target);
    return Semantics(
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.relaxed),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: width,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.primaryContainer, colors.surface],
                  )
                : null,
            color: isSelected ? null : colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.relaxed),
            border: Border.all(
              color: isSelected ? colors.primary : colors.outlineVariant,
              width: isSelected ? 1.3 : 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      phrase.arabic.isEmpty ? label : phrase.arabic,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: phrase.arabic.isEmpty
                          ? null
                          : TextDirection.rtl,
                      style: phrase.arabic.isEmpty
                          ? text.titleSmall.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w800,
                            )
                          : AppTheme.amiri(
                              context,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                              height: 1.2,
                            ),
                    ),
                  ),
                  if (!phrase.isBuiltIn)
                    TasbeehPhraseMenu(onSelected: onAction)
                  else
                    Icon(
                      isSelected
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons.circle,
                      color: isSelected
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      size: 18,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                phrase.arabic.isEmpty ? context.l10n.tasbeehMyDhikr : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelMedium.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (meaning.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  meaning,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$count / $target',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  if (phrase.isBuiltIn)
                    Tooltip(
                      message: context.l10n.tasbeehBuiltIn,
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 15,
                        color: colors.onSurfaceVariant,
                      ),
                    )
                  else if (isSelected)
                    Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      size: 17,
                      color: colors.primary,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: colors.primary.withValues(alpha: 0.1),
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

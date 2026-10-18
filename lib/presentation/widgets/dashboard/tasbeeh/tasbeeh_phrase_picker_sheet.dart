import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'tasbeeh_phrase_actions.dart';
import 'tasbeeh_phrase_localizer.dart';
import 'tasbeeh_phrase_menu.dart';

Future<void> showTasbeehPhrasePicker(
  BuildContext context,
  TasbeehViewModel model,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      builder: (context, scrollController) => ListenableBuilder(
        listenable: model,
        builder: (_, _) => _TasbeehPhrasePickerSheet(
          model: model,
          scrollController: scrollController,
        ),
      ),
    ),
  );
}

class _TasbeehPhrasePickerSheet extends StatelessWidget {
  const _TasbeehPhrasePickerSheet({
    required this.model,
    required this.scrollController,
  });

  final TasbeehViewModel model;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        child: Material(
          color: scheme.surface,
          child: Column(
            children: [
              _PickerHeader(
                selectedPhrase: model.hasPhrases ? model.selectedPhrase : null,
                accent: colors.violet,
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  itemCount: model.phrases.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final phrase = model.phrases[index];
                    return _PickerPhraseTile(
                      phrase: phrase,
                      count: model.countFor(phrase.id),
                      target: model.targetFor(phrase.id),
                      selected: phrase.id == model.selectedPhraseId,
                      onSelected: () {
                        model.selectPhrase(phrase.id);
                        Navigator.of(context).pop();
                      },
                      onAction: (action) => TasbeehPhraseActions.handle(
                        context,
                        model,
                        phrase,
                        action,
                      ),
                    );
                  },
                ),
              ),
              _PickerFooter(
                onAdd: () => TasbeehPhraseActions.add(context, model),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerHeader extends StatelessWidget {
  const _PickerHeader({required this.selectedPhrase, required this.accent});

  final TasbeehPhrase? selectedPhrase;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, AppThemeColors.light.cyan],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.58),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.tasbeehPhraseOptions,
            style: text.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            selectedPhrase == null
                ? context.l10n.tasbeehEmptySessionDescription
                : '${context.l10n.tasbeehCurrent}: ${selectedPhrase!.label(context.l10n)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerPhraseTile extends StatelessWidget {
  const _PickerPhraseTile({
    required this.phrase,
    required this.count,
    required this.target,
    required this.selected,
    required this.onSelected,
    required this.onAction,
  });

  final TasbeehPhrase phrase;
  final int count;
  final int target;
  final bool selected;
  final VoidCallback onSelected;
  final ValueChanged<TasbeehPhraseAction> onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final label = phrase.label(context.l10n);
    final meaning = phrase.localizedMeaning(context.l10n);
    final progress = count == 0
        ? 0.0
        : (count % target == 0 ? 1.0 : (count % target) / target);

    return Material(
      color: selected
          ? Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.09),
              scheme.surface,
            )
          : scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelected,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: phrase.arabic.isEmpty
                        ? Text(
                            label,
                            style: text.titleSmall.copyWith(
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          )
                        : Text(
                            phrase.arabic,
                            textDirection: TextDirection.rtl,
                            style: AppTheme.amiri(
                              context,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                  ),
                  if (phrase.isBuiltIn)
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: selected
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    )
                  else
                    TasbeehPhraseMenu(onSelected: onAction),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                phrase.arabic.isEmpty ? context.l10n.tasbeehMyDhikr : label,
                style: text.labelMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (meaning.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  meaning,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.loop_rounded, size: 15, color: scheme.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '$count / $target',
                    style: text.labelMedium.copyWith(
                      color: scheme.onSurface,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                  const Spacer(),
                  if (selected)
                    Text(
                      context.l10n.tasbeehCurrent,
                      style: text.labelSmall.copyWith(
                        color: scheme.primary,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: scheme.primary.withValues(alpha: 0.1),
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerFooter extends StatelessWidget {
  const _PickerFooter({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: Text(context.l10n.tasbeehAddDhikr),
        ),
      ),
    ),
  );
}

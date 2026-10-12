import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../data/models/prophecies/prophecy_book.dart';
import 'prophecy_source_link_button.dart';

/// Opens the prophecy reader sheet.
///
/// The function keeps its original name so existing callers do not need to
/// know whether the entry is presented as a dialog or a bottom sheet.
Future<void> showProphecyEntryDialog(BuildContext context, ProphecyItem item) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (_) => _ProphecyEntrySheet(item: item),
    );

class _ProphecyEntrySheet extends StatelessWidget {
  const _ProphecyEntrySheet({required this.item});

  final ProphecyItem item;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final details = item.detailsPage;
    final content = item.localizedContent(locale).trim();
    final scheme = Theme.of(context).colorScheme;
    final colors = AppThemeColors.light;
    final accent = colors.coral;
    final number = item.sourceNumbers.isNotEmpty
        ? item.sourceNumbers.first
        : null;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
          child: Material(
            color: scheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ProphecySheetHeader(
                  title: item.localizedTitle(locale),
                  number: number,
                  accent: accent,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    gradient: LinearGradient(
                      colors: [
                        scheme.surface,
                        Color.alphaBlend(
                          colors.violet.withValues(alpha: 0.035),
                          scheme.surface,
                        ),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.58,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.lg,
                      ),
                      children: [
                        if (details != null && details.url == null) ...[
                          const _ComingSoonBanner(),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        if (content.isNotEmpty)
                          _ProphecyContent(content: content, accent: accent)
                        else if (details == null)
                          const _EmptyContentMessage(),
                        if (details?.url case final sourceUrl?) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: ProphecySourceLinkButton(
                              url: sourceUrl,
                              color: accent,
                            ),
                          ),
                        ],
                        if (item.usesEnglishFallback(locale)) ...[
                          const SizedBox(height: AppSpacing.lg),
                          const _EnglishFallbackNote(),
                        ],
                        if (item.references.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xxl),
                          _ReferencesCard(references: item.references),
                        ],
                      ],
                    ),
                  ),
                ),
                _SheetFooter(accent: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProphecySheetHeader extends StatelessWidget {
  const _ProphecySheetHeader({
    required this.title,
    required this.number,
    required this.accent,
  });

  final String title;
  final int? number;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, AppThemeColors.light.violet],
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
                color: Colors.white.withValues(alpha: 0.56),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: number == null
                    ? const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                      )
                    : Text(
                        '$number',
                        style: text.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: text.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.weightExtraBold,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SheetCloseButton(onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  const _SheetCloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
    style: IconButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.16),
      padding: const EdgeInsets.all(AppSpacing.sm),
    ),
    icon: const Icon(Icons.close_rounded),
  );
}

class _ProphecyContent extends StatelessWidget {
  const _ProphecyContent({required this.content, required this.accent});

  final String content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final paragraphs = content
        .split(RegExp(r'\n\s*\n'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < paragraphs.length; index++) ...[
          _ProphecyParagraph(text: paragraphs[index], accent: accent),
          if (index < paragraphs.length - 1)
            const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _ProphecyParagraph extends StatelessWidget {
  const _ProphecyParagraph({required this.text, required this.accent});

  final String text;
  final Color accent;

  bool get _isQuote {
    final value = text.trimLeft();
    return value.startsWith('“') ||
        value.startsWith('"') ||
        value.startsWith('‘') ||
        value.startsWith('The Prophet');
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTheme.text(
      context,
    ).bodyLarge.copyWith(height: 1.58, letterSpacing: 0.08);
    if (!_isQuote) return Text(text, style: style);

    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Text(
        text,
        style: style.copyWith(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ReferencesCard extends StatelessWidget {
  const _ReferencesCard({required this.references});

  final List<ProphecyReference> references;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = AppThemeColors.light.cyan;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Color.alphaBlend(accent.withValues(alpha: 0.07), scheme.surface),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: accent, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                context.l10n.propheciesReferences,
                style: AppTheme.text(context).titleSmall.copyWith(
                  color: accent,
                  fontWeight: AppTheme.weightExtraBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final reference in references)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: AppTheme.text(context).bodyMedium.copyWith(
                      color: accent,
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      reference.text,
                      style: AppTheme.text(context).bodySmall,
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

class _EmptyContentMessage extends StatelessWidget {
  const _EmptyContentMessage();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    child: Text(
      context.l10n.propheciesContentComingSoon,
      style: AppTheme.text(context).bodyLarge,
    ),
  );
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.md,
      AppSpacing.xl,
      AppSpacing.lg,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(
        top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    ),
    child: Align(
      alignment: AlignmentDirectional.centerEnd,
      child: FilledButton.tonalIcon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.check_rounded),
        label: Text(context.l10n.propheciesClose),
        style: FilledButton.styleFrom(
          backgroundColor: accent.withValues(alpha: 0.1),
          foregroundColor: accent,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    ),
  );
}

class _EnglishFallbackNote extends StatelessWidget {
  const _EnglishFallbackNote();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.translate_rounded, size: 18, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.propheciesEnglishFallbackNote,
                style: AppTheme.text(context).bodySmall.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonBanner extends StatelessWidget {
  const _ComingSoonBanner();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.auto_awesome_rounded, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.propheciesDetailsComingSoon,
                style: AppTheme.text(context).bodySmall.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

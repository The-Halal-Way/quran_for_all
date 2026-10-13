import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/datasources/local/mercy_collection_loader.dart';
import '../../../../data/models/mercy/mercy_collection.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/common/app_language_action_button.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/mercy/mercy_collection_header.dart';

class MercyCollectionView extends StatefulWidget {
  const MercyCollectionView({super.key, required this.kind});

  final MercyCollectionKind kind;

  @override
  State<MercyCollectionView> createState() => _MercyCollectionViewState();
}

class _MercyCollectionViewState extends State<MercyCollectionView> {
  late Future<MercyCollection> _collection;

  @override
  void initState() {
    super.initState();
    _collection = MercyCollectionLoader().load(widget.kind);
  }

  void _retry() {
    setState(() {
      _collection = MercyCollectionLoader().load(widget.kind);
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final settings = context.watch<SettingsViewModel>();
    final colors = AppThemeColors.light;
    final accent = widget.kind == MercyCollectionKind.hadith
        ? colors.coral
        : colors.violet;
    final title = widget.kind == MercyCollectionKind.hadith
        ? context.l10n.dashboardMercyHadithTitle
        : context.l10n.dashboardMercyStoriesTitle;

    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  responsive.padding,
                  AppSpacing.md,
                  responsive.padding,
                  AppSpacing.xs,
                ),
                child: _MercyReaderTopBar(
                  title: title,
                  accent: accent,
                  icon: widget.kind == MercyCollectionKind.hadith
                      ? Icons.favorite_rounded
                      : Icons.auto_stories_rounded,
                  language: settings.settings.language,
                  onLanguageSelected: settings.setLanguage,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: AppPageScrollbar(
                  builder: (context, controller) => SingleChildScrollView(
                    controller: controller,
                    padding: EdgeInsets.fromLTRB(
                      responsive.padding,
                      0,
                      responsive.padding,
                      AppSpacing.huge,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: FutureBuilder<MercyCollection>(
                          future: _collection,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const MercyCollectionLoading();
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return MercyCollectionError(onRetry: _retry);
                            }
                            return MercyCollectionContent(
                              collection: snapshot.data!,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MercyCollectionLoading extends StatelessWidget {
  const MercyCollectionLoading({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.huge),
    child: Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
}

class MercyCollectionError extends StatelessWidget {
  const MercyCollectionError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Icon(Icons.auto_awesome_rounded, size: 38, color: scheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.mercyLoadError,
              textAlign: TextAlign.center,
              style: AppTheme.text(
                context,
              ).bodyLarge.copyWith(fontWeight: AppTheme.weightSemiBold),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.mercyRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _MercyReaderTopBar extends StatelessWidget {
  const _MercyReaderTopBar({
    required this.title,
    required this.accent,
    required this.icon,
    required this.language,
    required this.onLanguageSelected,
  });

  final String title;
  final Color accent;
  final IconData icon;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            style: IconButton.styleFrom(
              backgroundColor: accent.withValues(alpha: 0.12),
              foregroundColor: accent,
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, Color.lerp(accent, scheme.primary, 0.42)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Padding(
              padding: EdgeInsets.all(9),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashboardMercyTitle.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(context).labelSmall.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightExtraBold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: AppLanguageActionButton(
              current: language,
              onSelected: onLanguageSelected,
              tooltip: context.l10n.settingsLanguagePanelTitle,
              iconColor: accent,
              iconSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}

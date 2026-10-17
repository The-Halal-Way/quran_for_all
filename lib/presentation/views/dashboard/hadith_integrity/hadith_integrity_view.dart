import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/datasources/local/hadith_integrity_pack_loader.dart';
import '../../../../data/models/hadith_integrity/hadith_integrity_library.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dashboard/hadith_integrity/hadith_integrity_collection_card.dart';
import '../../../widgets/dashboard/hadith_integrity/hadith_integrity_hero.dart';
import '../../../widgets/dashboard/hadith_integrity/hadith_integrity_status_card.dart';

class HadithIntegrityView extends StatefulWidget {
  const HadithIntegrityView({super.key});

  @override
  State<HadithIntegrityView> createState() => _HadithIntegrityViewState();
}

class _HadithIntegrityViewState extends State<HadithIntegrityView> {
  final _loader = HadithIntegrityPackLoader();
  late Future<HadithIntegrityLibrary> _library;

  @override
  void initState() {
    super.initState();
    // Asset reads begin only after this route is opened from the dashboard.
    _library = _loader.loadLibrary();
  }

  void _retry() {
    setState(() => _library = _loader.loadLibrary());
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: Column(
            children: [
              _IntegrityTopBar(onBack: () => Navigator.of(context).maybePop()),
              Expanded(
                child: AppPageScrollbar(
                  builder: (context, controller) => SingleChildScrollView(
                    controller: controller,
                    padding: EdgeInsets.fromLTRB(
                      responsive.padding,
                      AppSpacing.md,
                      responsive.padding,
                      AppSpacing.huge,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: FutureBuilder<HadithIntegrityLibrary>(
                          future: _library,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return _IntegrityLoading();
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return _IntegrityError(onRetry: _retry);
                            }
                            return _IntegrityContent(library: snapshot.data!);
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

class _IntegrityTopBar extends StatelessWidget {
  const _IntegrityTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = AppThemeColors.light.cyan;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.of(context).padding,
        AppSpacing.md,
        AppResponsive.of(context).padding,
        AppSpacing.xs,
      ),
      child: Material(
        color: scheme.surface.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                style: IconButton.styleFrom(
                  backgroundColor: accent.withValues(alpha: .12),
                  foregroundColor: accent,
                ),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.fact_check_rounded, color: accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.hadithIntegritySectionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.text(
                    context,
                  ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntegrityContent extends StatelessWidget {
  const _IntegrityContent({required this.library});

  final HadithIntegrityLibrary library;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.light;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HadithIntegrityHero(),
        const SizedBox(height: AppSpacing.lg),
        _EditorialNote(),
        const SizedBox(height: AppSpacing.xxl),
        _IntegrityHeading(
          title: l10n.hadithIntegrityPopularLabel,
          icon: Icons.fact_check_rounded,
          accent: colors.cyan,
        ),
        const SizedBox(height: AppSpacing.md),
        for (
          var index = 0;
          index < library.popularNarrations.length;
          index++
        ) ...[
          HadithIntegrityCollectionCard(
            collection: library.popularNarrations[index],
            accent: index.isEven ? colors.cyan : colors.violet,
            kicker: l10n.hadithIntegrityPartLabel('${index + 1}'),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        _IntegrityHeading(
          title: l10n.hadithIntegrityResourcesLabel,
          icon: Icons.library_books_rounded,
          accent: colors.violet,
        ),
        const SizedBox(height: AppSpacing.md),
        HadithIntegrityCollectionCard(
          collection: library.verificationGuide,
          accent: colors.cyan,
          kicker: l10n.hadithIntegrityGuideLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        HadithIntegrityStatusCard(
          collection: library.statusExplained,
          accent: colors.violet,
        ),
        const SizedBox(height: AppSpacing.md),
        HadithIntegrityCollectionCard(
          collection: library.misconceptions,
          accent: colors.coral,
          kicker: l10n.hadithIntegrityMisconceptionLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        HadithIntegrityCollectionCard(
          collection: library.authenticWarnings,
          accent: colors.danger,
          kicker: l10n.hadithIntegrityWarningsLabel,
        ),
      ],
    );
  }
}

class _IntegrityHeading extends StatelessWidget {
  const _IntegrityHeading({
    required this.title,
    required this.icon,
    required this.accent,
  });

  final String title;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: accent, size: 18),
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Text(
        title,
        style: AppTheme.text(
          context,
        ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(child: Divider(color: accent.withValues(alpha: .22))),
    ],
  );
}

class _EditorialNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = AppThemeColors.light.warning;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: .2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.hadithIntegrityEditorialNote,
              style: AppTheme.text(context).bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntegrityLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.huge),
    child: Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.hadithIntegrityLoading),
      ],
    ),
  );
}

class _IntegrityError extends StatelessWidget {
  const _IntegrityError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 42,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.hadithIntegrityError,
            textAlign: TextAlign.center,
            style: AppTheme.text(
              context,
            ).bodyLarge.copyWith(fontWeight: AppTheme.weightSemiBold),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.hadithIntegrityRetry),
          ),
        ],
      ),
    ),
  );
}

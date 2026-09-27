import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enums/app_language.dart';
import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/localization/surah_name_localizer.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/surah_model.dart';

class SurahDetailsLoading extends StatelessWidget {
  const SurahDetailsLoading({
    super.key,
    required this.surah,
    required this.language,
  });

  final SurahModel surah;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: const Icon(CupertinoIcons.chevron_back),
                ),
                Expanded(
                  child: Text(
                    surah.localizedTitle(context, language),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text(
                      context,
                    ).titleLarge.copyWith(fontWeight: AppTheme.weightBold),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: scheme.primary),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            context.l10n.readQuranOpeningSurahTitle,
                            style: AppTheme.text(context).titleMedium.copyWith(
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.l10n.readQuranOpeningSurahBody,
                            textAlign: TextAlign.center,
                            style: AppTheme.text(context).bodyMedium.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

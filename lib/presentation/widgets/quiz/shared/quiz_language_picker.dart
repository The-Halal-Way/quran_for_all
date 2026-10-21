import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/quiz/quiz_config.dart';

class QuizLanguagePicker extends StatelessWidget {
  const QuizLanguagePicker({
    super.key,
    required this.config,
    required this.language,
    required this.onChanged,
  });
  final QuizConfig config;
  final String language;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate_rounded, size: 20, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.quizLanguage,
                  style: AppTheme.text(
                    context,
                  ).labelLarge.copyWith(fontWeight: AppTheme.weightBold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.quizLanguageBeforeStart,
            style: AppTheme.text(context).bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final code in config.languages)
                ChoiceChip(
                  label: Text(config.languageName(code)),
                  selected: code == language,
                  onSelected: onChanged == null
                      ? null
                      : (_) => onChanged!(code),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

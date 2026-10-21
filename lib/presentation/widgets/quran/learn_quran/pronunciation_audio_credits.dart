import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/quran/recorded_pronunciation_catalog.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';

class PronunciationAudioCredits extends StatelessWidget {
  const PronunciationAudioCredits({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton.icon(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxWidth: AppResponsive.of(context).maxSheetWidth,
            maxHeight: MediaQuery.sizeOf(context).height * .8,
          ),
          builder: (_) => const _AudioCreditsSheet(),
        ),
        icon: const Icon(Icons.headphones_rounded, size: 17),
        label: Text(context.l10n.learnPronunciationRecordings),
      ),
    );
  }
}

class _AudioCreditsSheet extends StatelessWidget {
  const _AudioCreditsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          0,
          AppSpacing.xxl,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.learnPronunciationRecordings, style: text.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.learnPronunciationRecordingsDescription,
              style: text.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(RecordedPronunciationCatalog.author, style: text.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.learnPronunciationRecordingsCredit,
              style: text.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () =>
                      _open(context, RecordedPronunciationCatalog.sourceUrl),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: Text(l10n.learnPronunciationSource),
                ),
                TextButton(
                  onPressed: () =>
                      _open(context, RecordedPronunciationCatalog.licenseUrl),
                  child: Text(l10n.learnPronunciationLicense),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, String url) async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      // The localized message below also covers devices without a browser.
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.settingsLegalLinkFailed)),
      );
    }
  }
}

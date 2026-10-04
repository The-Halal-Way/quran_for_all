import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_legal_links.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import 'settings_action_card.dart';
import 'settings_section_heading.dart';

class SettingsLegalPanel extends StatelessWidget {
  const SettingsLegalPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeading(
          eyebrow: l10n.settingsLegalEyebrow,
          title: l10n.settingsLegalTitle,
          accent: scheme.tertiary,
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsActionCard(
          icon: Icons.support_agent_rounded,
          title: l10n.settingsSupportTitle,
          subtitle: l10n.settingsSupportSubtitle,
          accent: scheme.tertiary,
          onTap: () => _openLink(context, AppLegalLinks.support),
        ),
        const SizedBox(height: AppSpacing.md),
        SettingsActionCard(
          icon: Icons.shield_outlined,
          title: l10n.settingsPrivacyPolicyTitle,
          subtitle: l10n.settingsPrivacyPolicySubtitle,
          accent: scheme.secondary,
          onTap: () => _openLink(context, AppLegalLinks.privacyPolicy),
        ),
        const SizedBox(height: AppSpacing.md),
        SettingsActionCard(
          icon: Icons.gavel_rounded,
          title: l10n.settingsTermsTitle,
          subtitle: l10n.settingsTermsSubtitle,
          accent: scheme.primary,
          onTap: () => _openLink(context, AppLegalLinks.termsAndConditions),
        ),
      ],
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    if (url.trim().isEmpty) {
      _showMessage(context, context.l10n.settingsLegalLinkPending);
      return;
    }

    try {
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        _showMessage(context, context.l10n.settingsLegalLinkFailed);
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, context.l10n.settingsLegalLinkFailed);
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

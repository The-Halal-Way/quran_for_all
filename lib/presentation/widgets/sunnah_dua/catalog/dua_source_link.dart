import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';

class DuaSourceLink extends StatelessWidget {
  const DuaSourceLink({super.key, required this.label, required this.url});
  final String label, url;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: () async {
      final uri = Uri.tryParse(url);
      var opened = false;
      try {
        if (uri != null &&
            uri.host.isNotEmpty &&
            const {'http', 'https'}.contains(uri.scheme)) {
          opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (_) {
        /* The failure is reported below. */
      }
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.settingsLegalLinkFailed)),
        );
      }
    },
    icon: const Icon(Icons.open_in_new_rounded, size: 16),
    label: Text(label),
  );
}

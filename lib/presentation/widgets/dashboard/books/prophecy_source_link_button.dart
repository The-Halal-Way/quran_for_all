import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class ProphecySourceLinkButton extends StatelessWidget {
  const ProphecySourceLinkButton({super.key, required this.url, this.color});

  final String url;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = color ?? Theme.of(context).colorScheme.primary;
    return FilledButton.tonalIcon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.open_in_new_rounded, size: 16),
      label: Text(context.l10n.propheciesOpenSource),
      style: FilledButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: foregroundColor.withValues(alpha: 0.1),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        textStyle: AppTheme.text(
          context,
        ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.tryParse(url);
    final validUri =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
    var opened = false;
    if (validUri) {
      try {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.propheciesOpenSourceFailed)),
      );
    }
  }
}

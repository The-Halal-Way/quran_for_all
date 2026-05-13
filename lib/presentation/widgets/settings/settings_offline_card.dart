import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';

class SettingsOfflineCard extends StatelessWidget {
  const SettingsOfflineCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric( vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary.withValues(alpha: 0.25),
            colorScheme.tertiary.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.offline_bolt_rounded),
        title: Text(context.readQuranText('Offline mode is enabled')),
        subtitle: Text(
          context.readQuranText(
            'Quran text, translations, and tafsir are stored locally after setup. Audio is cached after first play.',
          ),
        ),
      ),
    );
  }
}

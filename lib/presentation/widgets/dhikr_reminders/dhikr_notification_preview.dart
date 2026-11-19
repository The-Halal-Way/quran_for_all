import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../services/dhikr_reminders/dhikr_sound_preview.dart';
import 'dhikr_sound_preview_button.dart';

class DhikrNotificationPreview extends StatelessWidget {
  const DhikrNotificationPreview({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sound,
    required this.preview,
  });
  final String title, subtitle;
  final DhikrReminderSound sound;
  final DhikrSoundPreview preview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.dhikrNotificationPreview,
                style: text.labelLarge,
              ),
            ),
            DhikrSoundPreviewButton(preview: preview, sound: sound),
          ],
        ),
        Container(
          key: const ValueKey('dhikr-notification-preview'),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: scheme.primary.withValues(alpha: .16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      size: 15,
                      color: scheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.appName,
                      style: text.labelSmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.dhikrPreviewNow,
                    style: text.labelSmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title.trim().isEmpty ? l10n.dhikrCustomTitleHint : title.trim(),
                key: const ValueKey('dhikr-preview-title'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.titleSmall.copyWith(
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              if (subtitle.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle.trim(),
                  key: const ValueKey('dhikr-preview-subtitle'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.dhikrPreviewAppearance,
          style: text.labelSmall.copyWith(color: scheme.onSurfaceVariant),
        ),
        AnimatedBuilder(
          animation: preview,
          builder: (context, _) => preview.failed
              ? Text(
                  l10n.dhikrPreviewFailed,
                  style: text.bodySmall.copyWith(color: scheme.error),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

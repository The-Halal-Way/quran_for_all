import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';
import 'powerful_duah_data.dart';
import 'powerful_duah_metadata_chip.dart';
import 'powerful_duah_text_panel.dart';

class PowerfulDuahDetailSheet extends StatefulWidget {
  const PowerfulDuahDetailSheet({super.key, required this.duah});

  final PowerfulDuah duah;

  @override
  State<PowerfulDuahDetailSheet> createState() =>
      _PowerfulDuahDetailSheetState();
}

class _PowerfulDuahDetailSheetState extends State<PowerfulDuahDetailSheet> {
  bool _copied = false;

  Future<void> _copy() async {
    final duah = widget.duah;
    await Clipboard.setData(
      ClipboardData(
        text:
            '${duah.arabic}\n${duah.localizedPronunciation(context)}\n${duah.localizedTranslation(context)}',
      ),
    );
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final duah = widget.duah;
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.80,
      minChildSize: 0.44,
      maxChildSize: 0.95,
      builder: (context, controller) => DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: MyColors.secondary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${duah.number}',
                    style: text.labelMedium.copyWith(
                      color: MyColors.secondary,
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    duah.localizedTitle(context),
                    style: text.titleLarge.copyWith(
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                  onPressed: _copy,
                  icon: Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 19,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColors.primary.withValues(alpha: 0.07),
                    MyColors.secondary.withValues(alpha: 0.045),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: MyColors.primaryLight.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                duah.arabic,
                textAlign: TextAlign.right,
                textDirection: ui.TextDirection.rtl,
                style: text.headlineMedium.copyWith(height: 1.85),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PowerfulDuahTextPanel(
              accent: MyColors.primaryLight,
              child: Text(
                duah.localizedPronunciation(context),
                style: text.bodyMedium.copyWith(
                  height: 1.55,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PowerfulDuahTextPanel(
              accent: MyColors.tertiary,
              child: Text(
                duah.localizedTranslation(context),
                style: text.bodyLarge.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (duah.source != null)
                  PowerfulDuahMetadataChip(
                    icon: Icons.verified_outlined,
                    label: duah.source!,
                    color: MyColors.tertiary,
                  ),
                for (final situation in duah.situations)
                  if (situation != DuahSituation.all)
                    PowerfulDuahMetadataChip(
                      icon: situation.icon,
                      label: situation.label(context),
                      color: situation.color,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

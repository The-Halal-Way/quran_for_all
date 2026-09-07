import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/models/sunnah_dua_item.dart';

class SunnahDuaDetailHeader extends StatelessWidget {
  const SunnahDuaDetailHeader({
    super.key,
    required this.item,
    required this.kindLabel,
  });

  final SunnahDuaItem item;
  final String kindLabel;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(item.icon, color: Colors.white, size: 21),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kindLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontWeight: AppTheme.weightBlack,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: text.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.weightBlack,
                        height: 1.08,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            item.subtitle,
            style: text.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: AppTheme.weightSemiBold,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Text(
              '${context.l10n.sunnahDuaSourceLabel}: ${item.source}',
              style: text.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.weightBold,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

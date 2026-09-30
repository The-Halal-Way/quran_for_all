import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/app_theme_colors.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class CompassTopBar extends StatelessWidget {
  const CompassTopBar({
    super.key,
    required this.isDark,
    required this.directionLabel,
  });

  final bool isDark;
  final String directionLabel;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(CupertinoIcons.chevron_back, color: textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.compassTitle,
                  style: text.compassTitle.copyWith(color: textPrimary),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? MyColors.tertiaryLight
                            : AppThemeColors.light.cyan,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        directionLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.compassSubtitle.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

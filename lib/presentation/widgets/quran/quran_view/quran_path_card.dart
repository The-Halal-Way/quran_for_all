import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/quran/quran_hub_models.dart';
import 'quran_path_arrow.dart';
import 'quran_path_halo.dart';
import 'quran_path_icon.dart';

class QuranPathCard extends StatelessWidget {
  const QuranPathCard({super.key, required this.action, required this.onTap});

  final QuranHubAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${action.title}. ${action.detail}',
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shadowColor: MyColors.primaryDark.withValues(alpha: 0.26),
        surfaceTintColor: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: LinearGradient(
                colors: [
                  MyColors.primaryDark,
                  action.secondaryAccent,
                  action.accent,
                ],
                stops: const [0, 0.66, 1],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -28,
                  top: -34,
                  child: QuranPathHalo(color: action.accent),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuranPathIcon(action: action),
                          const QuranPathArrow(),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        action.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.weightExtraBold,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      SizedBox(
                        height: 34,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            action.detail,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 3,
                        child: action.progress == null
                            ? null
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                                child: LinearProgressIndicator(
                                  value: action.progress!.clamp(0, 1),
                                  minHeight: 3,
                                  color: Colors.white,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

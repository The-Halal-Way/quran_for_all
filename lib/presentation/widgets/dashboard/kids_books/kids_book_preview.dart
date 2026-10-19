import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../views/dashboard/kids_books/kids_books_library_view.dart';
import 'kids_book_cover_stage.dart';
import 'kids_book_kind.dart';

class KidsBookPreview extends StatelessWidget {
  const KidsBookPreview({super.key, required this.kind});

  final KidsBookKind kind;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark
        ? Color.lerp(kind.accent, Colors.white, .35)!
        : kind.accent;
    final radius = BorderRadius.circular(AppRadius.xl);
    return Material(
      color: Color.alphaBlend(
        kind.accent.withValues(alpha: .06),
        scheme.surface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: accent.withValues(alpha: .24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: radius,
        onTap: () => Navigator.of(context).push(
          AppPageRoute<void>(
            builder: (_) => KidsBooksLibraryView(initialBook: kind),
          ),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              end: -32,
              bottom: -58,
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: .07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  KidsBookCoverStage(
                    image: kind.book.documents.first.previewImage,
                    accent: accent,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kind.title(context),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).titleSmall.copyWith(
                            fontWeight: AppTheme.weightExtraBold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.l10n.kidsBooksLanguages,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.text(context).labelSmall
                                    .copyWith(
                                      color: accent,
                                      fontWeight: AppTheme.weightBold,
                                    ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 17,
                              color: accent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

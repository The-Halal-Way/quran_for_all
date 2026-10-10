import 'package:flutter/material.dart';

import '../../../../core/constants/nurani_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import 'nurani_quran_edition_option.dart';

Future<NuraniQuranDocument?> showNuraniQuranEditionSheet(
  BuildContext context, {
  NuraniQuranDocument? initialDocument,
}) => showModalBottomSheet<NuraniQuranDocument>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  constraints: BoxConstraints(
    maxWidth: AppResponsive.of(context).maxSheetWidth,
  ),
  builder: (_) => NuraniQuranEditionSheet(initialDocument: initialDocument),
);

class NuraniQuranEditionSheet extends StatefulWidget {
  const NuraniQuranEditionSheet({super.key, this.initialDocument});

  final NuraniQuranDocument? initialDocument;

  @override
  State<NuraniQuranEditionSheet> createState() =>
      _NuraniQuranEditionSheetState();
}

class _NuraniQuranEditionSheetState extends State<NuraniQuranEditionSheet> {
  late NuraniQuranDocument? _selected = widget.initialDocument;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.nuraniQuranChooseEdition,
                      style: text.titleLarge.copyWith(
                        fontWeight: AppTheme.weightExtraBold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.nuraniQuranEditionsDescription, style: text.bodyMedium),
              const SizedBox(height: AppSpacing.xl),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stacked =
                      constraints.maxWidth < 320 ||
                      MediaQuery.textScalerOf(context).scale(14) > 20;
                  final spacing = stacked ? AppSpacing.lg : AppSpacing.md;
                  final width = stacked
                      ? constraints.maxWidth
                      : (constraints.maxWidth - spacing) / 2;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final document in NuraniQuranDocument.editions)
                        SizedBox(
                          width: width,
                          child: NuraniQuranEditionOption(
                            document: document,
                            selected: document == _selected,
                            onSelected: () =>
                                setState(() => _selected = document),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.of(context).pop(_selected),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(l10n.nuraniQuranDownload),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

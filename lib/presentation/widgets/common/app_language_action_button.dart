import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/enums/app_language.dart';
import '../../../core/localization/l10n_extensions.dart';

class AppLanguageActionButton extends StatelessWidget {
  const AppLanguageActionButton({
    super.key,
    required this.current,
    required this.onSelected,
    required this.tooltip,
    this.iconColor,
    this.iconSize = 21,
  });

  final AppLanguage current;
  final ValueChanged<AppLanguage> onSelected;
  final String tooltip;
  final Color? iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: () => _showLanguageSheet(context),
    icon: Icon(CupertinoIcons.globe, color: iconColor, size: iconSize),
  );

  Future<void> _showLanguageSheet(BuildContext context) async {
    final selected = await showCupertinoModalPopup<AppLanguage>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(tooltip),
        actions: [
          for (final language in AppLanguage.values)
            CupertinoActionSheetAction(
              isDefaultAction: current == language,
              onPressed: () => Navigator.pop(sheetContext, language),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.appLanguageLabel(language)),
                  if (current == language) ...[
                    const SizedBox(width: 8),
                    const Icon(CupertinoIcons.check_mark, size: 18),
                  ],
                ],
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ),
    );
    if (selected != null) onSelected(selected);
  }
}

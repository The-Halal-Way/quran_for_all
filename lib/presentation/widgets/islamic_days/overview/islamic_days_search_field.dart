import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

class IslamicDaysSearchField extends StatelessWidget {
  const IslamicDaysSearchField({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: context.l10n.islamicDaysSearch,
      prefixIcon: const Icon(Icons.search_rounded),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanGuideSearch extends StatelessWidget {
  const RamadanGuideSearch({
    super.key,
    required this.isBangla,
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final bool isBangla;
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => TextField(
    key: const ValueKey('ramadan_search'),
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: ramadanLabel(
        isBangla,
        'Search fasting, prayer, women, Eid…',
        'রোজা, নামাজ, নারী, ঈদ খুঁজুন…',
      ),
      prefixIcon: const Icon(CupertinoIcons.search),
      suffixIcon: query.isEmpty
          ? null
          : IconButton(
              tooltip: ramadanLabel(isBangla, 'Clear search', 'খোঁজা মুছুন'),
              onPressed: onClear,
              icon: const Icon(CupertinoIcons.clear_circled),
            ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  );
}

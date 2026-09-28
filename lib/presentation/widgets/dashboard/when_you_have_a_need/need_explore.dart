import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/dashboard/need_amal_progress_viewmodel.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal_detail_view.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amals.dart';
import 'need_amal_card.dart';
import 'need_category_picker.dart';

class NeedExplore extends StatefulWidget {
  const NeedExplore({
    super.key,
    required this.isBangla,
    required this.progress,
    this.initialCategory,
  });

  final bool isBangla;
  final NeedAmalProgressViewModel progress;
  final NeedCategory? initialCategory;

  @override
  State<NeedExplore> createState() => _NeedExploreState();
}

class _NeedExploreState extends State<NeedExplore> {
  NeedCategory? _category;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  void _open(NeedAmal amal, NeedDetailFocus focus) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => ChangeNotifierProvider.value(
          value: widget.progress,
          child: NeedAmalDetailView(amal: amal, initialFocus: focus),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bn = widget.isBangla;
    final scheme = Theme.of(context).colorScheme;
    final query = _query.trim().toLowerCase();
    final visible = needAmals
        .where((amal) {
          if (_category != null && amal.category != _category) return false;
          if (query.isEmpty) return true;
          return [
            amal.title.en,
            amal.title.bn,
            amal.description.en,
            amal.description.bn,
            ...amal.steps.expand((step) => [step.en, step.bn]),
          ].any((value) => value.toLowerCase().contains(query));
        })
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          bn ? 'আপনার জন্য আমলসমূহ' : 'Explore the practices',
          style: AppTheme.text(
            context,
          ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          bn
              ? 'প্রতিটি আমলে পদ্ধতি, দোয়া, সময় ও প্রমাণের মান দেখুন।'
              : 'Open each practice for its method, dua, timing, and evidence.',
          style: AppTheme.text(
            context,
          ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          key: const ValueKey('need_search'),
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: bn
                ? 'তাহাজ্জুদ, ক্ষমা, দান খুঁজুন…'
                : 'Search prayer, forgiveness, charity…',
            prefixIcon: const Icon(CupertinoIcons.search),
            filled: true,
            fillColor: scheme.surface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        NeedCategoryPicker(
          isBangla: bn,
          selected: _category,
          onSelected: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(bn ? 'কোনো আমল পাওয়া যায়নি।' : 'No practices found.'),
          )
        else
          for (final amal in visible)
            NeedAmalCard(
              key: ValueKey('need_card_${amal.id}'),
              amal: amal,
              isBangla: bn,
              onOpenMethod: () => _open(amal, NeedDetailFocus.method),
              onOpenDua: () => _open(amal, NeedDetailFocus.dua),
            ),
      ],
    );
  }
}

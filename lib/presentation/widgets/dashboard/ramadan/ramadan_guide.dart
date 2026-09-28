import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../views/dashboard/ramadan/ramadan_content.dart';
import 'ramadan_category_picker.dart';
import 'ramadan_guide_search.dart';
import 'ramadan_overview.dart';
import 'ramadan_section_heading.dart';
import 'ramadan_topic_list.dart';

class RamadanGuide extends StatefulWidget {
  const RamadanGuide({super.key, required this.isBangla});

  final bool isBangla;

  @override
  State<RamadanGuide> createState() => _RamadanGuideState();
}

class _RamadanGuideState extends State<RamadanGuide> {
  final _searchController = TextEditingController();
  final _headingKey = GlobalKey();
  RamadanSection? _selectedSection;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectSection(RamadanSection? section) {
    setState(() {
      _selectedSection = section;
      _searchController.clear();
      _query = '';
    });
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final headingContext = _headingKey.currentContext;
      if (mounted && headingContext != null) {
        Scrollable.ensureVisible(
          headingContext,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  bool _matches(RamadanTopic topic, String query) => [
    topic.title.en,
    topic.title.bn,
    topic.summary.en,
    topic.summary.bn,
    ...topic.points.expand((point) => [point.en, point.bn]),
  ].any((value) => value.toLowerCase().contains(query));

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final entries = ramadanTopics
        .asMap()
        .entries
        .where(
          (entry) => query.isNotEmpty
              ? _matches(entry.value, query)
              : entry.value.section == _selectedSection,
        )
        .toList(growable: false);
    final bn = widget.isBangla;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RamadanSectionHeading(
          key: _headingKey,
          icon: Icons.menu_book_outlined,
          title: ramadanLabel(bn, 'Ramadan A to Z', 'রমজান: শুরু থেকে শেষ'),
          subtitle: ramadanLabel(
            bn,
            'Practical guidance for everyone, with dedicated women’s topics and sources to check.',
            'সবার জন্য ব্যবহারিক নির্দেশনা, নারীদের বিশেষ বিষয় ও যাচাই করার সূত্রসহ।',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        RamadanGuideSearch(
          isBangla: bn,
          controller: _searchController,
          query: query,
          onChanged: (value) => setState(() => _query = value),
          onClear: () {
            _searchController.clear();
            setState(() => _query = '');
          },
        ),
        const SizedBox(height: AppSpacing.md),
        RamadanCategoryPicker(
          isBangla: bn,
          selectedSection: _selectedSection,
          onSelected: _selectSection,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (query.isNotEmpty)
          RamadanTopicList(
            isBangla: bn,
            title: ramadanLabel(bn, 'Search results', 'খোঁজার ফল'),
            entries: entries,
          )
        else if (_selectedSection == null)
          RamadanOverview(isBangla: bn, onSelectSection: _selectSection)
        else
          RamadanTopicList(
            isBangla: bn,
            title: _selectedSection!.title.of(bn),
            entries: entries,
          ),
      ],
    );
  }
}

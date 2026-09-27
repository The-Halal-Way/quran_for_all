import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_content.dart';
import '../../common/app_premium_page_background.dart';
import 'eid_guide_hero.dart';
import 'eid_guide_note.dart';
import 'eid_kind_switcher.dart';
import 'eid_section_card.dart';
import 'eid_topic_selector.dart';

class EidPrayerBody extends StatefulWidget {
  const EidPrayerBody({super.key});

  @override
  State<EidPrayerBody> createState() => _EidPrayerBodyState();
}

class _EidPrayerBodyState extends State<EidPrayerBody> {
  final ScrollController _scrollController = ScrollController();
  EidKind _eid = EidKind.fitr;
  EidGuideTopic _topic = EidGuideTopic.overview;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectEid(EidKind eid) {
    if (eid == _eid) return;
    setState(() => _eid = eid);
    _scrollToTop();
  }

  void _selectTopic(EidGuideTopic topic) {
    if (topic == _topic) return;
    setState(() => _topic = topic);
    _scrollToTop();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final responsive = AppResponsive.of(context);
    final sections = sectionsFor(_eid, _topic);

    return AppPremiumPageBackground(
      child: SafeArea(
        top: false,
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              responsive.padding,
              AppSpacing.sm,
              responsive.padding,
              AppSpacing.huge,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: responsive.maxReadingContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bangla ? 'আপনার ঈদ বেছে নিন' : 'CHOOSE YOUR EID',
                      style: AppTheme.text(context).labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: AppTheme.weightExtraBold,
                        letterSpacing: bangla ? 0 : 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    EidKindSwitcher(
                      selected: _eid,
                      bangla: bangla,
                      onSelected: _selectEid,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    EidGuideHero(eid: _eid, bangla: bangla),
                    const SizedBox(height: AppSpacing.xxl),
                    EidTopicSelector(
                      selected: _topic,
                      bangla: bangla,
                      onSelected: _selectTopic,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    for (var i = 0; i < sections.length; i++) ...[
                      EidSectionCard(
                        section: sections[i],
                        index: i,
                        eid: _eid,
                        bangla: bangla,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    EidGuideNote(bangla: bangla),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

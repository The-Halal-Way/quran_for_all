import 'content/eid_day_content.dart';
import 'content/eid_method_content.dart';
import 'content/eid_overview_content.dart';
import 'content/eid_remembrance_content.dart';
import 'eid_prayer_models.dart';

export 'eid_prayer_models.dart';

/// Keeps the selected Eid separate while sharing the prayer method and dhikr.
List<EidSection> sectionsFor(EidKind eid, EidGuideTopic topic) =>
    switch (topic) {
      EidGuideTopic.overview => [
        eid == EidKind.fitr ? eidFitrOverview : eidAdhaOverview,
        eidPreparationSection,
        eidAttendanceSection,
      ],
      EidGuideTopic.prayer => eidPrayerSections,
      EidGuideTopic.dayPlan => [
        eidMorningSection,
        eid == EidKind.fitr ? eidFitrDaySection : eidAdhaDaySection,
        eidAfterSection,
      ],
      EidGuideTopic.remembrance => remembranceSectionsFor(eid),
    };

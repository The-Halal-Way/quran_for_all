import 'dart:ui' show TextDirection;

import 'package:flutter/foundation.dart' show immutable;

@immutable
class LocalCalendarDate implements Comparable<LocalCalendarDate> {
  const LocalCalendarDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  factory LocalCalendarDate.parse(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) throw FormatException('Invalid local date: $value');
    final date = LocalCalendarDate(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
    final verified = DateTime(date.year, date.month, date.day);
    if (verified.year != date.year ||
        verified.month != date.month ||
        verified.day != date.day) {
      throw FormatException('Invalid local date: $value');
    }
    return date;
  }

  factory LocalCalendarDate.fromDateTime(DateTime value) =>
      LocalCalendarDate(value.year, value.month, value.day);

  DateTime toLocalDateTime({int hour = 0, int minute = 0}) =>
      DateTime(year, month, day, hour, minute);

  @override
  int compareTo(LocalCalendarDate other) =>
      toLocalDateTime().compareTo(other.toLocalDateTime());

  bool operator <=(LocalCalendarDate other) => compareTo(other) <= 0;
  bool operator <(LocalCalendarDate other) => compareTo(other) < 0;

  @override
  bool operator ==(Object other) =>
      other is LocalCalendarDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

@immutable
class DailyReminderPack {
  const DailyReminderPack({
    required this.packId,
    required this.revision,
    required this.defaultLocale,
    required this.supportedLocales,
    required this.reviewStatus,
    required this.sources,
    required this.passages,
    required this.assets,
    required this.items,
    required this.schedule,
    required this.retentionPolicy,
    this.unavailableItemIds = const <String>{},
  });

  final String packId;
  final int revision;
  final String defaultLocale;
  final List<String> supportedLocales;
  final String reviewStatus;
  final Map<String, DailyReminderSource> sources;
  final Map<String, DailyReminderPassage> passages;
  final Map<String, DailyReminderAsset> assets;
  final List<DailyReminderItem> items;
  final List<DailyReminderSchedule> schedule;
  final DailyReminderRetentionPolicy retentionPolicy;
  final Set<String> unavailableItemIds;

  DailyReminderItem? itemById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  DailyReminderSchedule? scheduleForContent(String id) {
    for (final entry in schedule) {
      if (entry.contentId == id) return entry;
    }
    return null;
  }
}

@immutable
class DailyReminderSource {
  const DailyReminderSource({
    required this.id,
    required this.type,
    required this.displayName,
    required this.url,
    this.surah,
    this.verseStart,
    this.verseEnd,
    this.collection,
    this.referenceNumber,
    this.numberingEdition,
    this.grading,
  });

  final String id;
  final String type;
  final String displayName;
  final String url;
  final int? surah;
  final int? verseStart;
  final int? verseEnd;
  final String? collection;
  final String? referenceNumber;
  final String? numberingEdition;
  final String? grading;

  bool get hasExactOfflineQuranMapping =>
      type == 'quran' &&
      surah != null &&
      verseStart != null &&
      verseEnd != null &&
      verseStart! <= verseEnd!;
}

@immutable
class DailyReminderPassage {
  const DailyReminderPassage({
    required this.id,
    required this.language,
    required this.direction,
    required this.text,
    required this.isExcerpt,
    required this.sourceIds,
  });

  final String id;
  final String language;
  final TextDirection direction;
  final String text;
  final bool isExcerpt;
  final List<String> sourceIds;
}

@immutable
class DailyReminderAsset {
  const DailyReminderAsset({
    required this.id,
    required this.mimeType,
    this.bundledAssetPath,
    this.remoteUrl,
  });

  final String id;
  final String mimeType;
  final String? bundledAssetPath;
  final String? remoteUrl;
}

@immutable
class DailyReminderItem {
  const DailyReminderItem({
    required this.id,
    required this.revision,
    required this.sequence,
    required this.kind,
    required this.tags,
    required this.defaultLocale,
    required this.sourceIds,
    required this.originalPassageIds,
    required this.editions,
    required this.status,
    required this.updatedAt,
    required this.editorialNote,
  });

  final String id;
  final int revision;
  final int sequence;
  final String kind;
  final List<String> tags;
  final String defaultLocale;
  final List<String> sourceIds;
  final List<String> originalPassageIds;
  final Map<String, DailyReminderEdition> editions;
  final String status;
  final DateTime updatedAt;
  final String editorialNote;

  bool get isPublished => status == 'published';

  ResolvedDailyReminderEdition? resolveEdition(
    String locale, {
    bool approvedOnly = false,
  }) {
    final normalized = locale.replaceAll('_', '-').toLowerCase();
    final base = normalized.split('-').first;
    final candidates = <String>[normalized, base, defaultLocale.toLowerCase()];
    for (final key in candidates.toSet()) {
      final edition = editions[key];
      if (edition != null &&
          (!approvedOnly ||
              (edition.reviewStatus == 'approved' &&
                  edition.basedOnRevision == revision))) {
        return ResolvedDailyReminderEdition(
          edition: edition,
          requestedLocale: normalized,
          isFallback: key != normalized && !(normalized == base && key == base),
        );
      }
    }
    return null;
  }

  bool isProductionEligible(String locale) {
    return isPublished && resolveEdition(locale, approvedOnly: true) != null;
  }
}

@immutable
class ResolvedDailyReminderEdition {
  const ResolvedDailyReminderEdition({
    required this.edition,
    required this.requestedLocale,
    required this.isFallback,
  });

  final DailyReminderEdition edition;
  final String requestedLocale;
  final bool isFallback;
}

@immutable
class DailyReminderEdition {
  const DailyReminderEdition({
    required this.locale,
    required this.title,
    required this.summary,
    required this.notification,
    required this.blocks,
    required this.reviewStatus,
    required this.basedOnRevision,
  });

  final String locale;
  final String title;
  final String summary;
  final DailyReminderNotificationCopy notification;
  final List<DailyReminderBlock> blocks;
  final String reviewStatus;
  final int basedOnRevision;
}

@immutable
class DailyReminderNotificationCopy {
  const DailyReminderNotificationCopy({
    required this.title,
    required this.body,
    this.imageAssetId,
  });

  final String title;
  final String body;
  final String? imageAssetId;
}

enum DailyReminderBlockType {
  paragraph,
  heading,
  originalPassage,
  translation,
  transliteration,
  image,
  audio,
  list,
  callout,
  action,
  divider,
}

@immutable
class DailyReminderBlock {
  const DailyReminderBlock({
    required this.id,
    required this.type,
    required this.required,
    this.role,
    this.language,
    this.direction = TextDirection.ltr,
    this.text,
    this.label,
    this.style,
    this.actionType,
    this.targetId,
    this.value,
    this.passageId,
    this.assetId,
    this.sourceIds = const [],
    this.items = const [],
    this.ordered = false,
    this.level,
    this.translator,
    this.scheme,
    this.altText,
    this.caption,
    this.transcript,
  });

  final String id;
  final DailyReminderBlockType type;
  final bool required;
  final String? role;
  final String? language;
  final TextDirection direction;
  final String? text;
  final String? label;
  final String? style;
  final String? actionType;
  final String? targetId;
  final String? value;
  final String? passageId;
  final String? assetId;
  final List<String> sourceIds;
  final List<String> items;
  final bool ordered;
  final int? level;
  final String? translator;
  final String? scheme;
  final String? altText;
  final String? caption;
  final String? transcript;
}

@immutable
class DailyReminderSchedule {
  const DailyReminderSchedule({
    required this.id,
    required this.contentId,
    required this.localDate,
    required this.purpose,
    required this.sendNotification,
  });

  final String id;
  final String contentId;
  final LocalCalendarDate localDate;
  final String purpose;
  final bool sendNotification;
}

@immutable
class DailyReminderRetentionPolicy {
  const DailyReminderRetentionPolicy({
    required this.keepReleasedContent,
    required this.keepReadContent,
    required this.keepUnreadContent,
    required this.hideFutureContent,
    required this.autoDelete,
  });

  final bool keepReleasedContent;
  final bool keepReadContent;
  final bool keepUnreadContent;
  final bool hideFutureContent;
  final bool autoDelete;
}

@immutable
class DailyReminderUserState {
  const DailyReminderUserState({
    this.readAtByContentId = const {},
    this.savedContentIds = const {},
    this.releasedContentIds = const {},
    this.highWaterDate,
  });

  final Map<String, DateTime> readAtByContentId;
  final Set<String> savedContentIds;
  final Set<String> releasedContentIds;
  final LocalCalendarDate? highWaterDate;
}

@immutable
class DailyReminderPreferences {
  const DailyReminderPreferences({
    this.notificationsEnabled = false,
    this.hour = 8,
    this.minute = 0,
    this.enabledKinds = const {
      'quranReflection',
      'hadithReflection',
      'sunnah',
      'akhirahReflection',
    },
  });

  final bool notificationsEnabled;
  final int hour;
  final int minute;
  final Set<String> enabledKinds;

  DailyReminderPreferences copyWith({
    bool? notificationsEnabled,
    int? hour,
    int? minute,
    Set<String>? enabledKinds,
  }) => DailyReminderPreferences(
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    enabledKinds: enabledKinds ?? this.enabledKinds,
  );
}

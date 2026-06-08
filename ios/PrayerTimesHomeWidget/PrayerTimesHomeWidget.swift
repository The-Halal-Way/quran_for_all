import SwiftUI
import WidgetKit

private let prayerWidgetKind = "PrayerTimesHomeWidget"
private let prayerWidgetGroupId = "group.com.example.quranForAll"
private let snapshotKey = "prayer_times_widget_snapshot"

struct PrayerTimesWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> PrayerTimesWidgetEntry {
    PrayerTimesWidgetEntry.placeholder
  }

  func getSnapshot(in context: Context, completion: @escaping (PrayerTimesWidgetEntry) -> Void) {
    completion(loadEntry(referenceDate: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerTimesWidgetEntry>) -> Void) {
    let entry = loadEntry(referenceDate: Date())
    let refreshDate = entry.nextRefreshDate ?? Date().addingTimeInterval(30 * 60)
    completion(Timeline(entries: [entry], policy: .after(refreshDate)))
  }

  private func loadEntry(referenceDate: Date) -> PrayerTimesWidgetEntry {
    let snapshot = PrayerWidgetSnapshot.load()
    let timeZone = snapshot?.resolvedTimeZone ?? .current
    let todayKey = localDateKey(for: referenceDate, timeZone: timeZone)
    let displayDay = snapshot?.days.first(where: { $0.localDateKey == todayKey }) ?? snapshot?.days.first
    let nextPrayer = snapshot?.nextPrayer(after: referenceDate)

    return PrayerTimesWidgetEntry(
      date: referenceDate,
      snapshot: snapshot,
      displayDay: displayDay,
      nextPrayer: nextPrayer,
      timeZone: timeZone,
      nextRefreshDate: nextPrayer?.date.addingTimeInterval(60) ?? nextBoundary(after: referenceDate, timeZone: timeZone)
    )
  }

  private func localDateKey(for date: Date, timeZone: TimeZone) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = timeZone
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  private func nextBoundary(after date: Date, timeZone: TimeZone) -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    return calendar.nextDate(
      after: date,
      matching: DateComponents(hour: 0, minute: 1),
      matchingPolicy: .nextTimePreservingSmallerComponents
    ) ?? date.addingTimeInterval(60 * 60)
  }
}

struct PrayerTimesWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: PrayerWidgetSnapshot?
  let displayDay: PrayerWidgetDaySnapshot?
  let nextPrayer: PrayerMoment?
  let timeZone: TimeZone
  let nextRefreshDate: Date?

  static let placeholder = PrayerTimesWidgetEntry(
    date: Date(),
    snapshot: PrayerWidgetSnapshot.placeholder,
    displayDay: PrayerWidgetSnapshot.placeholder.days.first,
    nextPrayer: PrayerMoment(label: "Maghrib", date: Date().addingTimeInterval(2 * 60 * 60)),
    timeZone: .current,
    nextRefreshDate: Date().addingTimeInterval(30 * 60)
  )
}

struct PrayerTimesHomeWidgetView: View {
  let entry: PrayerTimesWidgetProvider.Entry
  @Environment(\.widgetFamily) private var family

  var body: some View {
    content
      .modifier(PrayerWidgetBackground())
  }

  @ViewBuilder
  private var content: some View {
    if let snapshot = entry.snapshot, let displayDay = entry.displayDay {
      VStack(alignment: .leading, spacing: 12) {
        VStack(alignment: .leading, spacing: 4) {
          Text(snapshot.locationLabel.isEmpty ? "Prayer Times" : snapshot.locationLabel)
            .font(.system(size: 18, weight: .semibold, design: .serif))
            .foregroundColor(.white)
            .lineLimit(1)
          Text(formattedDate(displayDay.localDateKey, timeZone: entry.timeZone))
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color(red: 0.93, green: 0.84, blue: 0.62))
        }

        VStack(alignment: .leading, spacing: 4) {
          Text("Next prayer")
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(Color.white.opacity(0.7))
          HStack(alignment: .firstTextBaseline) {
            Text(entry.nextPrayer?.label ?? "Offline")
              .font(.system(size: 20, weight: .bold, design: .rounded))
              .foregroundColor(.white)
            Spacer(minLength: 8)
            Text(
              entry.nextPrayer.map { formattedTime($0.date, timeZone: entry.timeZone) }
                ?? "Open app"
            )
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(Color(red: 0.98, green: 0.93, blue: 0.83))
          }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.white.opacity(0.08))
        )

        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
          PrayerTimeBadge(label: "Fajr", value: formattedTime(displayDay.fajrDate, timeZone: entry.timeZone))
          PrayerTimeBadge(label: "Sunrise", value: formattedTime(displayDay.sunriseDate, timeZone: entry.timeZone))
          PrayerTimeBadge(label: "Dhuhr", value: formattedTime(displayDay.dhuhrDate, timeZone: entry.timeZone))
          PrayerTimeBadge(label: "Asr", value: formattedTime(displayDay.asrDate, timeZone: entry.timeZone))
          PrayerTimeBadge(label: "Maghrib", value: formattedTime(displayDay.maghribDate, timeZone: entry.timeZone))
          PrayerTimeBadge(label: "Isha", value: formattedTime(displayDay.ishaDate, timeZone: entry.timeZone))
        }

        Spacer(minLength: 0)

        if let lastSync = snapshot.lastSuccessfulSyncDate {
          Text("Synced \(relativeSyncText(from: lastSync))")
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(Color.white.opacity(0.7))
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(18)
    } else {
      VStack(alignment: .leading, spacing: 10) {
        Text("Prayer Times")
          .font(.system(size: 18, weight: .semibold, design: .serif))
          .foregroundColor(.white)
        Text("Open the app once to sync your next 30 days of prayer times for the widget.")
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(Color(red: 0.96, green: 0.91, blue: 0.83))
        Spacer(minLength: 0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(18)
    }
  }

  private var columns: [GridItem] {
    let count = family == .systemLarge ? 3 : 2
    return Array(repeating: GridItem(.flexible(), spacing: 8), count: count)
  }

  private func formattedDate(_ localDateKey: String, timeZone: TimeZone) -> String {
    let parser = DateFormatter()
    parser.calendar = Calendar(identifier: .gregorian)
    parser.locale = Locale(identifier: "en_US_POSIX")
    parser.timeZone = timeZone
    parser.dateFormat = "yyyy-MM-dd"

    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = timeZone
    formatter.dateFormat = "EEE, MMM d"

    guard let date = parser.date(from: localDateKey) else {
      return localDateKey
    }

    return formatter.string(from: date)
  }

  private func formattedTime(_ date: Date, timeZone: TimeZone) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = timeZone
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
  }

  private func relativeSyncText(from date: Date) -> String {
    RelativeDateTimeFormatter().localizedString(for: date, relativeTo: Date())
  }
}

private struct PrayerTimeBadge: View {
  let label: String
  let value: String

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(label)
        .font(.system(size: 11, weight: .semibold))
        .foregroundColor(Color.white.opacity(0.68))
      Text(value)
        .font(.system(size: 13, weight: .bold, design: .rounded))
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(Color.white.opacity(0.06))
    )
  }
}

private struct PrayerWidgetBackground: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      content.containerBackground(for: .widget) {
        PrayerWidgetGradient()
      }
    } else {
      content.background(PrayerWidgetGradient())
    }
  }
}

private struct PrayerWidgetGradient: View {
  var body: some View {
    LinearGradient(
      colors: [
        Color(red: 0.23, green: 0.16, blue: 0.11),
        Color(red: 0.12, green: 0.11, blue: 0.16),
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}

struct PrayerMoment {
  let label: String
  let date: Date
}

struct PrayerWidgetSnapshot: Decodable {
  let timeZoneId: String
  let locationLabel: String
  let lastSuccessfulSyncAtUtcMillis: Int64?
  let days: [PrayerWidgetDaySnapshot]

  static let placeholder = PrayerWidgetSnapshot(
    timeZoneId: TimeZone.current.identifier,
    locationLabel: "Dhaka",
    lastSuccessfulSyncAtUtcMillis: Date().addingTimeInterval(-10 * 60).millisecondsSince1970,
    days: [PrayerWidgetDaySnapshot.placeholder]
  )

  var resolvedTimeZone: TimeZone {
    TimeZone(identifier: timeZoneId) ?? .current
  }

  var lastSuccessfulSyncDate: Date? {
    guard let lastSuccessfulSyncAtUtcMillis else {
      return nil
    }

    return Date(timeIntervalSince1970: TimeInterval(lastSuccessfulSyncAtUtcMillis) / 1000)
  }

  func nextPrayer(after date: Date) -> PrayerMoment? {
    let labels: [(String, (PrayerWidgetDaySnapshot) -> Date)] = [
      ("Fajr", { $0.fajrDate }),
      ("Dhuhr", { $0.dhuhrDate }),
      ("Asr", { $0.asrDate }),
      ("Maghrib", { $0.maghribDate }),
      ("Isha", { $0.ishaDate }),
    ]

    for day in days.sorted(by: { $0.localDateKey < $1.localDateKey }) {
      for (label, value) in labels {
        let prayerDate = value(day)
        if prayerDate > date {
          return PrayerMoment(label: label, date: prayerDate)
        }
      }
    }

    return nil
  }

  static func load() -> PrayerWidgetSnapshot? {
    guard
      let defaults = UserDefaults(suiteName: prayerWidgetGroupId),
      let raw = defaults.string(forKey: snapshotKey),
      let data = raw.data(using: .utf8)
    else {
      return nil
    }

    return try? JSONDecoder().decode(PrayerWidgetSnapshot.self, from: data)
  }
}

struct PrayerWidgetDaySnapshot: Decodable {
  let localDateKey: String
  let fajrUtcMillis: Int64
  let sunriseUtcMillis: Int64
  let dhuhrUtcMillis: Int64
  let asrUtcMillis: Int64
  let maghribUtcMillis: Int64
  let ishaUtcMillis: Int64

  static let placeholder = PrayerWidgetDaySnapshot(
    localDateKey: "2025-01-01",
    fajrUtcMillis: Date().addingTimeInterval(60 * 60).millisecondsSince1970,
    sunriseUtcMillis: Date().addingTimeInterval(2 * 60 * 60).millisecondsSince1970,
    dhuhrUtcMillis: Date().addingTimeInterval(7 * 60 * 60).millisecondsSince1970,
    asrUtcMillis: Date().addingTimeInterval(10 * 60 * 60).millisecondsSince1970,
    maghribUtcMillis: Date().addingTimeInterval(13 * 60 * 60).millisecondsSince1970,
    ishaUtcMillis: Date().addingTimeInterval(15 * 60 * 60).millisecondsSince1970
  )

  var fajrDate: Date { date(fromUtcMillis: fajrUtcMillis) }
  var sunriseDate: Date { date(fromUtcMillis: sunriseUtcMillis) }
  var dhuhrDate: Date { date(fromUtcMillis: dhuhrUtcMillis) }
  var asrDate: Date { date(fromUtcMillis: asrUtcMillis) }
  var maghribDate: Date { date(fromUtcMillis: maghribUtcMillis) }
  var ishaDate: Date { date(fromUtcMillis: ishaUtcMillis) }

  private func date(fromUtcMillis value: Int64) -> Date {
    Date(timeIntervalSince1970: TimeInterval(value) / 1000)
  }
}

private extension Date {
  var millisecondsSince1970: Int64 {
    Int64((timeIntervalSince1970 * 1000).rounded())
  }
}

@main
struct PrayerTimesHomeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: prayerWidgetKind, provider: PrayerTimesWidgetProvider()) { entry in
      PrayerTimesHomeWidgetView(entry: entry)
    }
    .configurationDisplayName("Prayer Times")
    .description("Shows today's cached prayers and the next upcoming salah.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}
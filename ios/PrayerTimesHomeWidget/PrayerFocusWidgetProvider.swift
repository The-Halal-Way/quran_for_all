import Foundation
import WidgetKit

struct PrayerFocusState {
  let statusLabel: String
  let prayerName: String
  let symbolName: String
  let timeRange: String
  let timerLabel: String
  let targetDate: Date
}

struct PrayerFocusWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: PrayerWidgetSnapshot?
  let displayDay: PrayerWidgetDaySnapshot?
  let timeZone: TimeZone
  let focus: PrayerFocusState?

  init(date: Date, snapshot: PrayerWidgetSnapshot?) {
    self.date = date
    self.snapshot = snapshot
    let zone = snapshot?.resolvedTimeZone ?? .current
    self.timeZone = zone
    let key = PrayerWidgetDateFormatter.dateKey(date, timeZone: zone)
    let days = snapshot?.days ?? []
    let idx = days.firstIndex { $0.localDateKey == key }
    let today = idx.map { days[$0] }
    let yesterday = idx.flatMap { $0 > 0 ? days[$0 - 1] : nil }
    let tomorrow = idx.flatMap { $0 + 1 < days.count ? days[$0 + 1] : nil }
    self.displayDay = today
    self.focus = Self.resolveFocus(
      today: today,
      yesterday: yesterday,
      tomorrow: tomorrow,
      at: date,
      timeZone: zone,
      labels: snapshot?.labels ?? .english
    )
  }

  static var placeholder: PrayerFocusWidgetEntry {
    PrayerFocusWidgetEntry(date: Date(), snapshot: .placeholder)
  }

  private static func resolveFocus(
    today: PrayerWidgetDaySnapshot?,
    yesterday: PrayerWidgetDaySnapshot?,
    tomorrow: PrayerWidgetDaySnapshot?,
    at date: Date,
    timeZone: TimeZone,
    labels: PrayerWidgetLabels
  ) -> PrayerFocusState? {
    guard let today else { return nil }
    let nowMillis = Int64(date.timeIntervalSince1970 * 1000)
    let locale = labels.localeIdentifier

    func target(_ millis: Int64) -> Date {
      Date(timeIntervalSince1970: TimeInterval(millis) / 1000)
    }

    if nowMillis < today.fajrUtcMillis {
      let range: String
      if let yesterday {
        range = PrayerWidgetDateFormatter.range(
          yesterday.ishaUtcMillis, end: today.fajrUtcMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        )
      } else {
        range = PrayerWidgetDateFormatter.time(
          today.fajrUtcMillis, timeZone: timeZone, localeIdentifier: locale
        )
      }
      return PrayerFocusState(
        statusLabel: labels.currentPrayerLabel,
        prayerName: labels.isha,
        symbolName: "moon.stars.fill",
        timeRange: range,
        timerLabel: labels.waqtEndsInLabel,
        targetDate: target(today.fajrUtcMillis)
      )
    } else if nowMillis < today.sunriseUtcMillis {
      return PrayerFocusState(
        statusLabel: labels.currentPrayerLabel,
        prayerName: labels.fajr,
        symbolName: "moon.stars.fill",
        timeRange: PrayerWidgetDateFormatter.range(
          today.fajrUtcMillis, end: today.sunriseUtcMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        ),
        timerLabel: labels.waqtEndsInLabel,
        targetDate: target(today.sunriseUtcMillis)
      )
    } else if nowMillis < today.dhuhrUtcMillis {
      return PrayerFocusState(
        statusLabel: labels.nextPrayerLabel,
        prayerName: labels.dhuhr,
        symbolName: "sun.max.fill",
        timeRange: PrayerWidgetDateFormatter.range(
          today.dhuhrUtcMillis, end: today.asrUtcMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        ),
        timerLabel: labels.startsInLabel,
        targetDate: target(today.dhuhrUtcMillis)
      )
    } else if nowMillis < today.asrUtcMillis {
      return PrayerFocusState(
        statusLabel: labels.currentPrayerLabel,
        prayerName: labels.dhuhr,
        symbolName: "sun.max.fill",
        timeRange: PrayerWidgetDateFormatter.range(
          today.dhuhrUtcMillis, end: today.asrUtcMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        ),
        timerLabel: labels.waqtEndsInLabel,
        targetDate: target(today.asrUtcMillis)
      )
    } else if nowMillis < today.maghribUtcMillis {
      return PrayerFocusState(
        statusLabel: labels.currentPrayerLabel,
        prayerName: labels.asr,
        symbolName: "sun.max.fill",
        timeRange: PrayerWidgetDateFormatter.range(
          today.asrUtcMillis, end: today.maghribUtcMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        ),
        timerLabel: labels.waqtEndsInLabel,
        targetDate: target(today.maghribUtcMillis)
      )
    } else if nowMillis < today.ishaUtcMillis {
      return PrayerFocusState(
        statusLabel: labels.currentPrayerLabel,
        prayerName: labels.maghrib,
        symbolName: "sunset.fill",
        timeRange: PrayerWidgetDateFormatter.range(
          today.maghribUtcMillis, end: today.ishaUtcMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        ),
        timerLabel: labels.waqtEndsInLabel,
        targetDate: target(today.ishaUtcMillis)
      )
    } else {
      let endMillis = today.ishaEndUtcMillis
        ?? tomorrow?.fajrUtcMillis
        ?? (today.fajrUtcMillis + 86_400_000)
      return PrayerFocusState(
        statusLabel: labels.currentPrayerLabel,
        prayerName: labels.isha,
        symbolName: "moon.stars.fill",
        timeRange: PrayerWidgetDateFormatter.range(
          today.ishaUtcMillis, end: endMillis,
          timeZone: timeZone, localeIdentifier: locale, compact: false
        ),
        timerLabel: labels.waqtEndsInLabel,
        targetDate: target(endMillis)
      )
    }
  }
}

struct PrayerFocusWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> PrayerFocusWidgetEntry { .placeholder }

  func getSnapshot(in context: Context, completion: @escaping (PrayerFocusWidgetEntry) -> Void) {
    completion(context.isPreview ? .placeholder : PrayerFocusWidgetEntry(date: Date(), snapshot: .load()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerFocusWidgetEntry>) -> Void) {
    let snapshot = PrayerWidgetSnapshot.load()
    let now = Date()
    var dates = Set<Date>([now])

    if let snapshot {
      // Schedule an entry at every prayer boundary over the next 3 days so the
      // active waqt and countdown target transition smoothly in the background.
      for day in snapshot.days.prefix(4) {
        let milestones = [
          day.fajrUtcMillis,
          day.sunriseUtcMillis,
          day.dhuhrUtcMillis,
          day.asrUtcMillis,
          day.maghribUtcMillis,
          day.ishaUtcMillis,
        ]
        for millis in milestones {
          let milestoneDate = Date(timeIntervalSince1970: TimeInterval(millis) / 1000)
          if milestoneDate > now {
            dates.insert(milestoneDate)
          }
        }
      }
    } else {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = .current
      if let nextHour = calendar.date(byAdding: .hour, value: 1, to: now) {
        dates.insert(nextHour)
      }
    }

    let entries = dates.sorted().map { PrayerFocusWidgetEntry(date: $0, snapshot: snapshot) }
    completion(Timeline(entries: entries, policy: .atEnd))
  }
}

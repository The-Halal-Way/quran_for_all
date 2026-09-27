import WidgetKit

struct PrayerTimesWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> PrayerTimesWidgetEntry { .placeholder }

  func getSnapshot(in context: Context, completion: @escaping (PrayerTimesWidgetEntry) -> Void) {
    completion(context.isPreview ? .placeholder : PrayerTimesWidgetEntry(date: Date(), snapshot: .load()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerTimesWidgetEntry>) -> Void) {
    let snapshot = PrayerWidgetSnapshot.load()
    let now = Date()
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = snapshot?.resolvedTimeZone ?? .current
    let midnight = calendar.startOfDay(for: now)
    var entries = [PrayerTimesWidgetEntry(date: now, snapshot: snapshot)]

    // Preload local midnights so the cached 30-day schedule advances offline.
    // Calendar arithmetic also handles daylight-saving changes correctly.
    for offset in 1...30 {
      if let date = calendar.date(byAdding: .day, value: offset, to: midnight) {
        entries.append(PrayerTimesWidgetEntry(date: date, snapshot: snapshot))
      }
    }
    completion(Timeline(entries: entries, policy: .atEnd))
  }
}

struct PrayerTimesWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: PrayerWidgetSnapshot?
  let displayDay: PrayerWidgetDaySnapshot?
  let timeZone: TimeZone

  init(date: Date, snapshot: PrayerWidgetSnapshot?) {
    self.date = date
    self.snapshot = snapshot
    timeZone = snapshot?.resolvedTimeZone ?? .current
    let key = PrayerWidgetDateFormatter.dateKey(date, timeZone: timeZone)
    // Expired data must not be displayed as today's prayer times.
    displayDay = snapshot?.days.first { $0.localDateKey == key }
  }

  static var placeholder: PrayerTimesWidgetEntry {
    PrayerTimesWidgetEntry(date: Date(), snapshot: .placeholder)
  }
}


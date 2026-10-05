import Foundation

struct PrayerWidgetSnapshot: Decodable {
  let timeZoneId: String
  let locationLabel: String
  let days: [PrayerWidgetDaySnapshot]
  let labels: PrayerWidgetLabels

  private enum CodingKeys: String, CodingKey {
    case timeZoneId, locationLabel, days, labels
  }

  init(timeZoneId: String, locationLabel: String, days: [PrayerWidgetDaySnapshot], labels: PrayerWidgetLabels) {
    self.timeZoneId = timeZoneId
    self.locationLabel = locationLabel
    self.days = days
    self.labels = labels
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    timeZoneId = try container.decode(String.self, forKey: .timeZoneId)
    locationLabel = try container.decode(String.self, forKey: .locationLabel)
    days = try container.decode([PrayerWidgetDaySnapshot].self, forKey: .days)
    labels = try container.decodeIfPresent(PrayerWidgetLabels.self, forKey: .labels) ?? .english
  }

  var resolvedTimeZone: TimeZone { TimeZone(identifier: timeZoneId) ?? .current }

  static func load() -> PrayerWidgetSnapshot? {
    guard
      let raw = UserDefaults(suiteName: PrayerWidgetConstants.appGroup)?
        .string(forKey: PrayerWidgetConstants.snapshotKey),
      let data = raw.data(using: .utf8)
    else { return nil }
    return try? JSONDecoder().decode(Self.self, from: data)
  }

  static var placeholder: PrayerWidgetSnapshot {
    PrayerWidgetSnapshot(
      timeZoneId: "Asia/Dhaka", locationLabel: "Dhaka",
      days: [PrayerWidgetDaySnapshot.placeholder], labels: .english
    )
  }
}

struct PrayerWidgetLabels: Codable {
  let localeIdentifier: String
  let appTitle: String
  let hijriDatePlaceholder: String
  let prayerTimes: String
  let sehriEnd: String
  let iftar: String
  let openToSync: String
  let tapToUpdate: String
  let fajr: String
  let sunrise: String
  let dhuhr: String
  let asr: String
  let maghrib: String
  let isha: String

  static let english = PrayerWidgetLabels(
    localeIdentifier: "en_US", appTitle: "Muslim & Quran Pro",
    hijriDatePlaceholder: "Hijri date", prayerTimes: "PRAYER TIMES",
    sehriEnd: "SEHRI END", iftar: "IFTAR",
    openToSync: "Open the app to update today's times", tapToUpdate: "Tap to update",
    fajr: "Fajr", sunrise: "Sunrise", dhuhr: "Dhuhr", asr: "Asr",
    maghrib: "Maghrib", isha: "Isha"
  )
}

struct PrayerWidgetDaySnapshot: Decodable {
  let localDateKey: String
  let fajrUtcMillis: Int64
  let sunriseUtcMillis: Int64
  let dhuhrUtcMillis: Int64
  let asrUtcMillis: Int64
  let maghribUtcMillis: Int64
  let ishaUtcMillis: Int64
  let hijriDateLabel: String?
  let sehriEndUtcMillis: Int64?

  var sehriEnd: Int64 { sehriEndUtcMillis ?? fajrUtcMillis - 10 * 60_000 }

  func prayers(labels: PrayerWidgetLabels) -> [PrayerWidgetTime] {
    [
      PrayerWidgetTime(label: labels.fajr, utcMillis: fajrUtcMillis),
      PrayerWidgetTime(label: labels.sunrise, utcMillis: sunriseUtcMillis),
      PrayerWidgetTime(label: labels.dhuhr, utcMillis: dhuhrUtcMillis),
      PrayerWidgetTime(label: labels.asr, utcMillis: asrUtcMillis),
      PrayerWidgetTime(label: labels.maghrib, utcMillis: maghribUtcMillis),
      PrayerWidgetTime(label: labels.isha, utcMillis: ishaUtcMillis),
    ]
  }

  static var placeholder: PrayerWidgetDaySnapshot {
    let zone = TimeZone(identifier: "Asia/Dhaka")!
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = zone
    let today = calendar.startOfDay(for: Date())
    func millis(_ hour: Int, _ minute: Int) -> Int64 {
      let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: today)!
      return Int64(date.timeIntervalSince1970 * 1000)
    }
    return PrayerWidgetDaySnapshot(
      localDateKey: PrayerWidgetDateFormatter.dateKey(today, timeZone: zone),
      fajrUtcMillis: millis(4, 35), sunriseUtcMillis: millis(5, 52),
      dhuhrUtcMillis: millis(12, 6), asrUtcMillis: millis(16, 28),
      maghribUtcMillis: millis(18, 12), ishaUtcMillis: millis(19, 29),
      hijriDateLabel: "12 Ramadan 1447 AH", sehriEndUtcMillis: millis(4, 25)
    )
  }
}

struct PrayerWidgetTime: Identifiable {
  let label: String
  let utcMillis: Int64?
  var id: String { label }

  static func empty(labels: PrayerWidgetLabels) -> [PrayerWidgetTime] {
    [labels.fajr, labels.sunrise, labels.dhuhr, labels.asr, labels.maghrib, labels.isha]
      .map { PrayerWidgetTime(label: $0, utcMillis: nil) }
  }
}

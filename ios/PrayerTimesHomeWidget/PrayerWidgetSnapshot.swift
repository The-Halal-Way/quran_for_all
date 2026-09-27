import Foundation

struct PrayerWidgetSnapshot: Decodable {
  let timeZoneId: String
  let locationLabel: String
  let days: [PrayerWidgetDaySnapshot]

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
      days: [PrayerWidgetDaySnapshot.placeholder]
    )
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
  let hijriDateLabel: String?
  let sehriEndUtcMillis: Int64?

  var sehriEnd: Int64 { sehriEndUtcMillis ?? fajrUtcMillis - 10 * 60_000 }

  var prayers: [PrayerWidgetTime] {
    [
      PrayerWidgetTime(label: "Fajr", utcMillis: fajrUtcMillis),
      PrayerWidgetTime(label: "Sunrise", utcMillis: sunriseUtcMillis),
      PrayerWidgetTime(label: "Dhuhr", utcMillis: dhuhrUtcMillis),
      PrayerWidgetTime(label: "Asr", utcMillis: asrUtcMillis),
      PrayerWidgetTime(label: "Maghrib", utcMillis: maghribUtcMillis),
      PrayerWidgetTime(label: "Isha", utcMillis: ishaUtcMillis),
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

  static let empty = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]
    .map { PrayerWidgetTime(label: $0, utcMillis: nil) }
}

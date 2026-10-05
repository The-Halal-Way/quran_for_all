import Foundation

enum PrayerWidgetDateFormatter {
  static func dateKey(_ date: Date, timeZone: TimeZone) -> String {
    formatter("yyyy-MM-dd", timeZone: timeZone, locale: Locale(identifier: "en_US_POSIX"))
      .string(from: date)
  }

  static func date(_ date: Date, timeZone: TimeZone, localeIdentifier: String) -> String {
    formatter(
      "EEEE, MMM d, yyyy",
      timeZone: timeZone,
      locale: Locale(identifier: localeIdentifier)
    ).string(from: date)
  }

  static func time(
    _ utcMillis: Int64?, timeZone: TimeZone, localeIdentifier: String
  ) -> String {
    guard let utcMillis else { return "—" }
    let date = Date(timeIntervalSince1970: TimeInterval(utcMillis) / 1000)
    return formatter(
      "h:mm a",
      timeZone: timeZone,
      locale: Locale(identifier: localeIdentifier)
    ).string(from: date)
  }

  private static func formatter(
    _ pattern: String, timeZone: TimeZone, locale: Locale = .current
  ) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.timeZone = timeZone
    formatter.dateFormat = pattern
    return formatter
  }
}

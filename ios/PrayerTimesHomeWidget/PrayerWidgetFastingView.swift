import SwiftUI

struct PrayerWidgetFastingView: View {
  let sehriEnd: Int64?
  let iftar: Int64?
  let timeZone: TimeZone
  let compact: Bool

  var body: some View {
    HStack(spacing: 0) {
      time(label: "SEHRI END", value: sehriEnd)
      Rectangle().fill(PrayerWidgetPalette.divider).frame(width: 1, height: compact ? 22 : 28)
      time(label: "IFTAR", value: iftar)
    }
    .padding(.vertical, compact ? 4 : 8)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(PrayerWidgetPalette.gold.opacity(0.08))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .stroke(PrayerWidgetPalette.gold.opacity(0.14), lineWidth: 1)
    )
  }

  private func time(label: String, value: Int64?) -> some View {
    VStack(spacing: 2) {
      Text(label)
        .font(.system(size: compact ? 8 : 10, weight: .bold))
        .tracking(0.5)
      Text(PrayerWidgetDateFormatter.time(value, timeZone: timeZone))
        .font(.system(size: compact ? 12 : 17, weight: .bold, design: .rounded).monospacedDigit())
    }
    .foregroundColor(PrayerWidgetPalette.gold)
    .lineLimit(1)
    .minimumScaleFactor(0.7)
    .frame(maxWidth: .infinity)
    .accessibilityElement(children: .combine)
  }
}

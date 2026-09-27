import SwiftUI

struct PrayerWidgetTimeRow: View {
  let prayer: PrayerWidgetTime
  let timeZone: TimeZone
  let compact: Bool

  var body: some View {
    Group {
      if compact {
        VStack(spacing: 1) {
          label.font(.system(size: 9, weight: .medium))
          value.font(.system(size: 12, weight: .bold, design: .rounded).monospacedDigit())
        }
      } else {
        HStack {
          label.font(.system(size: 13, weight: .semibold))
          Spacer(minLength: 8)
          value.font(.system(size: 16, weight: .bold, design: .rounded).monospacedDigit())
        }
        .padding(.vertical, 3)
      }
    }
    .lineLimit(1)
    .minimumScaleFactor(0.7)
    .accessibilityElement(children: .combine)
  }

  private var label: some View {
    Text(prayer.label).foregroundColor(.white)
  }

  private var value: some View {
    Text(PrayerWidgetDateFormatter.time(prayer.utcMillis, timeZone: timeZone))
      .foregroundColor(PrayerWidgetPalette.gold)
  }
}

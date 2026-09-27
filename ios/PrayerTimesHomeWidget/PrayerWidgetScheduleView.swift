import SwiftUI

struct PrayerWidgetScheduleView: View {
  let prayers: [PrayerWidgetTime]
  let location: String
  let timeZone: TimeZone
  let compact: Bool

  var body: some View {
    VStack(spacing: compact ? 3 : 5) {
      HStack {
        Text("PRAYER TIMES")
          .font(.system(size: compact ? 9 : 10, weight: .bold))
          .tracking(1)
          .foregroundColor(PrayerWidgetPalette.gold)
        Spacer(minLength: 4)
        Text(location)
          .font(.system(size: compact ? 9 : 10, weight: .medium))
          .foregroundColor(.white)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
      }
      if compact {
        compactSchedule
      } else {
        VStack(spacing: 0) {
          ForEach(Array(prayers.enumerated()), id: \.element.id) { index, prayer in
            PrayerWidgetTimeRow(prayer: prayer, timeZone: timeZone, compact: false)
              .frame(maxHeight: .infinity)
            if index < prayers.count - 1 { separator }
          }
        }
      }
    }
  }

  private var compactSchedule: some View {
    VStack(spacing: 3) {
      ForEach(0..<2) { row in
        HStack(spacing: 0) {
          ForEach(0..<3) { column in
            let index = row * 3 + column
            if index < prayers.count {
              PrayerWidgetTimeRow(prayer: prayers[index], timeZone: timeZone, compact: true)
                .frame(maxWidth: .infinity)
              if column < 2 {
                Rectangle().fill(PrayerWidgetPalette.divider).frame(width: 1, height: 22)
              }
            }
          }
        }
        if row == 0 { separator }
      }
    }
  }

  private var separator: some View {
    Rectangle().fill(PrayerWidgetPalette.divider).frame(height: 1)
  }
}


import SwiftUI
import WidgetKit

struct PrayerTimesHomeWidgetView: View {
  let entry: PrayerTimesWidgetEntry
  @Environment(\.widgetFamily) private var family

  var body: some View {
    GeometryReader { geometry in
      let compact = family == .systemMedium || geometry.size.height < 270
      VStack(spacing: compact ? 5 : 10) {
        PrayerWidgetHeaderView(entry: entry, compact: compact)
        PrayerWidgetScheduleView(
          prayers: entry.displayDay?.prayers ?? PrayerWidgetTime.empty,
          location: entry.snapshot?.locationLabel ?? "",
          timeZone: entry.timeZone, compact: compact
        )
        .frame(maxHeight: .infinity)
        PrayerWidgetFastingView(
          sehriEnd: entry.displayDay?.sehriEnd,
          iftar: entry.displayDay?.maghribUtcMillis,
          timeZone: entry.timeZone, compact: compact
        )
        if entry.displayDay == nil && !compact {
          Text("Open the app to update today's times")
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.white)
        }
      }
      .padding(compact ? 10 : 16)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
    }
    .modifier(PrayerWidgetBackground())
  }
}


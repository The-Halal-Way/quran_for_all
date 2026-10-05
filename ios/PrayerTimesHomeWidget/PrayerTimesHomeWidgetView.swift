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
          prayers: entry.displayDay?.prayers(labels: entry.snapshot?.labels ?? .english)
            ?? PrayerWidgetTime.empty(labels: entry.snapshot?.labels ?? .english),
          location: entry.snapshot?.locationLabel ?? "",
          timeZone: entry.timeZone,
          labels: entry.snapshot?.labels ?? .english,
          compact: compact
        )
        .frame(maxHeight: .infinity)
        PrayerWidgetFastingView(
          sehriEnd: entry.displayDay?.sehriEnd,
          iftar: entry.displayDay?.maghribUtcMillis,
          timeZone: entry.timeZone,
          labels: entry.snapshot?.labels ?? .english,
          compact: compact
        )
        if entry.displayDay == nil && !compact {
          Text((entry.snapshot?.labels ?? .english).openToSync)
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

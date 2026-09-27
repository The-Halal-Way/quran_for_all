import SwiftUI

struct PrayerWidgetHeaderView: View {
  let entry: PrayerTimesWidgetEntry
  let compact: Bool

  var body: some View {
    VStack(spacing: compact ? 2 : 5) {
      Text("Muslim & Quran Pro")
        .font(.system(size: compact ? 13 : 17, weight: .semibold, design: .serif))
        .foregroundColor(.white)
      Text(entry.displayDay?.hijriDateLabel ?? "Hijri date")
        .font(.system(size: compact ? 15 : 21, weight: .bold))
        .foregroundColor(PrayerWidgetPalette.gold)
        .padding(.horizontal, 12)
        .padding(.vertical, compact ? 2 : 4)
        .frame(maxWidth: .infinity)
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(PrayerWidgetPalette.gold.opacity(0.08))
        )
        .environment(\.layoutDirection, .leftToRight)
      Text(PrayerWidgetDateFormatter.date(entry.date, timeZone: entry.timeZone))
        .font(.system(size: compact ? 9 : 11, weight: .medium))
        .foregroundColor(.white)
    }
    .lineLimit(1)
    .minimumScaleFactor(0.75)
    .frame(maxWidth: .infinity)
    .multilineTextAlignment(.center)
  }
}

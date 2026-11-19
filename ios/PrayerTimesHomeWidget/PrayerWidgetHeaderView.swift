import SwiftUI

struct PrayerWidgetHeaderView: View {
  let entry: PrayerTimesWidgetEntry
  let compact: Bool

  var body: some View {
    VStack(spacing: compact ? 2 : 5) {
      if !compact {
        Text(entry.snapshot?.labels.appTitle ?? PrayerWidgetLabels.english.appTitle)
        .font(.system(size: compact ? 13 : 17, weight: .semibold, design: .serif))
        .foregroundColor(.white)
      }
      Text(entry.displayDay?.hijriDateLabel ?? (entry.snapshot?.labels.hijriDatePlaceholder
        ?? PrayerWidgetLabels.english.hijriDatePlaceholder))
        .font(.system(size: compact ? 15 : 21, weight: .bold))
        .foregroundColor(PrayerWidgetPalette.gold)
        .padding(.horizontal, 12)
        .padding(.vertical, compact ? 1 : 4)
        .frame(maxWidth: .infinity)
        .background(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(PrayerWidgetPalette.gold.opacity(0.08))
        )
        .environment(\.layoutDirection, .leftToRight)
      HStack(spacing: 0) {
        Color.clear.frame(width: 26, height: compact ? 20 : 24)
        Text(PrayerWidgetDateFormatter.date(
          entry.date,
          timeZone: entry.timeZone,
          localeIdentifier: entry.snapshot?.labels.localeIdentifier
            ?? PrayerWidgetLabels.english.localeIdentifier
        ))
          .font(.system(size: compact ? 9 : 11, weight: .medium))
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
        // iOS opens the app for a foreground GPS refresh; Android uses the
        // package's headless callback without opening the app.
        Link(destination: URL(string: "quranforall://prayer-widget/refresh?homeWidget")!) {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: compact ? 13 : 16, weight: .semibold))
            .foregroundColor(PrayerWidgetPalette.gold)
            .frame(width: 26, height: compact ? 20 : 24)
        }
        .accessibilityLabel(entry.snapshot?.labels.refreshLabel ?? PrayerWidgetLabels.english.refreshLabel)
      }
    }
    .lineLimit(1)
    .minimumScaleFactor(0.75)
    .frame(maxWidth: .infinity)
    .multilineTextAlignment(.center)
  }
}

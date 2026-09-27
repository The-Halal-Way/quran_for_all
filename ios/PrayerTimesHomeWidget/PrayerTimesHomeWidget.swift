import SwiftUI
import WidgetKit

@main
struct PrayerTimesHomeWidget: Widget {
  var body: some WidgetConfiguration {
    if #available(iOSApplicationExtension 17.0, *) {
      return configuration.contentMarginsDisabled()
    } else {
      return configuration
    }
  }

  private var configuration: some WidgetConfiguration {
    StaticConfiguration(kind: PrayerWidgetConstants.kind, provider: PrayerTimesWidgetProvider()) { entry in
      PrayerTimesHomeWidgetView(entry: entry)
    }
    .configurationDisplayName("Muslim & Quran Pro")
    .description("Today's prayers, Hijri date, Sehri end and Iftar at a glance.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

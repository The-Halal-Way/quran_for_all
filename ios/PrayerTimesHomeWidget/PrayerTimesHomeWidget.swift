import SwiftUI
import WidgetKit

@main
struct PrayerTimesWidgetsBundle: WidgetBundle {
  var body: some Widget {
    PrayerTimesHomeWidget()
    PrayerTimesFocusHomeWidget()
    PrayerTimesFocusElderlyHomeWidget()
  }
}

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

struct PrayerTimesFocusHomeWidget: Widget {
  var body: some WidgetConfiguration {
    if #available(iOSApplicationExtension 17.0, *) {
      return configuration.contentMarginsDisabled()
    } else {
      return configuration
    }
  }

  private var configuration: some WidgetConfiguration {
    StaticConfiguration(kind: PrayerWidgetConstants.focusKind, provider: PrayerFocusWidgetProvider()) { entry in
      PrayerTimesFocusHomeWidgetView(entry: entry)
    }
    .configurationDisplayName("Prayer Times (Live Timer)")
    .description("Live waqt countdown timer with Hijri date, Sehri, Sunrise and Iftar.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

struct PrayerTimesFocusElderlyHomeWidget: Widget {
  var body: some WidgetConfiguration {
    if #available(iOSApplicationExtension 17.0, *) {
      return configuration.contentMarginsDisabled()
    } else {
      return configuration
    }
  }

  private var configuration: some WidgetConfiguration {
    StaticConfiguration(kind: PrayerWidgetConstants.focusElderlyKind, provider: PrayerFocusWidgetProvider()) { entry in
      PrayerTimesFocusHomeWidgetView(entry: entry, elderly: true)
    }
    .configurationDisplayName("Prayer Times (Live Timer Elders)")
    .description("Large font live waqt countdown timer with Hijri date, Sehri, Sunrise and Iftar for elders.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

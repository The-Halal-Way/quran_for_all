import SwiftUI

enum PrayerWidgetPalette {
  static let gold = Color(red: 0.96, green: 0.85, blue: 0.58)
  static let divider = Color.white.opacity(0.4)
}

struct PrayerWidgetBackground: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      content.containerBackground(for: .widget) { wash }
    } else {
      content.background(wash)
    }
  }

  private var wash: some View {
    LinearGradient(
      colors: [
        Color(red: 0.07, green: 0.10, blue: 0.13).opacity(0.28),
        Color(red: 0.14, green: 0.16, blue: 0.19).opacity(0.22),
      ],
      startPoint: .topLeading, endPoint: .bottomTrailing
    )
  }
}


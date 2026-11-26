import SwiftUI
import WidgetKit

struct PrayerTimesFocusHomeWidgetView: View {
  let entry: PrayerFocusWidgetEntry
  var elderly: Bool = false
  @Environment(\.widgetFamily) private var family

  private var labels: PrayerWidgetLabels {
    entry.snapshot?.labels ?? .english
  }

  private var emeraldStart: Color { Color(red: 0.02, green: 0.59, blue: 0.41) }
  private var emeraldEnd: Color { Color(red: 0.06, green: 0.73, blue: 0.51) }
  private var emeraldMint: Color { Color(red: 0.82, green: 0.98, blue: 0.90) }
  private var goldLight: Color { Color(red: 1.00, green: 0.95, blue: 0.78) }

  var body: some View {
    let compact = family == .systemMedium
    VStack(spacing: compact ? (elderly ? 5 : 6) : (elderly ? 13 : 12)) {
      headerView(compact: compact)
      heroView(compact: compact)
      celestialStripView(compact: compact)
      if entry.displayDay == nil && !compact {
        Text(labels.openToSync)
          .font(.system(size: elderly ? 12 : 10, weight: .medium))
          .foregroundColor(.white.opacity(0.85))
      }
    }
    .padding(compact ? (elderly ? 10 : 11) : 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
    .modifier(PrayerWidgetBackground())
  }

  private func headerView(compact: Bool) -> some View {
    let badgeSize: CGFloat = compact ? (elderly ? 31 : 28) : (elderly ? 40 : 34)
    return HStack(spacing: 9) {
      ZStack {
        RoundedRectangle(cornerRadius: 9, style: .continuous)
          .fill(
            LinearGradient(
              colors: [emeraldStart, emeraldEnd],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .overlay(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
              .stroke(PrayerWidgetPalette.gold.opacity(0.35), lineWidth: 0.8)
          )
        Image(systemName: "moon.stars.fill")
          .font(.system(size: compact ? (elderly ? 15 : 13) : (elderly ? 19 : 16), weight: .semibold))
          .foregroundColor(goldLight)
      }
      .frame(width: badgeSize, height: badgeSize)

      VStack(alignment: .leading, spacing: 1) {
        Text(entry.displayDay?.hijriDateLabel ?? labels.hijriDatePlaceholder)
          .font(.system(size: compact ? (elderly ? 15.5 : 13.5) : (elderly ? 19 : 16), weight: .bold))
          .foregroundColor(goldLight)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
          .environment(\.layoutDirection, .leftToRight)
        Text(
          PrayerWidgetDateFormatter.date(
            entry.date,
            timeZone: entry.timeZone,
            localeIdentifier: labels.localeIdentifier
          )
        )
        .font(.system(size: compact ? (elderly ? 11.5 : 10) : (elderly ? 13.5 : 11.5), weight: .medium))
        .foregroundColor(.white.opacity(0.75))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Link(destination: URL(string: "quranforall://prayer-widget/refresh?homeWidget")!) {
        Image(systemName: "arrow.clockwise")
          .font(.system(size: compact ? (elderly ? 15 : 13) : (elderly ? 17 : 15), weight: .semibold))
          .foregroundColor(PrayerWidgetPalette.gold)
          .frame(width: 28, height: 28)
      }
      .accessibilityLabel(labels.refreshLabel)
    }
  }

  private func heroView(compact: Bool) -> some View {
    HStack(spacing: 8) {
      VStack(alignment: .leading, spacing: 2) {
        Text(entry.focus?.statusLabel ?? labels.currentPrayerLabel)
          .font(.system(size: compact ? (elderly ? 10 : 8.5) : (elderly ? 11.5 : 10), weight: .bold))
          .tracking(0.6)
          .foregroundColor(PrayerWidgetPalette.gold)
          .lineLimit(1)
        HStack(spacing: 5) {
          Image(systemName: entry.focus?.symbolName ?? "sun.max.fill")
            .font(.system(size: compact ? (elderly ? 16 : 14) : (elderly ? 20 : 17), weight: .semibold))
            .foregroundColor(PrayerWidgetPalette.gold)
          Text(entry.focus?.prayerName ?? "—")
            .font(.system(size: compact ? (elderly ? 18 : 15.5) : (elderly ? 23 : 19), weight: .bold))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
        }
        Text(entry.focus?.timeRange ?? "—")
          .font(.system(size: compact ? (elderly ? 11.5 : 10) : (elderly ? 14 : 11.5), weight: .medium))
          .foregroundColor(.white.opacity(0.78))
          .lineLimit(1)
          .minimumScaleFactor(0.75)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(spacing: 2) {
        Text(entry.focus?.timerLabel ?? labels.waqtEndsInLabel)
          .font(.system(size: compact ? (elderly ? 9.5 : 8) : (elderly ? 11 : 9.5), weight: .bold))
          .tracking(0.5)
          .foregroundColor(emeraldMint)
          .lineLimit(1)
          .minimumScaleFactor(0.7)

        if let target = entry.focus?.targetDate, target > entry.date {
          Text(target, style: .timer)
            .font(.system(size: compact ? (elderly ? 19 : 16) : (elderly ? 24 : 20), weight: .bold, design: .rounded).monospacedDigit())
            .foregroundColor(goldLight)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
        } else {
          Text("—")
            .font(.system(size: compact ? (elderly ? 19 : 16) : (elderly ? 24 : 20), weight: .bold, design: .rounded))
            .foregroundColor(goldLight)
        }
      }
      .padding(.horizontal, 8)
      .padding(.vertical, compact ? 5 : 8)
      .frame(minWidth: compact ? (elderly ? 114 : 104) : (elderly ? 136 : 124))
      .background(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .fill(
            LinearGradient(
              colors: [emeraldStart.opacity(0.32), emeraldEnd.opacity(0.28)],
              startPoint: .top,
              endPoint: .bottom
            )
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .stroke(PrayerWidgetPalette.gold, lineWidth: 1.1)
      )
    }
    .padding(.horizontal, 10)
    .padding(.vertical, compact ? 6 : 10)
    .background(
      RoundedRectangle(cornerRadius: 13, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              Color(red: 0.10, green: 0.18, blue: 0.16).opacity(0.35),
              Color(red: 0.07, green: 0.11, blue: 0.14).opacity(0.38),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 13, style: .continuous)
        .stroke(PrayerWidgetPalette.gold.opacity(0.28), lineWidth: 1)
    )
  }

  private func celestialStripView(compact: Bool) -> some View {
    HStack(spacing: 0) {
      stripCell(
        label: labels.sehriEnd,
        value: entry.displayDay?.sehriEnd,
        compact: compact
      )
      Rectangle()
        .fill(PrayerWidgetPalette.divider)
        .frame(width: 1, height: compact ? 18 : 24)
      stripCell(
        label: labels.sunrise.uppercased(),
        value: entry.displayDay?.sunriseUtcMillis,
        compact: compact
      )
      Rectangle()
        .fill(PrayerWidgetPalette.divider)
        .frame(width: 1, height: compact ? 18 : 24)
      stripCell(
        label: labels.iftar,
        value: entry.displayDay?.maghribUtcMillis,
        compact: compact
      )
    }
    .padding(.vertical, compact ? 4 : 8)
    .background(
      RoundedRectangle(cornerRadius: 11, style: .continuous)
        .fill(PrayerWidgetPalette.gold.opacity(0.08))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 11, style: .continuous)
        .stroke(PrayerWidgetPalette.gold.opacity(0.16), lineWidth: 1)
    )
  }

  private func stripCell(label: String, value: Int64?, compact: Bool) -> some View {
    VStack(spacing: 1) {
      Text(label)
        .font(.system(size: compact ? (elderly ? 9.5 : 8) : (elderly ? 11.5 : 9.5), weight: .bold))
        .tracking(0.4)
        .foregroundColor(PrayerWidgetPalette.gold)
      Text(
        PrayerWidgetDateFormatter.time(
          value,
          timeZone: entry.timeZone,
          localeIdentifier: labels.localeIdentifier
        )
      )
      .font(.system(size: compact ? (elderly ? 12.5 : 10.5) : (elderly ? 15.5 : 13), weight: .bold, design: .rounded).monospacedDigit())
      .foregroundColor(PrayerWidgetPalette.gold)
    }
    .lineLimit(1)
    .minimumScaleFactor(0.7)
    .frame(maxWidth: .infinity)
    .accessibilityElement(children: .combine)
  }
}

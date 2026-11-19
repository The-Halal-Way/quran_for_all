# Offline prayer times

The app calculates prayer times from coordinates, the selected calculation
method, Asr school and minute adjustments. There are no prayer-times HTTP
requests. Quran downloads, Qibla's existing service and other unrelated network
features still use `http`.

## Flow

- Dashboard initialization starts after the first frame. The repository shows
  saved schedules where available and calculates today and tomorrow in a Dart
  isolate. A returning launch uses saved coordinates immediately.
- A first location fix requests permission when needed, uses GPS accuracy,
  and has an eight-second platform time limit and ten-second outer timeout.
  A returning launch refreshes coordinates after displaying the saved schedule.
  Resume/refresh also obtains fresh coordinates; saved coordinates remain usable
  when permission, GPS or the current fix is unavailable.
- After today's schedule is displayed, the view model prepares 30 local calendar
  days in an isolate. SQLite stores the results and a complete snapshot goes
  through `home_widget` to Android and iOS. Subsequent loads retain all 30 days.
- Date arithmetic advances Gregorian calendar days rather than 24-hour local
  durations. Stored prayer instants are UTC; presentation uses the profile's
  IANA timezone (including DST and fractional offsets).
- A settings change recalculates the selected profile and replaces the widget
  snapshot. An older background calculation cannot publish another profile.

## Settings

All 13 existing methods are explicitly mapped in `OfflinePrayerParameters`.
JAKIM/Malaysia is a custom 20° Fajr / 18° Isha method with a one-minute Dhuhr
margin. Singapore retains upward minute rounding. Other presets retain the
library's method adjustments; user adjustments are added exactly once.
Umm al-Qura uses 120-minute Isha in Ramadan and 90 minutes otherwise, with the
app's offline Hijri calendar determining the month (not Gregorian constants).
Sehri retains the existing ten-minute precaution before Fajr; Iftar uses Maghrib.
The legacy imsak/sunset/midnight offset values remain stored for compatibility;
these were not displayed by the previous prayer-day contract either.

## Package patch and high latitudes

`adhan` was removed. `adhan_dart` 2.0.1 is pinned through a local override in
`packages/adhan_dart`; that directory retains the upstream MIT license.
See its README for the one upstream mathematical correction. Unattainable
twilight uses the selected night-portion rule, applied to actual neighbouring
solar nights, and is labelled as a high-latitude estimate. This fallback is
an estimate, including for Moonsighting Committee when its twilight calculation
cannot run; it is not a claim of an official local timetable. Polar dates with
no real sunrise/sunset report unavailable rather than invent solar events.

## Forbidden-time windows

The app retains three short windows and now displays start/end times:

- Astronomical sunrise through twenty minutes afterward.
- Five minutes before astronomical solar noon through one minute afterward.
- Twenty minutes before astronomical sunset through sunset.

These are explicitly labelled **estimated precautionary windows**, not exact,
universal religious boundaries or a replacement for local scholarly guidance.
The hadith basis for the three solar periods is Sahih Muslim 831:
https://sunnah.com/muslim:831 . The minute margins are the app's stated practical
convention, not minute values attributed to that hadith. Display rounding
expands each interval outward. Unadjusted solar events are stored independently,
so changing a prayer offset does not shift the underlying solar pause.

## Home-screen widgets

Android and iOS consume the same UTC snapshot, localized labels, adjusted Hijri
dates and Sehri cutoff. Android keeps its periodic OS updates and additionally
schedules an inexact refresh at local midnight. Date/time/timezone changes,
reboot and package replacement request another render; the alarm is cancelled
when the last widget is removed. No exact-alarm permission is required.
iOS has timeline entries at local midnights, using Calendar's DST-aware dates.
Both platforms select the matching local date and never relabel an expired
snapshot as today's schedule. Tapping opens the app to refresh.

Automatic native updates read the precomputed schedule without running Dart.
The offline snapshot lasts thirty days from the last successful replenishment.
Open the app or use Android's manual refresh to replenish it. Android's manual
refresh can start a headless Dart engine without opening the full app UI.
Android/iOS control background delivery timing, so midnight rendering can be
delayed by platform power management.

## Verification

Run:

```
flutter test test/data/prayer_times test/core/prayer_times \
  test/presentation/viewmodels/dashboard_prayer_times_viewmodel_test.dart \
  test/presentation/widgets/prayer/prayer_view_test.dart \
  test/presentation/widgets/settings_prayer_times_panel_test.dart
```

Coverage includes upstream time fixtures, all exposed presets, Asr/offsets,
Ramadan intervals, UTC/local date boundaries, DST/leap days, high-latitude
fallback, unavailable polar events, bilingual forbidden windows, permission/GPS
fallbacks and 30-day widget publication/settings refresh.

## Widget prayer ranges and manual refresh

The five prayer rows display the same boundaries as the app: Fajr to sunrise,
Dhuhr to Asr, Asr to Maghrib, Maghrib to Isha, and Isha to the actual next day's
Fajr. Sunrise remains a single astronomical event. One additional day is
calculated and stored to supply the last displayed day's Isha end, while the
published snapshot still contains thirty days. Older snapshots omit the new
Isha end instead of inventing one; opening or refreshing the app replaces them.

Android's date row now has a refresh control. It shows a busy indicator,
coalesces repeated taps, and sends an explicit pending intent to home_widget's
headless Dart callback. That callback refreshes coordinates when existing
permission permits, retains saved coordinates as needed, recalculates the
rolling schedule and republishes the widget without opening the full app.
The callback never requests location permission in the background. A first-use
widget with no data or no registered callback opens the app for setup instead.
Failures retain the last schedule and offer retry. A timeout clears a busy
indicator if Android interrupts the work. Prayer preferences are reloaded from
native storage across the independent app and callback engines; the callback
owns and closes a separate SQLite connection.

The iOS refresh link opens the app, whose foreground/resume location refresh
then updates the widget. The custom URL scheme is registered for that purpose.
The compact layouts use two-line ranges and tighter spacing to retain end
times without crowding the full-size design. Refresh accessibility labels and
failure messages follow the selected English or Bangla language.

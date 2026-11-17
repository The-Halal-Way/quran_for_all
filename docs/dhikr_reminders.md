# Dhikr reminders

Dashboard → Dhikr Reminders replaces only the dashboard Eid shortcut.
The Eid prayer guide remains in the Prayer tab.

Durud and Istighfar are independent and disabled by default. Each supports
1–1440 minute intervals, three bundled sounds, local previews, and an immediate
test notification. Permission is requested when enabling or testing. A denied
request leaves an off reminder off; the screen offers notification settings.

Settings use `dhikr_reminders_v1` in SharedPreferences. Two native repeating
requests use IDs 1500000001–1500000002, outside the Daily Hadith and Islamic
Days ranges; tests use those IDs plus 100. Turning a reminder off cancels its
scheduled and test notifications only. Notification taps reopen the settings
page with the relevant dhikr first.

After the first app frame and settings load, only these small preferences are
read. Enabled reminders reconcile against native pending requests. Matching
requests are retained so reopening the app does not restart their countdown.
Locale, interval, or sound changes replace affected requests. Missing requests
are restored; denied permission cancels deliveries, and returning with
permission restored re-enables configured reminders. No catalog JSON is read.

Android uses inexact native repeating notifications without exact-alarm
permission; battery-saving settings, silent mode, channel settings and Do Not
Disturb still apply. The existing boot receiver restores Android requests.
iOS uses repeating time-interval notifications and bundled short WAV sounds.
Only Android and iOS are enabled by this feature.

Sounds and original filenames/license: `assets/audio/reminders/README.md`.

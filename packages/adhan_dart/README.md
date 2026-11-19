# adhan_dart local patch

Vendored from adhan_dart 2.0.1 (MIT), https://github.com/prayer-timetable/adhan_dart.
All upstream library files and the license are retained.

One correction in `lib/src/Astronomical.dart`: an unattainable solar altitude
must return NaN, not a fabricated 1-degree hour angle. Returning early also
prevents normalization of NaN later in the same calculation.

The application adapter handles the upstream DateTime conversion limitation:
when twilight is unattainable it derives the selected high-latitude night
portions from actual neighbouring sunrise/sunset events. Polar day/night,
where actual solar events are absent, is reported unavailable. The adapter
does not use the package's `fajrAfter`/`ishaBefore` convenience fields.

Regression coverage lives in test/data/prayer_times/. Remove this override
only after the upstream angle handling is corrected and those tests pass.

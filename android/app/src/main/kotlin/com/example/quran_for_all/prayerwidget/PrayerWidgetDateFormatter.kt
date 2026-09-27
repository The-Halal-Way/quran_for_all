package com.example.quran_for_all.prayerwidget

import java.text.SimpleDateFormat
import java.util.Date
import java.util.GregorianCalendar
import java.util.Locale
import java.util.TimeZone

class PrayerWidgetDateFormatter(private val timeZone: TimeZone) {
    fun dateKey(now: Long): String = formatter("yyyy-MM-dd", Locale.US).format(Date(now))

    fun date(now: Long): String = formatter("EEEE, MMM d, yyyy").format(Date(now))

    fun time(utcMillis: Long?): String = utcMillis?.let {
        formatter("h:mm a").format(Date(it))
    } ?: "—"

    private fun formatter(pattern: String, locale: Locale = Locale.getDefault()) =
        SimpleDateFormat(pattern, locale).apply {
            calendar = GregorianCalendar(timeZone, locale)
            this.timeZone = this@PrayerWidgetDateFormatter.timeZone
        }
}

package com.example.quran_for_all.prayerwidget

import java.text.SimpleDateFormat
import java.util.Date
import java.util.GregorianCalendar
import java.util.Locale
import java.util.TimeZone

class PrayerWidgetDateFormatter(private val timeZone: TimeZone) {
    fun dateKey(now: Long): String = formatter("yyyy-MM-dd", Locale.US).format(Date(now))

    fun date(now: Long, localeIdentifier: String): String =
        formatter("EEEE, MMM d, yyyy", Locale.forLanguageTag(localeIdentifier.replace('_', '-')))
            .format(Date(now))

    fun time(utcMillis: Long?, localeIdentifier: String): String = utcMillis?.let {
        formatter("h:mm a", Locale.forLanguageTag(localeIdentifier.replace('_', '-'))).format(Date(it))
    } ?: "—"

    private fun formatter(pattern: String, locale: Locale = Locale.getDefault()) =
        SimpleDateFormat(pattern, locale).apply {
            calendar = GregorianCalendar(timeZone, locale)
            this.timeZone = this@PrayerWidgetDateFormatter.timeZone
        }
}

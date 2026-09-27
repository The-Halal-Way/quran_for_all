package com.example.quran_for_all.prayerwidget

import android.content.Context
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import com.example.quran_for_all.MainActivity
import com.example.quran_for_all.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import java.util.TimeZone

class PrayerWidgetRenderer(
    private val context: Context,
    private val snapshot: PrayerWidgetSnapshot?,
    private val now: Long = System.currentTimeMillis(),
) {
    private val formatter = PrayerWidgetDateFormatter(
        snapshot?.timeZoneId?.let(TimeZone::getTimeZone) ?: TimeZone.getDefault()
    )
    // Never label an expired snapshot's first day as today's schedule.
    private val today = snapshot?.days?.firstOrNull { it.localDateKey == formatter.dateKey(now) }

    fun render(compact: Boolean): RemoteViews {
        val layout = if (compact) R.layout.prayer_times_home_widget_compact
            else R.layout.prayer_times_home_widget
        return RemoteViews(context.packageName, layout).apply {
            setOnClickPendingIntent(
                R.id.widget_container,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )
            setTextViewText(R.id.widget_date, formatter.date(now))
            setTextViewText(
                R.id.widget_hijri_date,
                today?.hijriDateLabel?.takeIf(String::isNotBlank)
                    ?: context.getString(R.string.prayer_widget_hijri_placeholder),
            )
            setTextViewText(R.id.widget_location, snapshot?.locationLabel.orEmpty())
            setTextViewText(R.id.prayer_fajr_value, formatter.time(today?.fajrUtcMillis))
            setTextViewText(R.id.prayer_sunrise_value, formatter.time(today?.sunriseUtcMillis))
            setTextViewText(R.id.prayer_dhuhr_value, formatter.time(today?.dhuhrUtcMillis))
            setTextViewText(R.id.prayer_asr_value, formatter.time(today?.asrUtcMillis))
            setTextViewText(R.id.prayer_maghrib_value, formatter.time(today?.maghribUtcMillis))
            setTextViewText(R.id.prayer_isha_value, formatter.time(today?.ishaUtcMillis))
            setTextViewText(R.id.widget_sehri_value, formatter.time(today?.sehriEndUtcMillis))
            setTextViewText(R.id.widget_iftar_value, formatter.time(today?.maghribUtcMillis))
            setViewVisibility(R.id.widget_status, if (today == null && !compact) View.VISIBLE else View.GONE)
            if (compact) {
                compactTypography(this)
                if (today == null) {
                    setTextViewText(R.id.widget_location, context.getString(R.string.prayer_widget_tap_to_update))
                }
            }
        }
    }

    private fun compactTypography(views: RemoteViews) {
        val sizes = mapOf(
            R.id.widget_title to 13f,
            R.id.widget_hijri_date to 15f,
            R.id.widget_date to 9f,
            R.id.widget_schedule_label to 9f,
            R.id.widget_location to 9f,
            R.id.widget_sehri_label to 9f,
            R.id.widget_iftar_label to 9f,
            R.id.widget_sehri_value to 12f,
            R.id.widget_iftar_value to 12f,
        )
        sizes.forEach { (id, size) -> views.setTextViewTextSize(id, TypedValue.COMPLEX_UNIT_SP, size) }
        views.setViewPadding(R.id.widget_hijri_date, 0, dp(2), 0, dp(2))
        views.setViewPadding(R.id.widget_fasting, dp(6), dp(4), dp(6), dp(4))
    }

    private fun dp(value: Int): Int = (value * context.resources.displayMetrics.density).toInt()
}

package com.example.quran_for_all.prayerwidget

import android.content.Context
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import com.example.quran_for_all.MainActivity
import com.example.quran_for_all.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
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
    private val labels = snapshot?.labels ?: PrayerWidgetLabels.english
    private val data = HomeWidgetPlugin.getData(context)
    private val refreshing = data.getLong(PrayerWidgetRefreshAction.BUSY_KEY, 0L) > now
    private val failed = data.getBoolean(PrayerWidgetRefreshAction.ERROR_KEY, false)

    fun render(compact: Boolean, elderly: Boolean = false): RemoteViews {
        val layout = when {
            elderly && compact -> R.layout.prayer_times_elderly_home_widget_compact
            elderly -> R.layout.prayer_times_elderly_home_widget
            compact -> R.layout.prayer_times_home_widget_compact
            else -> R.layout.prayer_times_home_widget
        }
        return RemoteViews(context.packageName, layout).apply {
            setOnClickPendingIntent(
                R.id.widget_container,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )
            setOnClickPendingIntent(R.id.widget_refresh, PrayerWidgetRefreshAction.pendingIntent(context))
            setBoolean(R.id.widget_refresh, "setEnabled", !refreshing)
            setContentDescription(R.id.widget_refresh, if (refreshing) labels.refreshing else labels.refresh)
            setViewVisibility(R.id.widget_refresh_icon, if (refreshing) View.GONE else View.VISIBLE)
            setViewVisibility(R.id.widget_refresh_progress, if (refreshing) View.VISIBLE else View.GONE)
            setTextViewText(R.id.widget_date, formatter.date(now, labels.localeIdentifier))
            setTextViewText(R.id.widget_sehri_label, labels.sehriEnd)
            setTextViewText(R.id.widget_iftar_label, labels.iftar)
            setTextViewText(R.id.prayer_fajr_label, labels.fajr)
            setTextViewText(R.id.prayer_sunrise_label, labels.sunrise)
            setTextViewText(R.id.prayer_dhuhr_label, labels.dhuhr)
            setTextViewText(R.id.prayer_asr_label, labels.asr)
            setTextViewText(R.id.prayer_maghrib_label, labels.maghrib)
            setTextViewText(R.id.prayer_isha_label, labels.isha)
            setTextViewText(
                R.id.widget_hijri_date,
                today?.hijriDateLabel?.takeIf(String::isNotBlank) ?: labels.hijriDatePlaceholder,
            )
            setTextViewText(R.id.prayer_fajr_value, formatter.range(today?.fajrUtcMillis, today?.sunriseUtcMillis, labels.localeIdentifier, compact))
            setTextViewText(R.id.prayer_sunrise_value, formatter.time(today?.sunriseUtcMillis, labels.localeIdentifier))
            setTextViewText(R.id.prayer_dhuhr_value, formatter.range(today?.dhuhrUtcMillis, today?.asrUtcMillis, labels.localeIdentifier, compact))
            setTextViewText(R.id.prayer_asr_value, formatter.range(today?.asrUtcMillis, today?.maghribUtcMillis, labels.localeIdentifier, compact))
            setTextViewText(R.id.prayer_maghrib_value, formatter.range(today?.maghribUtcMillis, today?.ishaUtcMillis, labels.localeIdentifier, compact))
            setTextViewText(R.id.prayer_isha_value, formatter.range(today?.ishaUtcMillis, today?.ishaEndUtcMillis, labels.localeIdentifier, compact))
            setTextViewText(R.id.widget_sehri_value, formatter.time(today?.sehriEndUtcMillis, labels.localeIdentifier))
            setTextViewText(R.id.widget_iftar_value, formatter.time(today?.maghribUtcMillis, labels.localeIdentifier))
            setTextViewText(R.id.widget_status, if (failed) labels.refreshFailed else labels.openToSync)
            setViewVisibility(R.id.widget_status, if ((today == null || failed) && !compact) View.VISIBLE else View.GONE)
            setOnClickPendingIntent(R.id.widget_status, PrayerWidgetRefreshAction.pendingIntent(context))
            // compact layout still has widget_schedule_label and widget_location
            if (compact) {
                setTextViewText(R.id.widget_schedule_label, labels.prayerTimes)
                setTextViewText(R.id.widget_location,
                    if (today == null) labels.tapToUpdate else snapshot?.locationLabel.orEmpty())
                compactTypography(this, elderly)
            }
        }
    }

    private fun compactTypography(views: RemoteViews, elderly: Boolean = false) {
        val sizes = if (elderly) {
            mapOf(
                R.id.widget_hijri_date to 16f,
                R.id.widget_date to 11f,
                R.id.widget_schedule_label to 11f,
                R.id.widget_location to 11f,
                R.id.widget_sehri_label to 11f,
                R.id.widget_iftar_label to 11f,
                R.id.widget_sehri_value to 14f,
                R.id.widget_iftar_value to 14f,
            )
        } else {
            mapOf(
                R.id.widget_hijri_date to 15f,
                R.id.widget_date to 9f,
                R.id.widget_schedule_label to 9f,
                R.id.widget_location to 9f,
                R.id.widget_sehri_label to 9f,
                R.id.widget_iftar_label to 9f,
                R.id.widget_sehri_value to 12f,
                R.id.widget_iftar_value to 12f,
            )
        }
        sizes.forEach { (id, size) -> views.setTextViewTextSize(id, TypedValue.COMPLEX_UNIT_SP, size) }
        views.setViewPadding(R.id.widget_hijri_date, 0, dp(if (elderly) 3 else 2), 0, dp(if (elderly) 3 else 2))
        views.setViewPadding(R.id.widget_fasting, dp(6), dp(if (elderly) 5 else 4), dp(6), dp(if (elderly) 5 else 4))
    }

    private fun dp(value: Int): Int = (value * context.resources.displayMetrics.density).toInt()
}

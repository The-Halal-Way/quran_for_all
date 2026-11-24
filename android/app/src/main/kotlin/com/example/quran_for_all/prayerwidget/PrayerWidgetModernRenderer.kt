package com.example.quran_for_all.prayerwidget

import android.content.Context
import android.view.View
import android.widget.RemoteViews
import com.example.quran_for_all.MainActivity
import com.example.quran_for_all.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.TimeZone

class PrayerWidgetModernRenderer(
    private val context: Context,
    private val snapshot: PrayerWidgetSnapshot?,
    private val now: Long = System.currentTimeMillis(),
) {
    private val formatter = PrayerWidgetDateFormatter(
        snapshot?.timeZoneId?.let(TimeZone::getTimeZone) ?: TimeZone.getDefault()
    )
    private val today = snapshot?.days?.firstOrNull { it.localDateKey == formatter.dateKey(now) }
    private val labels = snapshot?.labels ?: PrayerWidgetLabels.english
    private val data = HomeWidgetPlugin.getData(context)
    private val refreshing = data.getLong(PrayerWidgetRefreshAction.BUSY_KEY, 0L) > now
    private val failed = data.getBoolean(PrayerWidgetRefreshAction.ERROR_KEY, false)

    fun render(compact: Boolean, elderly: Boolean = false): RemoteViews {
        val layout = when {
            elderly && compact -> R.layout.prayer_times_modern_elderly_widget_compact
            elderly -> R.layout.prayer_times_modern_elderly_widget
            compact -> R.layout.prayer_times_modern_widget_compact
            else -> R.layout.prayer_times_modern_widget
        }

        return RemoteViews(context.packageName, layout).apply {
            // Container click
            setOnClickPendingIntent(
                R.id.widget_container,
                HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
            )

            // Refresh action
            setOnClickPendingIntent(R.id.widget_refresh, PrayerWidgetRefreshAction.pendingIntent(context))
            setBoolean(R.id.widget_refresh, "setEnabled", !refreshing)
            setContentDescription(R.id.widget_refresh, if (refreshing) labels.refreshing else labels.refresh)
            setViewVisibility(R.id.widget_refresh_icon, if (refreshing) View.GONE else View.VISIBLE)
            setViewVisibility(R.id.widget_refresh_progress, if (refreshing) View.VISIBLE else View.GONE)

            // Header date
            setTextViewText(R.id.widget_date, formatter.date(now, labels.localeIdentifier))
            setTextViewText(
                R.id.widget_hijri_date,
                today?.hijriDateLabel?.takeIf(String::isNotBlank) ?: labels.hijriDatePlaceholder,
            )

            // 5 Prayers track times & labels
            setTextViewText(R.id.prayer_fajr_label, labels.fajr)
            setTextViewText(R.id.prayer_fajr_value, formatter.time(today?.fajrUtcMillis, labels.localeIdentifier))

            setTextViewText(R.id.prayer_dhuhr_label, labels.dhuhr)
            setTextViewText(R.id.prayer_dhuhr_value, formatter.time(today?.dhuhrUtcMillis, labels.localeIdentifier))

            setTextViewText(R.id.prayer_asr_label, labels.asr)
            setTextViewText(R.id.prayer_asr_value, formatter.time(today?.asrUtcMillis, labels.localeIdentifier))

            setTextViewText(R.id.prayer_maghrib_label, labels.maghrib)
            setTextViewText(R.id.prayer_maghrib_value, formatter.time(today?.maghribUtcMillis, labels.localeIdentifier))

            setTextViewText(R.id.prayer_isha_label, labels.isha)
            setTextViewText(R.id.prayer_isha_value, formatter.time(today?.ishaUtcMillis, labels.localeIdentifier))

            // Fasting / Sehri & Iftar
            setTextViewText(R.id.widget_sehri_label, labels.sehriEnd)
            setTextViewText(R.id.widget_sehri_value, formatter.time(today?.sehriEndUtcMillis, labels.localeIdentifier))
            setTextViewText(R.id.widget_iftar_label, labels.iftar)
            setTextViewText(R.id.widget_iftar_value, formatter.time(today?.maghribUtcMillis, labels.localeIdentifier))

            // Celestial times
            val sunriseText = "${labels.sunrise} ${formatter.time(today?.sunriseUtcMillis, labels.localeIdentifier)}"
            val sunsetText = "${labels.maghrib} ${formatter.time(today?.maghribUtcMillis, labels.localeIdentifier)}"
            setTextViewText(R.id.widget_celestial_sunrise, sunriseText)
            setTextViewText(R.id.widget_celestial_sunset, sunsetText)

            // Calculate active prayer and configure hero
            bindActivePrayerAndHero(this)

            // Status message
            setTextViewText(R.id.widget_status, if (failed) labels.refreshFailed else labels.openToSync)
            setViewVisibility(R.id.widget_status, if ((today == null || failed) && !compact) View.VISIBLE else View.GONE)
            setOnClickPendingIntent(R.id.widget_status, PrayerWidgetRefreshAction.pendingIntent(context))
        }
    }

    private fun bindActivePrayerAndHero(views: RemoteViews) {
        val currentDay = today
        val activePillId: Int
        val heroStatus: String
        val heroName: String
        val heroIcon: Int
        val heroTime: String

        if (currentDay == null) {
            heroStatus = labels.currentPrayer
            heroName = "—"
            heroIcon = R.drawable.ic_sun
            heroTime = "—"
            activePillId = R.id.col_dhuhr
        } else {
            when {
                now < currentDay.fajrUtcMillis -> {
                    heroStatus = labels.nextPrayer
                    heroName = labels.fajr
                    heroIcon = R.drawable.ic_crescent
                    heroTime = formatter.time(currentDay.fajrUtcMillis, labels.localeIdentifier)
                    activePillId = R.id.col_fajr
                }
                now < currentDay.sunriseUtcMillis -> {
                    heroStatus = labels.currentPrayer
                    heroName = labels.fajr
                    heroIcon = R.drawable.ic_crescent
                    heroTime = "${formatter.time(currentDay.fajrUtcMillis, labels.localeIdentifier)} – ${formatter.time(currentDay.sunriseUtcMillis, labels.localeIdentifier)}"
                    activePillId = R.id.col_fajr
                }
                now < currentDay.dhuhrUtcMillis -> {
                    heroStatus = labels.nextPrayer
                    heroName = labels.dhuhr
                    heroIcon = R.drawable.ic_sun
                    heroTime = formatter.time(currentDay.dhuhrUtcMillis, labels.localeIdentifier)
                    activePillId = R.id.col_dhuhr
                }
                now < currentDay.asrUtcMillis -> {
                    heroStatus = labels.currentPrayer
                    heroName = labels.dhuhr
                    heroIcon = R.drawable.ic_sun
                    heroTime = "${formatter.time(currentDay.dhuhrUtcMillis, labels.localeIdentifier)} – ${formatter.time(currentDay.asrUtcMillis, labels.localeIdentifier)}"
                    activePillId = R.id.col_dhuhr
                }
                now < currentDay.maghribUtcMillis -> {
                    heroStatus = labels.currentPrayer
                    heroName = labels.asr
                    heroIcon = R.drawable.ic_sun
                    heroTime = "${formatter.time(currentDay.asrUtcMillis, labels.localeIdentifier)} – ${formatter.time(currentDay.maghribUtcMillis, labels.localeIdentifier)}"
                    activePillId = R.id.col_asr
                }
                now < currentDay.ishaUtcMillis -> {
                    heroStatus = labels.currentPrayer
                    heroName = labels.maghrib
                    heroIcon = R.drawable.ic_sunset
                    heroTime = "${formatter.time(currentDay.maghribUtcMillis, labels.localeIdentifier)} – ${formatter.time(currentDay.ishaUtcMillis, labels.localeIdentifier)}"
                    activePillId = R.id.col_maghrib
                }
                else -> {
                    heroStatus = labels.currentPrayer
                    heroName = labels.isha
                    heroIcon = R.drawable.ic_crescent
                    val ishaEnd = currentDay.ishaEndUtcMillis
                    heroTime = if (ishaEnd != null) {
                        "${formatter.time(currentDay.ishaUtcMillis, labels.localeIdentifier)} – ${formatter.time(ishaEnd, labels.localeIdentifier)}"
                    } else {
                        formatter.time(currentDay.ishaUtcMillis, labels.localeIdentifier)
                    }
                    activePillId = R.id.col_isha
                }
            }
        }

        views.setTextViewText(R.id.hero_status_label, heroStatus)
        views.setTextViewText(R.id.hero_prayer_name, heroName)
        views.setImageViewResource(R.id.hero_prayer_icon, heroIcon)
        views.setTextViewText(R.id.hero_prayer_time, heroTime)

        // Highlight active prayer pill and set neutral pill background for inactive ones
        val allPills = listOf(R.id.col_fajr, R.id.col_dhuhr, R.id.col_asr, R.id.col_maghrib, R.id.col_isha)
        for (pillId in allPills) {
            val bg = if (pillId == activePillId) R.drawable.prayer_widget_active_pill else R.drawable.prayer_widget_inactive_pill
            views.setInt(pillId, "setBackgroundResource", bg)
        }
    }
}

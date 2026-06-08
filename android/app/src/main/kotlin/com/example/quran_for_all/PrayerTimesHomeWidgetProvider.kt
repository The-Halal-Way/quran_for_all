package com.example.quran_for_all

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.text.format.DateUtils
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

class PrayerTimesHomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            appWidgetManager.updateAppWidget(
                widgetId,
                buildRemoteViews(context, widgetData),
            )
        }
    }

    private fun buildRemoteViews(
        context: Context,
        widgetData: SharedPreferences,
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.prayer_times_home_widget)
        val launchIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.widget_container, launchIntent)

        val snapshotRaw = widgetData.getString(SNAPSHOT_KEY, null)
        if (snapshotRaw.isNullOrBlank()) {
            applyEmptyState(views, "Open the app to sync your next 30 days of prayer times.")
            return views
        }

        return try {
            bindSnapshot(views, Snapshot.fromJson(snapshotRaw))
            views
        } catch (_: Exception) {
            applyEmptyState(views, "Prayer times will appear after the next successful sync.")
            views
        }
    }

    private fun bindSnapshot(views: RemoteViews, snapshot: Snapshot) {
        val timeZone = TimeZone.getTimeZone(snapshot.timeZoneId)
        val nowUtcMillis = System.currentTimeMillis()
        val todayKey = dateKey(nowUtcMillis, timeZone)
        val today = snapshot.days.firstOrNull { it.localDateKey == todayKey } ?: snapshot.days.firstOrNull()

        if (today == null) {
            applyEmptyState(views, "Prayer times are still syncing.")
            return
        }

        val nextPrayer = findNextPrayer(snapshot.days, nowUtcMillis)
        views.setTextViewText(R.id.widget_location, snapshot.locationLabel.ifBlank { "Prayer Times" })
        views.setTextViewText(R.id.widget_date, formatDate(today.localDateKey, timeZone))
        views.setTextViewText(
            R.id.widget_next_value,
            nextPrayer?.let { "${it.label} ${formatTime(it.utcMillis, timeZone)}" } ?: "All prayers completed",
        )
        views.setTextViewText(
            R.id.widget_sync,
            snapshot.lastSuccessfulSyncAtUtcMillis?.let {
                "Synced ${DateUtils.getRelativeTimeSpanString(it, nowUtcMillis, DateUtils.MINUTE_IN_MILLIS)}"
            } ?: "Offline snapshot",
        )

        views.setTextViewText(R.id.prayer_fajr_value, formatTime(today.fajrUtcMillis, timeZone))
        views.setTextViewText(R.id.prayer_sunrise_value, formatTime(today.sunriseUtcMillis, timeZone))
        views.setTextViewText(R.id.prayer_dhuhr_value, formatTime(today.dhuhrUtcMillis, timeZone))
        views.setTextViewText(R.id.prayer_asr_value, formatTime(today.asrUtcMillis, timeZone))
        views.setTextViewText(R.id.prayer_maghrib_value, formatTime(today.maghribUtcMillis, timeZone))
        views.setTextViewText(R.id.prayer_isha_value, formatTime(today.ishaUtcMillis, timeZone))
    }

    private fun applyEmptyState(views: RemoteViews, message: String) {
        views.setTextViewText(R.id.widget_location, "Prayer Times")
        views.setTextViewText(R.id.widget_date, "Waiting for snapshot")
        views.setTextViewText(R.id.widget_next_value, message)
        views.setTextViewText(R.id.widget_sync, "")
        views.setTextViewText(R.id.prayer_fajr_value, "--")
        views.setTextViewText(R.id.prayer_sunrise_value, "--")
        views.setTextViewText(R.id.prayer_dhuhr_value, "--")
        views.setTextViewText(R.id.prayer_asr_value, "--")
        views.setTextViewText(R.id.prayer_maghrib_value, "--")
        views.setTextViewText(R.id.prayer_isha_value, "--")
    }

    private fun findNextPrayer(days: List<PrayerDaySnapshot>, nowUtcMillis: Long): PrayerMoment? {
        val orderedLabels = listOf(
            "Fajr" to PrayerDaySnapshot::fajrUtcMillis,
            "Dhuhr" to PrayerDaySnapshot::dhuhrUtcMillis,
            "Asr" to PrayerDaySnapshot::asrUtcMillis,
            "Maghrib" to PrayerDaySnapshot::maghribUtcMillis,
            "Isha" to PrayerDaySnapshot::ishaUtcMillis,
        )

        days.sortedBy { it.localDateKey }.forEach { day ->
            orderedLabels.forEach { (label, millisProvider) ->
                val prayerTimeUtcMillis = millisProvider(day)
                if (prayerTimeUtcMillis > nowUtcMillis) {
                    return PrayerMoment(label, prayerTimeUtcMillis)
                }
            }
        }

        return null
    }

    private fun formatTime(utcMillis: Long, timeZone: TimeZone): String {
        return SimpleDateFormat("h:mm a", Locale.getDefault()).run {
            this.timeZone = timeZone
            format(Date(utcMillis))
        }
    }

    private fun formatDate(localDateKey: String, timeZone: TimeZone): String {
        val parser = SimpleDateFormat("yyyy-MM-dd", Locale.US)
        parser.timeZone = timeZone
        val date = parser.parse(localDateKey) ?: return localDateKey
        return SimpleDateFormat("EEE, MMM d", Locale.getDefault()).run {
            this.timeZone = timeZone
            format(date)
        }
    }

    private fun dateKey(utcMillis: Long, timeZone: TimeZone): String {
        return SimpleDateFormat("yyyy-MM-dd", Locale.US).run {
            this.timeZone = timeZone
            format(Date(utcMillis))
        }
    }

    private data class PrayerMoment(
        val label: String,
        val utcMillis: Long,
    )

    private data class Snapshot(
        val timeZoneId: String,
        val locationLabel: String,
        val lastSuccessfulSyncAtUtcMillis: Long?,
        val days: List<PrayerDaySnapshot>,
    ) {
        companion object {
            fun fromJson(raw: String): Snapshot {
                val json = JSONObject(raw)
                return Snapshot(
                    timeZoneId = json.optString("timeZoneId").ifBlank {
                        TimeZone.getDefault().id
                    },
                    locationLabel = json.optString("locationLabel"),
                    lastSuccessfulSyncAtUtcMillis =
                        json.takeIf { !it.isNull("lastSuccessfulSyncAtUtcMillis") }
                            ?.optLong("lastSuccessfulSyncAtUtcMillis"),
                    days = parseDays(json.optJSONArray("days") ?: JSONArray()),
                )
            }

            private fun parseDays(days: JSONArray): List<PrayerDaySnapshot> {
                return buildList {
                    for (index in 0 until days.length()) {
                        val day = days.optJSONObject(index) ?: continue
                        add(
                            PrayerDaySnapshot(
                                localDateKey = day.optString("localDateKey"),
                                fajrUtcMillis = day.optLong("fajrUtcMillis"),
                                sunriseUtcMillis = day.optLong("sunriseUtcMillis"),
                                dhuhrUtcMillis = day.optLong("dhuhrUtcMillis"),
                                asrUtcMillis = day.optLong("asrUtcMillis"),
                                maghribUtcMillis = day.optLong("maghribUtcMillis"),
                                ishaUtcMillis = day.optLong("ishaUtcMillis"),
                            )
                        )
                    }
                }
            }
        }
    }

    private data class PrayerDaySnapshot(
        val localDateKey: String,
        val fajrUtcMillis: Long,
        val sunriseUtcMillis: Long,
        val dhuhrUtcMillis: Long,
        val asrUtcMillis: Long,
        val maghribUtcMillis: Long,
        val ishaUtcMillis: Long,
    )

    private companion object {
        const val SNAPSHOT_KEY = "prayer_times_widget_snapshot"
    }
}
package com.example.quran_for_all.prayerwidget

import android.content.Context
import android.os.Build
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import com.example.quran_for_all.MainActivity
import com.example.quran_for_all.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.TimeZone

data class PrayerFocusState(
    val statusLabel: String,
    val prayerName: String,
    val iconRes: Int,
    val timeRange: String,
    val timerLabel: String,
    val targetUtcMillis: Long,
)

class PrayerWidgetFocusRenderer(
    private val context: Context,
    private val snapshot: PrayerWidgetSnapshot?,
    private val now: Long = System.currentTimeMillis(),
    private val elapsedRealtime: Long = SystemClock.elapsedRealtime(),
) {
    private val formatter = PrayerWidgetDateFormatter(
        snapshot?.timeZoneId?.let(TimeZone::getTimeZone) ?: TimeZone.getDefault()
    )
    private val labels = snapshot?.labels ?: PrayerWidgetLabels.english
    private val data = HomeWidgetPlugin.getData(context)
    private val refreshing = data.getLong(PrayerWidgetRefreshAction.BUSY_KEY, 0L) > now
    private val failed = data.getBoolean(PrayerWidgetRefreshAction.ERROR_KEY, false)

    fun todayDay(): PrayerWidgetDay? =
        snapshot?.days?.firstOrNull { it.localDateKey == formatter.dateKey(now) }

    fun nextTransitionUtcMillis(): Long? = resolveFocusState(snapshot, now, formatter, labels)?.targetUtcMillis

    fun render(compact: Boolean, elderly: Boolean = false): RemoteViews {
        val layout = when {
            elderly && compact -> R.layout.prayer_times_focus_elderly_widget_compact
            elderly -> R.layout.prayer_times_focus_elderly_widget
            compact -> R.layout.prayer_times_focus_widget_compact
            else -> R.layout.prayer_times_focus_widget
        }
        val today = todayDay()
        val focus = resolveFocusState(snapshot, now, formatter, labels)

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

            // Dates
            setTextViewText(R.id.focus_date, formatter.date(now, labels.localeIdentifier))
            setTextViewText(
                R.id.focus_hijri_date,
                today?.hijriDateLabel?.takeIf(String::isNotBlank) ?: labels.hijriDatePlaceholder,
            )

            // Celestial & Fasting 3-column strip: Sehri End | Sunrise | Iftar
            setTextViewText(R.id.focus_sehri_label, labels.sehriEnd)
            setTextViewText(R.id.focus_sehri_value, formatter.time(today?.sehriEndUtcMillis, labels.localeIdentifier))
            setTextViewText(R.id.focus_sunrise_label, labels.sunrise.uppercase())
            setTextViewText(R.id.focus_sunrise_value, formatter.time(today?.sunriseUtcMillis, labels.localeIdentifier))
            setTextViewText(R.id.focus_iftar_label, labels.iftar)
            setTextViewText(R.id.focus_iftar_value, formatter.time(today?.maghribUtcMillis, labels.localeIdentifier))

            // Hero & Countdown Timer
            if (focus != null) {
                setTextViewText(R.id.focus_status_label, focus.statusLabel)
                setTextViewText(R.id.focus_prayer_name, focus.prayerName)
                setImageViewResource(R.id.focus_prayer_icon, focus.iconRes)
                setTextViewText(R.id.focus_prayer_time, focus.timeRange)
                setTextViewText(R.id.focus_timer_label, focus.timerLabel)

                val remaining = (focus.targetUtcMillis - now).coerceAtLeast(0L)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    setViewVisibility(R.id.focus_timer_chronometer, View.VISIBLE)
                    setViewVisibility(R.id.focus_timer_fallback, View.GONE)
                    setChronometerCountDown(R.id.focus_timer_chronometer, true)
                    setChronometer(R.id.focus_timer_chronometer, elapsedRealtime + remaining, null, true)
                } else {
                    setViewVisibility(R.id.focus_timer_chronometer, View.GONE)
                    setViewVisibility(R.id.focus_timer_fallback, View.VISIBLE)
                    setTextViewText(R.id.focus_timer_fallback, formatRemaining(remaining))
                }
            } else {
                setTextViewText(R.id.focus_status_label, labels.currentPrayer)
                setTextViewText(R.id.focus_prayer_name, "—")
                setImageViewResource(R.id.focus_prayer_icon, R.drawable.ic_sun)
                setTextViewText(R.id.focus_prayer_time, "—")
                setTextViewText(R.id.focus_timer_label, labels.waqtEndsIn)
                setViewVisibility(R.id.focus_timer_chronometer, View.GONE)
                setViewVisibility(R.id.focus_timer_fallback, View.VISIBLE)
                setTextViewText(R.id.focus_timer_fallback, "—")
            }

            setTextViewText(R.id.widget_status, if (failed) labels.refreshFailed else labels.openToSync)
            setViewVisibility(R.id.widget_status, if ((today == null || failed) && !compact) View.VISIBLE else View.GONE)
            setOnClickPendingIntent(R.id.widget_status, PrayerWidgetRefreshAction.pendingIntent(context))
        }
    }

    companion object {
        fun resolveFocusState(
            snapshot: PrayerWidgetSnapshot?,
            now: Long,
            formatter: PrayerWidgetDateFormatter,
            labels: PrayerWidgetLabels,
        ): PrayerFocusState? {
            val days = snapshot?.days ?: return null
            val todayKey = formatter.dateKey(now)
            val todayIndex = days.indexOfFirst { it.localDateKey == todayKey }
            if (todayIndex < 0) return null
            val today = days[todayIndex]
            val yesterday = if (todayIndex > 0) days[todayIndex - 1] else null
            val tomorrow = if (todayIndex + 1 < days.size) days[todayIndex + 1] else null

            return when {
                now < today.fajrUtcMillis -> PrayerFocusState(
                    statusLabel = labels.currentPrayer,
                    prayerName = labels.isha,
                    iconRes = R.drawable.ic_crescent,
                    timeRange = if (yesterday != null) {
                        formatter.range(yesterday.ishaUtcMillis, today.fajrUtcMillis, labels.localeIdentifier, false)
                    } else {
                        formatter.time(today.fajrUtcMillis, labels.localeIdentifier)
                    },
                    timerLabel = labels.waqtEndsIn,
                    targetUtcMillis = today.fajrUtcMillis,
                )
                now < today.sunriseUtcMillis -> PrayerFocusState(
                    statusLabel = labels.currentPrayer,
                    prayerName = labels.fajr,
                    iconRes = R.drawable.ic_crescent,
                    timeRange = formatter.range(today.fajrUtcMillis, today.sunriseUtcMillis, labels.localeIdentifier, false),
                    timerLabel = labels.waqtEndsIn,
                    targetUtcMillis = today.sunriseUtcMillis,
                )
                now < today.dhuhrUtcMillis -> PrayerFocusState(
                    statusLabel = labels.nextPrayer,
                    prayerName = labels.dhuhr,
                    iconRes = R.drawable.ic_sun,
                    timeRange = formatter.range(today.dhuhrUtcMillis, today.asrUtcMillis, labels.localeIdentifier, false),
                    timerLabel = labels.startsIn,
                    targetUtcMillis = today.dhuhrUtcMillis,
                )
                now < today.asrUtcMillis -> PrayerFocusState(
                    statusLabel = labels.currentPrayer,
                    prayerName = labels.dhuhr,
                    iconRes = R.drawable.ic_sun,
                    timeRange = formatter.range(today.dhuhrUtcMillis, today.asrUtcMillis, labels.localeIdentifier, false),
                    timerLabel = labels.waqtEndsIn,
                    targetUtcMillis = today.asrUtcMillis,
                )
                now < today.maghribUtcMillis -> PrayerFocusState(
                    statusLabel = labels.currentPrayer,
                    prayerName = labels.asr,
                    iconRes = R.drawable.ic_sun,
                    timeRange = formatter.range(today.asrUtcMillis, today.maghribUtcMillis, labels.localeIdentifier, false),
                    timerLabel = labels.waqtEndsIn,
                    targetUtcMillis = today.maghribUtcMillis,
                )
                now < today.ishaUtcMillis -> PrayerFocusState(
                    statusLabel = labels.currentPrayer,
                    prayerName = labels.maghrib,
                    iconRes = R.drawable.ic_sunset,
                    timeRange = formatter.range(today.maghribUtcMillis, today.ishaUtcMillis, labels.localeIdentifier, false),
                    timerLabel = labels.waqtEndsIn,
                    targetUtcMillis = today.ishaUtcMillis,
                )
                else -> {
                    val end = today.ishaEndUtcMillis
                        ?: tomorrow?.fajrUtcMillis
                        ?: (today.fajrUtcMillis + 86_400_000L)
                    PrayerFocusState(
                        statusLabel = labels.currentPrayer,
                        prayerName = labels.isha,
                        iconRes = R.drawable.ic_crescent,
                        timeRange = formatter.range(today.ishaUtcMillis, end, labels.localeIdentifier, false),
                        timerLabel = labels.waqtEndsIn,
                        targetUtcMillis = end,
                    )
                }
            }
        }

        fun formatRemaining(remainingMillis: Long): String {
            val totalMinutes = (remainingMillis / 60_000L).coerceAtLeast(0L)
            val hours = totalMinutes / 60L
            val minutes = totalMinutes % 60L
            return when {
                hours > 0 -> "${hours}h ${minutes}m"
                minutes > 0 -> "${minutes}m"
                else -> "< 1m"
            }
        }
    }
}

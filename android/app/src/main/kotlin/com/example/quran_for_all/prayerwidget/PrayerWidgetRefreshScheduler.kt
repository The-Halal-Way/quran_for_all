package com.example.quran_for_all.prayerwidget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.example.quran_for_all.PrayerTimesHomeWidgetProvider
import java.util.Calendar
import java.util.TimeZone

/** Re-render the stored offline schedule at the next local day boundary. */
object PrayerWidgetRefreshScheduler {
    const val ACTION_REFRESH = "com.example.quran_for_all.REFRESH_PRAYER_WIDGET"

    fun schedule(context: Context, timeZoneId: String?) {
        val zone = timeZoneId?.let(TimeZone::getTimeZone) ?: TimeZone.getDefault()
        val next = Calendar.getInstance(zone).apply {
            add(Calendar.DAY_OF_MONTH, 1)
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        // Inexact by design: no exact-alarm permission or wake lock required.
        manager(context).set(AlarmManager.RTC, next.timeInMillis, intent(context))
    }

    fun cancel(context: Context) = manager(context).cancel(intent(context))

    private fun manager(context: Context) = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    private fun intent(context: Context) = PendingIntent.getBroadcast(
        context, 0,
        Intent(context, PrayerTimesHomeWidgetProvider::class.java).setAction(ACTION_REFRESH),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )
}

package com.example.quran_for_all.prayerwidget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.quran_for_all.PrayerTimesFocusHomeWidgetProvider

/** Schedules a refresh right after the active prayer/waqt window transitions. */
object PrayerFocusWidgetScheduler {
    const val ACTION_REFRESH = "com.example.quran_for_all.REFRESH_FOCUS_WIDGET"

    fun schedule(context: Context, triggerAtUtcMillis: Long?) {
        if (triggerAtUtcMillis == null) return
        val trigger = triggerAtUtcMillis + 1_000L
        val alarmManager = manager(context)
        val pending = intent(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC, trigger, pending)
        } else {
            alarmManager.set(AlarmManager.RTC, trigger, pending)
        }
    }

    fun cancel(context: Context) = manager(context).cancel(intent(context))

    private fun manager(context: Context) = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    private fun intent(context: Context) = PendingIntent.getBroadcast(
        context,
        1,
        Intent(context, PrayerTimesFocusHomeWidgetProvider::class.java).setAction(ACTION_REFRESH),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )
}

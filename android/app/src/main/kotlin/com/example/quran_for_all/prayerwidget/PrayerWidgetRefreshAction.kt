package com.example.quran_for_all.prayerwidget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import com.example.quran_for_all.MainActivity
import com.example.quran_for_all.PrayerTimesHomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

object PrayerWidgetRefreshAction {
    const val ACTION = "com.example.quran_for_all.USER_REFRESH_PRAYER_WIDGET"
    const val TIMEOUT = "com.example.quran_for_all.PRAYER_WIDGET_REFRESH_TIMEOUT"
    const val BUSY_KEY = "prayer_widget_refreshing_until"
    const val ERROR_KEY = "prayer_widget_refresh_error"

    fun pendingIntent(context: Context): PendingIntent = PendingIntent.getBroadcast(
        context, 10,
        Intent(context, PrayerTimesHomeWidgetProvider::class.java).setAction(ACTION),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

    fun start(context: Context) {
        val data = HomeWidgetPlugin.getData(context)
        if (data.getLong(BUSY_KEY, 0L) > System.currentTimeMillis()) return
        if (data.getString("prayer_times_widget_snapshot", null).isNullOrEmpty() ||
            HomeWidgetPlugin.getDispatcherHandle(context) == 0L) {
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java).send()
            return
        }
        val until = System.currentTimeMillis() + 45_000L
        data.edit().putLong(BUSY_KEY, until).putBoolean(ERROR_KEY, false).apply()
        // Prevent a stuck spinner if Android delays or interrupts the worker.
        alarm(context).set(AlarmManager.RTC, until, timeoutIntent(context))
        try {
            HomeWidgetBackgroundIntent.getBroadcast(
                context, Uri.parse("quranforall://prayer-widget/refresh"),
            ).send()
        } catch (_: Exception) {
            data.edit().remove(BUSY_KEY).putBoolean(ERROR_KEY, true).apply()
        }
    }

    fun timeout(context: Context) {
        val data = HomeWidgetPlugin.getData(context)
        val until = data.getLong(BUSY_KEY, 0L)
        if (until != 0L && until <= System.currentTimeMillis()) {
            data.edit().remove(BUSY_KEY).putBoolean(ERROR_KEY, true).apply()
        }
    }

    fun cancel(context: Context) = alarm(context).cancel(timeoutIntent(context))

    private fun alarm(context: Context) = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    private fun timeoutIntent(context: Context) = PendingIntent.getBroadcast(
        context, 11,
        Intent(context, PrayerTimesHomeWidgetProvider::class.java).setAction(TIMEOUT),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )
}

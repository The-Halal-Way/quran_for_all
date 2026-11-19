package com.example.quran_for_all

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.ComponentName
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.widget.RemoteViews
import com.example.quran_for_all.prayerwidget.PrayerWidgetRenderer
import com.example.quran_for_all.prayerwidget.PrayerWidgetSnapshot
import com.example.quran_for_all.prayerwidget.PrayerWidgetRefreshScheduler
import com.example.quran_for_all.prayerwidget.PrayerWidgetRefreshAction
import es.antonborri.home_widget.HomeWidgetProvider

class PrayerTimesHomeWidgetProvider : HomeWidgetProvider() {
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == PrayerWidgetRefreshAction.ACTION) PrayerWidgetRefreshAction.start(context)
        if (intent.action == PrayerWidgetRefreshAction.TIMEOUT) PrayerWidgetRefreshAction.timeout(context)
        if (intent.action in setOf(
                PrayerWidgetRefreshScheduler.ACTION_REFRESH,
                PrayerWidgetRefreshAction.ACTION, PrayerWidgetRefreshAction.TIMEOUT,
                Intent.ACTION_DATE_CHANGED, Intent.ACTION_TIME_CHANGED,
                Intent.ACTION_TIMEZONE_CHANGED, Intent.ACTION_BOOT_COMPLETED,
                Intent.ACTION_MY_PACKAGE_REPLACED, Intent.ACTION_LOCALE_CHANGED,
            )) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, javaClass))
            if (ids.isNotEmpty()) onUpdate(context, manager, ids)
        }
    }

    override fun onDisabled(context: Context) {
        PrayerWidgetRefreshScheduler.cancel(context)
        PrayerWidgetRefreshAction.cancel(context)
        super.onDisabled(context)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val snapshot = widgetData.getString(SNAPSHOT_KEY, null)?.let {
            runCatching { PrayerWidgetSnapshot.fromJson(it) }.getOrNull()
        }
        val renderer = PrayerWidgetRenderer(context, snapshot)
        appWidgetIds.forEach { widgetId ->
            val views = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                RemoteViews(
                    mapOf(
                        SizeF(240f, 180f) to renderer.render(compact = true),
                        SizeF(240f, 300f) to renderer.render(compact = false),
                    )
                )
            } else {
                val height = appWidgetManager.getAppWidgetOptions(widgetId)
                    .getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 300)
                renderer.render(compact = height < 300)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
        if (appWidgetIds.isNotEmpty()) PrayerWidgetRefreshScheduler.schedule(context, snapshot?.timeZoneId)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
    }

    private companion object {
        const val SNAPSHOT_KEY = "prayer_times_widget_snapshot"
    }
}

package com.example.quran_for_all

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.widget.RemoteViews
import com.example.quran_for_all.prayerwidget.PrayerWidgetRenderer
import com.example.quran_for_all.prayerwidget.PrayerWidgetSnapshot
import es.antonborri.home_widget.HomeWidgetProvider

class PrayerTimesHomeWidgetProvider : HomeWidgetProvider() {
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

package com.example.quran_for_all.prayerwidget

import org.json.JSONArray
import org.json.JSONObject
import java.util.TimeZone

data class PrayerWidgetSnapshot(
    val timeZoneId: String,
    val locationLabel: String,
    val days: List<PrayerWidgetDay>,
) {
    companion object {
        fun fromJson(raw: String): PrayerWidgetSnapshot {
            val json = JSONObject(raw)
            val days = json.optJSONArray("days") ?: JSONArray()
            return PrayerWidgetSnapshot(
                timeZoneId = json.optString("timeZoneId").ifBlank { TimeZone.getDefault().id },
                locationLabel = json.optString("locationLabel"),
                days = (0 until days.length()).map { PrayerWidgetDay.fromJson(days.getJSONObject(it)) },
            )
        }
    }
}

data class PrayerWidgetDay(
    val localDateKey: String,
    val hijriDateLabel: String?,
    val fajrUtcMillis: Long,
    val sunriseUtcMillis: Long,
    val dhuhrUtcMillis: Long,
    val asrUtcMillis: Long,
    val maghribUtcMillis: Long,
    val ishaUtcMillis: Long,
    val sehriEndUtcMillis: Long,
) {
    companion object {
        fun fromJson(json: JSONObject): PrayerWidgetDay {
            val fajr = json.getLong("fajrUtcMillis")
            return PrayerWidgetDay(
                localDateKey = json.getString("localDateKey"),
                hijriDateLabel = if (json.isNull("hijriDateLabel")) null else json.getString("hijriDateLabel"),
                fajrUtcMillis = fajr,
                sunriseUtcMillis = json.getLong("sunriseUtcMillis"),
                dhuhrUtcMillis = json.getLong("dhuhrUtcMillis"),
                asrUtcMillis = json.getLong("asrUtcMillis"),
                maghribUtcMillis = json.getLong("maghribUtcMillis"),
                ishaUtcMillis = json.getLong("ishaUtcMillis"),
                // Older snapshots used the app's default ten-minute precaution.
                sehriEndUtcMillis = if (json.isNull("sehriEndUtcMillis")) fajr - 10 * 60_000L
                    else json.getLong("sehriEndUtcMillis"),
            )
        }
    }
}

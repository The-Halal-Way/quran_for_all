package com.example.quran_for_all.prayerwidget

import org.json.JSONArray
import org.json.JSONObject
import java.util.TimeZone

data class PrayerWidgetSnapshot(
    val timeZoneId: String,
    val locationLabel: String,
    val days: List<PrayerWidgetDay>,
    val labels: PrayerWidgetLabels = PrayerWidgetLabels.english,
) {
    companion object {
        fun fromJson(raw: String): PrayerWidgetSnapshot {
            val json = JSONObject(raw)
            val days = json.optJSONArray("days") ?: JSONArray()
            return PrayerWidgetSnapshot(
                timeZoneId = json.optString("timeZoneId").ifBlank { TimeZone.getDefault().id },
                locationLabel = json.optString("locationLabel"),
                days = (0 until days.length()).map { PrayerWidgetDay.fromJson(days.getJSONObject(it)) },
                labels = PrayerWidgetLabels.fromJson(json.optJSONObject("labels")),
            )
        }
    }
}

data class PrayerWidgetLabels(
    val localeIdentifier: String,
    val appTitle: String,
    val hijriDatePlaceholder: String,
    val prayerTimes: String,
    val sehriEnd: String,
    val iftar: String,
    val openToSync: String,
    val tapToUpdate: String,
    val fajr: String,
    val sunrise: String,
    val dhuhr: String,
    val asr: String,
    val maghrib: String,
    val isha: String,
) {
    companion object {
        val english = PrayerWidgetLabels(
            localeIdentifier = "en_US",
            appTitle = "Muslim & Quran Pro",
            hijriDatePlaceholder = "Hijri date",
            prayerTimes = "PRAYER TIMES",
            sehriEnd = "SEHRI END",
            iftar = "IFTAR",
            openToSync = "Open the app to update today's times",
            tapToUpdate = "Tap to update",
            fajr = "Fajr",
            sunrise = "Sunrise",
            dhuhr = "Dhuhr",
            asr = "Asr",
            maghrib = "Maghrib",
            isha = "Isha",
        )

        private val bangla = english.copy(
            localeIdentifier = "bn_BD",
            appTitle = "মুসলিম ও কুরআন প্রো",
            hijriDatePlaceholder = "হিজরি তারিখ",
            prayerTimes = "নামাজের সময়",
            sehriEnd = "সেহরির শেষ",
            iftar = "ইফতার",
            openToSync = "আজকের সময় হালনাগাদ করতে অ্যাপ খুলুন",
            tapToUpdate = "হালনাগাদ করতে ট্যাপ করুন",
            fajr = "ফজর",
            sunrise = "সূর্যোদয়",
            dhuhr = "যোহর",
            asr = "আসর",
            maghrib = "মাগরিব",
            isha = "ইশা",
        )

        fun fromJson(json: JSONObject?): PrayerWidgetLabels {
            if (json == null) return english
            val fallback = if (json.optString("localeIdentifier").startsWith("bn")) bangla else english
            fun value(key: String, default: String): String =
                json.optString(key).ifBlank { default }

            return PrayerWidgetLabels(
                localeIdentifier = value("localeIdentifier", fallback.localeIdentifier),
                appTitle = value("appTitle", fallback.appTitle),
                hijriDatePlaceholder = value("hijriDatePlaceholder", fallback.hijriDatePlaceholder),
                prayerTimes = value("prayerTimes", fallback.prayerTimes),
                sehriEnd = value("sehriEnd", fallback.sehriEnd),
                iftar = value("iftar", fallback.iftar),
                openToSync = value("openToSync", fallback.openToSync),
                tapToUpdate = value("tapToUpdate", fallback.tapToUpdate),
                fajr = value("fajr", fallback.fajr),
                sunrise = value("sunrise", fallback.sunrise),
                dhuhr = value("dhuhr", fallback.dhuhr),
                asr = value("asr", fallback.asr),
                maghrib = value("maghrib", fallback.maghrib),
                isha = value("isha", fallback.isha),
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

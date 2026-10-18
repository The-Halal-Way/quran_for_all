package com.example.quran_for_all

import android.hardware.GeomagneticField
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var tasbeehHaptics: TasbeehHapticsChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        tasbeehHaptics?.dispose()
        tasbeehHaptics = TasbeehHapticsChannel(this, flutterEngine.dartExecutor.binaryMessenger)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "quran_for_all/compass")
            .setMethodCallHandler { call, result ->
                if (call.method != "declination") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val latitude = call.argument<Double>("latitude")
                val longitude = call.argument<Double>("longitude")
                val altitude = call.argument<Double>("altitude")
                if (latitude == null || longitude == null || altitude == null) {
                    result.error("bad_location", "Coordinates are required", null)
                    return@setMethodCallHandler
                }

                val field = GeomagneticField(
                    latitude.toFloat(),
                    longitude.toFloat(),
                    altitude.toFloat(),
                    System.currentTimeMillis(),
                )
                result.success(field.declination.toDouble())
            }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        tasbeehHaptics?.dispose()
        tasbeehHaptics = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}

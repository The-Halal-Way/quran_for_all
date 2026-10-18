package com.example.quran_for_all

import android.content.Context
import android.media.AudioAttributes
import android.os.Build
import android.os.VibrationAttributes
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** One sustained, full-amplitude completion alert with no generated audio. */
class TasbeehHapticsChannel(context: Context, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "quran_for_all/tasbeeh_haptics")
    private val vibrator: Vibrator? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        context.getSystemService(VibratorManager::class.java)?.defaultVibrator
    } else {
        @Suppress("DEPRECATION")
        context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
    }

    init {
        channel.setMethodCallHandler { call, result ->
            if (call.method != "targetReached") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val duration = (call.argument<Number>("durationMs")?.toLong() ?: 1500L)
                .coerceIn(1L, 1500L)
            try {
                result.success(play(duration))
            } catch (error: RuntimeException) {
                result.error("vibration_unavailable", error.message, null)
            }
        }
    }

    @Suppress("DEPRECATION")
    private fun play(duration: Long): Boolean {
        val motor = vibrator ?: return false
        if (!motor.hasVibrator()) return false
        motor.cancel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val effect = VibrationEffect.createOneShot(duration, 255)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                motor.vibrate(
                    effect,
                    VibrationAttributes.Builder()
                        .setUsage(VibrationAttributes.USAGE_NOTIFICATION)
                        .build(),
                )
            } else {
                motor.vibrate(
                    effect,
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
            }
        } else {
            motor.vibrate(duration)
        }
        return true
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        vibrator?.cancel()
    }
}

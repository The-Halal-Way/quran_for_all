import AudioToolbox
import CoreHaptics
import Flutter
import Foundation

/// Plays only the vibration motor; no audio events or repeated impact taps.
final class TasbeehHapticsChannel {
  private let channel: FlutterMethodChannel
  private var engine: CHHapticEngine?
  private var player: CHHapticPatternPlayer?

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "quran_for_all/tasbeeh_haptics",
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "targetReached" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let self = self else {
        result(false)
        return
      }
      let arguments = call.arguments as? [String: Any]
      let milliseconds = (arguments?["durationMs"] as? NSNumber)?.doubleValue ?? 1500
      let duration = min(max(milliseconds, 1), 1500) / 1000
      result(self.play(duration: duration))
    }
  }

  private func play(duration: TimeInterval) -> Bool {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      // Older iPhones can still provide one system vibration.
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      return true
    }
    do {
      let currentEngine: CHHapticEngine
      if let engine = engine {
        currentEngine = engine
      } else {
        currentEngine = try CHHapticEngine()
        currentEngine.playsHapticsOnly = true
        currentEngine.isAutoShutdownEnabled = true
        engine = currentEngine
      }
      try currentEngine.start()
      try? player?.stop(atTime: CHHapticTimeImmediate)
      let event = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),
        ],
        relativeTime: 0,
        duration: duration
      )
      let pattern = try CHHapticPattern(events: [event], parameters: [])
      let nextPlayer = try currentEngine.makePlayer(with: pattern)
      try nextPlayer.start(atTime: CHHapticTimeImmediate)
      player = nextPlayer
      return true
    } catch {
      player = nil
      engine = nil
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      return true
    }
  }

  deinit {
    channel.setMethodCallHandler(nil)
    try? player?.stop(atTime: CHHapticTimeImmediate)
    engine?.stop(completionHandler: nil)
  }
}

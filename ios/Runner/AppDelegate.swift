import Flutter
import CoreLocation
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var qiblaHeadingHandler: QiblaHeadingStreamHandler?
  private var qiblaHeadingChannel: FlutterEventChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    GeneratedPluginRegistrant.register(with: self)
    let controller = window?.rootViewController as! FlutterViewController
    let headingChannel = FlutterEventChannel(
      name: "quran_for_all/heading",
      binaryMessenger: controller.binaryMessenger
    )
    let handler = QiblaHeadingStreamHandler()
    headingChannel.setStreamHandler(handler)
    qiblaHeadingHandler = handler
    qiblaHeadingChannel = headingChannel
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/// Core Location provides a screen-oriented heading relative to true north.
final class QiblaHeadingStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  private var sink: FlutterEventSink?

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.headingFilter = 1
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard CLLocationManager.headingAvailable() else {
      return FlutterError(code: "no_compass", message: "Heading hardware is unavailable", details: nil)
    }
    sink = events
    updateHeadingOrientation()
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    locationManager.stopUpdatingHeading()
    locationManager.stopUpdatingLocation()
    sink = nil
    return nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
    updateHeadingOrientation()
    guard heading.headingAccuracy >= 0, heading.trueHeading >= 0 else { return }
    sink?(heading.trueHeading)
  }

  private func updateHeadingOrientation() {
    let orientation = windowOrientation()
    switch orientation {
    case .landscapeLeft: locationManager.headingOrientation = .landscapeLeft
    case .landscapeRight: locationManager.headingOrientation = .landscapeRight
    case .portraitUpsideDown: locationManager.headingOrientation = .portraitUpsideDown
    default: locationManager.headingOrientation = .portrait
    }
  }

  private func windowOrientation() -> UIInterfaceOrientation {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first?.interfaceOrientation ?? .portrait
  }
}

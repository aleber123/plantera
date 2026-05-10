import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PlanteraBadgeChannel") {
      let badgeChannel = FlutterMethodChannel(
        name: "com.alexanderbergqvist.plantera/badge",
        binaryMessenger: registrar.messenger()
      )
      badgeChannel.setMethodCallHandler { call, result in
        if call.method == "setBadge", let args = call.arguments as? [String: Any],
           let count = args["count"] as? Int {
          DispatchQueue.main.async {
            if #available(iOS 16.0, *) {
              UNUserNotificationCenter.current().setBadgeCount(count) { _ in }
            } else {
              UIApplication.shared.applicationIconBadgeNumber = count
            }
          }
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}

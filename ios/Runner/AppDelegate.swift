import UIKit
import Flutter
import Firebase // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // Add this initialization
    GeneratedPluginRegistrant.register(with: self)
    
    // OLED Black theme enforcement
    if #available(iOS 13.0, *) {
      self.window?.overrideUserInterfaceStyle = .dark
    }
    
    // Register for remote notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

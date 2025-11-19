import UIKit
import Flutter
import FirebaseCore
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA1rfRh5d0HM8hZ34eL8vjgaT2zC4Vtr7o")
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

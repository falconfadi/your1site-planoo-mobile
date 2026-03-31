import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCK5k9cVEE5aQZ4yfQ_qN1yWX9j9-e6_SA")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

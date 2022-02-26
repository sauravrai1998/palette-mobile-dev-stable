import UIKit
import Flutter
import Firebase
import Pendo

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options:  [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if((url.scheme?.contains("pendo")) != nil) {
            PendoManager.shared().initWith(url)
        }
        return true
    }
}

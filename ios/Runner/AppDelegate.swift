import UIKit
import Flutter
import Contacts

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

         let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
         let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
         channel.setMethodCallHandler({
             [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
             // Handle the method calls from Flutter here
             if call.method == "pickImage" {
                 // Your code for picking an image here
                 // Example: use the image_picker package
             } else if call.method == "pickContact" {
                 // Your code for picking a contact here
                 // Example: use the contacts package
             } else {
                 result(FlutterMethodNotImplemented)
             }
         })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

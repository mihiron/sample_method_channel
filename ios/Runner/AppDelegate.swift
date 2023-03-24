import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller :FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.example.app/methods",binaryMessenger: controller.binaryMessenger)
      
      channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
          switch(call.method) {
          case "mySwiftMethod":
              NSLog("swift  : arguments: " + (call.arguments as? String ?? ""))
              result("called from Flutter!")
          default:
              result("No Method")
          }
          
          self.callFlutterMethod()
      })

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func callFlutterMethod(){
        let controller :FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.app/methods",binaryMessenger: controller.binaryMessenger)
        
        // Flutte側のメソッドを呼び出し
        channel.invokeMethod("myFlutterMethod", arguments: "Hello Flutter! by Swift"){ result in
            if let response = result as? String {
                NSLog("swift  : result: " + response)
            } else if let error = result as? FlutterError {
                NSLog("swift  :Error processing result: \(error)")
            } else {
                NSLog("swift  :Unknown error processing result")
            }
        }
    }
}

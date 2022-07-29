import Flutter
import UIKit

public class SwiftInfinityCorePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "infinity_core", binaryMessenger: registrar.messenger())
        let instance = SwiftInfinityCorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion": result(getPlatformVersion())
        case "getDeviceId": result(getDeviceId())
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func getPlatformVersion() -> String {
        "iOS " + UIDevice.current.systemVersion
    }
    
    private func getDeviceId() -> String? {
        UIDevice.current.identifierForVendor?.uuidString
    }
}

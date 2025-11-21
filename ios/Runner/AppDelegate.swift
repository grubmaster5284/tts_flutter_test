import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    // Set up method channels after engine is ready
    guard let controller = window?.rootViewController as? FlutterViewController else {
      // If window is not available, set up channels when it becomes available
      DispatchQueue.main.async { [weak self] in
        self?.setupMethodChannels()
      }
      return result
    }
    
    setupMethodChannels(controller: controller)
    return result
  }
  
  private func setupMethodChannels() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("Warning: Could not get FlutterViewController")
      return
    }
    setupMethodChannels(controller: controller)
  }
  
  private func setupMethodChannels(controller: FlutterViewController) {
    // Set up method channel for TTS Python scripts
    let ttsChannel = FlutterMethodChannel(
      name: "com.tts_flutter_test/tts_script",
      binaryMessenger: controller.binaryMessenger
    )
    
    ttsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      print("TTS Channel: Received method call: \(call.method)")
      if call.method == "synthesizeSpeech" {
        // iOS cannot execute Python scripts directly due to sandboxing
        // Return an error indicating this limitation
        result(FlutterError(
          code: "PLATFORM_NOT_SUPPORTED",
          message: "Python script execution is not supported on iOS. Please use the remote API service instead.",
          details: nil
        ))
      } else {
        print("TTS Channel: Unknown method: \(call.method)")
        result(FlutterMethodNotImplemented)
      }
    }
    
    print("Method channels set up successfully for iOS")
    print("TTS Channel name: com.tts_flutter_test/tts_script")
  }
}

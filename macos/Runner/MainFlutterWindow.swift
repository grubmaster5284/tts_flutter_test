import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    
    // Set up method channels
    setupMethodChannels(controller: flutterViewController)

    super.awakeFromNib()
  }
  
  private func setupMethodChannels(controller: FlutterViewController) {
    // Get AppDelegate to set up channels
    guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else {
      print("Warning: Could not get AppDelegate")
      return
    }
    
    // Set up method channel for volume keys
    let volumeKeyChannel = FlutterMethodChannel(
      name: "com.tts_flutter_test/volume_keys",
      binaryMessenger: controller.engine.binaryMessenger
    )
    
    volumeKeyChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "startListening" {
        appDelegate.startVolumeKeyMonitoring()
        result(nil)
      } else if call.method == "stopListening" {
        appDelegate.stopVolumeKeyMonitoring()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    // [LEGACY] Old TTS platform channel - commented out for rollback
    // This channel handler was used for Python script execution via platform channels.
    // The app now uses pure Dart TTS services that make direct HTTP calls to TTS APIs.
    // To rollback: uncomment the code below
    /*
    // Set up method channel for TTS Python scripts
    let ttsChannel = FlutterMethodChannel(
      name: "com.tts_flutter_test/tts_script",
      binaryMessenger: controller.engine.binaryMessenger
    )
    
    ttsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      print("TTS Channel: Received method call: \(call.method)")
      if call.method == "synthesizeSpeech" {
        print("TTS Channel: Executing synthesizeSpeech")
        appDelegate.executeTTSScript(call: call, result: result)
      } else {
        print("TTS Channel: Unknown method: \(call.method)")
        result(FlutterMethodNotImplemented)
      }
    }
    */
    
    // [NEW] No TTS platform channel needed
    // The app now uses pure Dart TTS services that work on all platforms
    // All TTS operations are handled in Dart code via direct HTTP calls to TTS APIs
    
    // Store volume key channel in AppDelegate (volume keys are still used)
    appDelegate.setChannels(volumeKey: volumeKeyChannel, tts: nil)
    
    print("Method channels set up successfully")
    // [LEGACY] TTS Channel name: com.tts_flutter_test/tts_script (no longer used)
  }
}

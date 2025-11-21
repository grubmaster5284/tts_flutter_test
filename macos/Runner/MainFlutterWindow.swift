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
    
    // Store channels in AppDelegate
    appDelegate.setChannels(volumeKey: volumeKeyChannel, tts: ttsChannel)
    
    print("Method channels set up successfully")
    print("TTS Channel name: com.tts_flutter_test/tts_script")
  }
}

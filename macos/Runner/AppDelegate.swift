import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var volumeKeyChannel: FlutterMethodChannel?
  private var volumeKeyMonitor: Any?
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    
    // Set up method channel for volume keys
    guard let controller = mainFlutterWindow?.contentViewController as? FlutterViewController else {
      return
    }
    
    volumeKeyChannel = FlutterMethodChannel(
      name: "com.tts_flutter_test/volume_keys",
      binaryMessenger: controller.engine.binaryMessenger
    )
    
    volumeKeyChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "startListening" {
        self?.startVolumeKeyMonitoring()
        result(nil)
      } else if call.method == "stopListening" {
        self?.stopVolumeKeyMonitoring()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func startVolumeKeyMonitoring() {
    // Use NSEvent to monitor special keys
    // Note: Volume keys on macOS are system-level and may not always be interceptable
    // This is a best-effort implementation
    volumeKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .systemDefined]) { [weak self] event in
      // Check for volume keys
      // Volume keys can be detected via system-defined events or key codes
      let keyCode = event.keyCode
      
      // System-defined events for volume keys
      // NX_KEYTYPE_SOUND_UP = 0, NX_KEYTYPE_SOUND_DOWN = 1
      if event.type == .systemDefined {
        let systemKeyCode = (event.data1 & 0xFFFF0000) >> 16
        if systemKeyCode == 0 { // Volume up
          self?.volumeKeyChannel?.invokeMethod("volumeKeyPressed", arguments: true)
          return nil // Consume the event
        } else if systemKeyCode == 1 { // Volume down
          self?.volumeKeyChannel?.invokeMethod("volumeKeyPressed", arguments: false)
          return nil // Consume the event
        }
      }
      
      // Fallback: Check for F11/F12 (volume down/up on some keyboards)
      // F11 = 122 (volume down), F12 = 120 (volume up)
      // Note: These may be intercepted by the system before reaching the app
      if keyCode == 122 {
        // Volume down
        self?.volumeKeyChannel?.invokeMethod("volumeKeyPressed", arguments: false)
        return nil // Consume the event
      } else if keyCode == 120 {
        // Volume up
        self?.volumeKeyChannel?.invokeMethod("volumeKeyPressed", arguments: true)
        return nil // Consume the event
      }
      
      return event
    }
  }
  
  private func stopVolumeKeyMonitoring() {
    if let monitor = volumeKeyMonitor {
      NSEvent.removeMonitor(monitor)
      volumeKeyMonitor = nil
    }
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

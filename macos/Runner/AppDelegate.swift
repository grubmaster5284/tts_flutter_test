import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  var volumeKeyChannel: FlutterMethodChannel?
  var ttsChannel: FlutterMethodChannel?
  private var volumeKeyMonitor: Any?
  
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
  }
  
  func setChannels(volumeKey: FlutterMethodChannel, tts: FlutterMethodChannel) {
    self.volumeKeyChannel = volumeKey
    self.ttsChannel = tts
  }
  
  func executeTTSScript(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let service = args["service"] as? String,
          let text = args["text"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
      return
    }
    
    let scriptName = service == "gemini" ? "tts_gemini.py" : "tts_openai.py"
    
    // Try multiple paths to find the script
    var actualScriptPath: String?
    
    // 1. Try in app bundle resources
    if let bundlePath = Bundle.main.resourcePath {
      let scriptsPath = (bundlePath as NSString).appendingPathComponent("scripts")
      let scriptPath = (scriptsPath as NSString).appendingPathComponent(scriptName)
      if FileManager.default.fileExists(atPath: scriptPath) {
        actualScriptPath = scriptPath
      }
    }
    
    // 2. Try relative to executable (for development)
    if actualScriptPath == nil, let appPath = Bundle.main.executablePath {
      let appDir = (appPath as NSString).deletingLastPathComponent
      let relativeScriptPath = (appDir as NSString).appendingPathComponent("../../scripts/\(scriptName)")
      let resolvedPath = (relativeScriptPath as NSString).standardizingPath
      if FileManager.default.fileExists(atPath: resolvedPath) {
        actualScriptPath = resolvedPath
      }
    }
    
    // 3. Try absolute path from project root (for development)
    if actualScriptPath == nil {
      let homeDir = NSHomeDirectory()
      let projectScriptPath = (homeDir as NSString).appendingPathComponent("Downloads/Projects/Work/tts_flutter_test/scripts/\(scriptName)")
      if FileManager.default.fileExists(atPath: projectScriptPath) {
        actualScriptPath = projectScriptPath
      }
    }
    
    guard let scriptPath = actualScriptPath else {
      result(FlutterError(code: "SCRIPT_NOT_FOUND", message: "Python script not found: \(scriptName). Please ensure scripts are in the app bundle or project directory.", details: nil))
      return
    }
    
    // Prepare JSON input
    var jsonInput: [String: Any] = [
      "text": text,
      "voice": args["voice"] as? String ?? (service == "gemini" ? "Kore" : "alloy"),
      "audio_format": args["audio_format"] as? String ?? "mp3"
    ]
    
    // Add language only if provided or if it's gemini (which requires it)
    if let language = args["language"] as? String {
      jsonInput["language"] = language
    } else if service == "gemini" {
      jsonInput["language"] = "en-US"
    }
    
    if let prompt = args["prompt"] as? String {
      jsonInput["prompt"] = prompt
    }
    if let speed = args["speed"] as? Double {
      jsonInput["speed"] = speed
    }
    if let instructions = args["instructions"] as? String {
      jsonInput["instructions"] = instructions
    }
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonInput),
          let jsonString = String(data: jsonData, encoding: .utf8) else {
      result(FlutterError(code: "JSON_ERROR", message: "Failed to serialize input", details: nil))
      return
    }
    
    // Execute Python script
    // Find Python executable that works in App Sandbox (avoids xcrun wrapper)
    guard let pythonExecutable = findPythonExecutable() else {
      result(FlutterError(code: "PYTHON_NOT_FOUND", 
                         message: "Python 3 executable not found in sandbox-compatible locations. Please install Xcode Command Line Tools: xcode-select --install", 
                         details: nil))
      return
    }
    
    let process = Process()
    process.executableURL = URL(fileURLWithPath: pythonExecutable)
    process.arguments = [scriptPath]
    
    // Set working directory to project root so scripts can find config
    if let projectRoot = findProjectRoot() {
      process.currentDirectoryURL = URL(fileURLWithPath: projectRoot)
    }
    
    // Set environment variables to help Python find user-installed packages
    var env = ProcessInfo.processInfo.environment
    
    // Pass through Google Cloud credentials if available
    // Check for GOOGLE_APPLICATION_CREDENTIALS in environment
    if let googleCreds = env["GOOGLE_APPLICATION_CREDENTIALS"] {
      // Already set, will be passed through
    } else {
      // Try to find credentials in common locations
      let fileManager = FileManager.default
      
      // 1. Check for application default credentials
      if let homeDir = env["HOME"] {
        let adcPath = (homeDir as NSString).appendingPathComponent(".config/gcloud/application_default_credentials.json")
        if fileManager.fileExists(atPath: adcPath) {
          // ADC file exists, but we don't need to set GOOGLE_APPLICATION_CREDENTIALS for ADC
          // The google.auth library will find it automatically
        }
      }
      
      // 2. Check for service account key in project directory
      if let projectRoot = findProjectRoot() {
        let serviceAccountPaths = [
          (projectRoot as NSString).appendingPathComponent("backend/python/service-account-key.json"),
          (projectRoot as NSString).appendingPathComponent("service-account-key.json"),
          (projectRoot as NSString).appendingPathComponent(".gcloud/service-account-key.json")
        ]
        
        for path in serviceAccountPaths {
          if fileManager.fileExists(atPath: path) {
            env["GOOGLE_APPLICATION_CREDENTIALS"] = path
            break
          }
        }
      }
    }
    
    // Try to add user site-packages to PYTHONPATH
    // Python automatically adds user site-packages, but we'll try both container and real home
    let containerHome = NSHomeDirectory()
    let realHome = env["HOME"] ?? containerHome
    
    // Try multiple Python version paths (3.12, 3.11, 3.10, etc.)
    let pythonVersions = ["3.12", "3.11", "3.10", "3.9"]
    var pythonPaths: [String] = []
    
    for version in pythonVersions {
      // Try container home first (sandboxed app)
      pythonPaths.append((containerHome as NSString).appendingPathComponent("Library/Python/\(version)/site-packages"))
      // Try real home (if accessible)
      if realHome != containerHome {
        pythonPaths.append((realHome as NSString).appendingPathComponent("Library/Python/\(version)/site-packages"))
      }
    }
    
    // Find first existing site-packages directory
    var existingPaths: [String] = []
    for path in pythonPaths {
      if FileManager.default.fileExists(atPath: path) {
        existingPaths.append(path)
      }
    }
    
    // Add to PYTHONPATH if found
    if !existingPaths.isEmpty {
      let currentPythonPath = env["PYTHONPATH"] ?? ""
      let newPaths = existingPaths.joined(separator: ":")
      let newPythonPath = currentPythonPath.isEmpty ? newPaths : "\(newPaths):\(currentPythonPath)"
      env["PYTHONPATH"] = newPythonPath
    }
    
    process.environment = env
    
    let inputPipe = Pipe()
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    
    process.standardInput = inputPipe
    process.standardOutput = outputPipe
    process.standardError = errorPipe
    
    do {
      try process.run()
      
      // Write input to script
      if let inputData = jsonString.data(using: .utf8) {
        inputPipe.fileHandleForWriting.write(inputData)
        inputPipe.fileHandleForWriting.closeFile()
      }
      
      process.waitUntilExit()
      
      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
      let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
      
      if process.terminationStatus != 0 {
        let errorString = String(data: errorData, encoding: .utf8) ?? "Unknown error"
        
        // Check for xcrun error specifically
        if errorString.contains("xcrun: error: cannot be used within an App Sandbox") {
          result(FlutterError(code: "SANDBOX_ERROR", 
                             message: "Python execution blocked by App Sandbox. The Python executable at \(pythonExecutable) uses xcrun which is not allowed. Please install Xcode Command Line Tools (xcode-select --install) to get a sandbox-compatible Python.", 
                             details: nil))
          return
        }
        
        result(FlutterError(code: "SCRIPT_ERROR", message: "Python script failed: \(errorString)", details: nil))
        return
      }
      
      guard let outputString = String(data: outputData, encoding: .utf8),
            let resultData = outputString.data(using: .utf8),
            let resultDict = try? JSONSerialization.jsonObject(with: resultData) as? [String: Any] else {
        result(FlutterError(code: "PARSE_ERROR", message: "Failed to parse script output", details: nil))
        return
      }
      
      // Check if script returned an error
      if let success = resultDict["success"] as? Bool, !success {
        let errorMsg = resultDict["error"] as? String ?? "Unknown error from script"
        result(FlutterError(code: "TTS_ERROR", message: errorMsg, details: nil))
        return
      }
      
      result(resultDict)
    } catch {
      result(FlutterError(code: "EXECUTION_ERROR", message: "Failed to execute script: \(error.localizedDescription)", details: nil))
    }
  }
  
  func startVolumeKeyMonitoring() {
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
  
  func stopVolumeKeyMonitoring() {
    if let monitor = volumeKeyMonitor {
      NSEvent.removeMonitor(monitor)
      volumeKeyMonitor = nil
    }
  }
  
  /// Find Python 3 executable that works in App Sandbox
  /// Avoids /usr/bin/python3 wrapper which uses xcrun (blocked by sandbox)
  private func findPythonExecutable() -> String? {
    let fileManager = FileManager.default
    
    // First, try to find virtual environment Python (has dependencies installed)
    // Try multiple paths since sandboxed apps have different home directories
    var venvPaths: [String] = []
    
    // 1. Try from found project root (could be container or actual)
    if let projectRoot = findProjectRoot() {
      venvPaths.append((projectRoot as NSString).appendingPathComponent("backend/python/venv/bin/python3"))
    }
    
    // 2. Try actual home directory (not container) - use ProcessInfo to get real home
    if let realHome = ProcessInfo.processInfo.environment["HOME"] {
      let actualProjectPath = (realHome as NSString).appendingPathComponent("Downloads/Projects/Work/tts_flutter_test")
      venvPaths.append((actualProjectPath as NSString).appendingPathComponent("backend/python/venv/bin/python3"))
    }
    
    // 3. Try container home directory (NSHomeDirectory in sandbox)
    let containerHome = NSHomeDirectory()
    let containerProjectPath = (containerHome as NSString).appendingPathComponent("Downloads/Projects/Work/tts_flutter_test")
    venvPaths.append((containerProjectPath as NSString).appendingPathComponent("backend/python/venv/bin/python3"))
    
    // Check each venv path
    for venvPython in venvPaths {
      if fileManager.fileExists(atPath: venvPython) && fileManager.isExecutableFile(atPath: venvPython) {
        return venvPython
      }
    }
    
    // Try common Python 3 paths that don't use xcrun wrapper
    // Priority order: Command Line Tools Python (most reliable), then others
    let pythonPaths = [
      // Xcode Command Line Tools Python (doesn't use xcrun wrapper)
      "/Library/Developer/CommandLineTools/usr/bin/python3",
      // Homebrew Python (if accessible in sandbox)
      "/usr/local/bin/python3",
      // Try /usr/bin/python3 as last resort (might be wrapper, but worth trying)
      "/usr/bin/python3"
    ]
    
    for pythonPath in pythonPaths {
      if fileManager.fileExists(atPath: pythonPath) {
        // Check if it's a symlink and try to resolve it
        if let resolvedPath = try? fileManager.destinationOfSymbolicLink(atPath: pythonPath) {
          // Resolve to absolute path
          let absolutePath: String
          if resolvedPath.hasPrefix("/") {
            absolutePath = resolvedPath
          } else {
            let baseDir = (pythonPath as NSString).deletingLastPathComponent
            absolutePath = (baseDir as NSString).appendingPathComponent(resolvedPath)
          }
          
          // Check if resolved path exists and is executable
          if fileManager.fileExists(atPath: absolutePath) && fileManager.isExecutableFile(atPath: absolutePath) {
            return absolutePath
          }
        }
        
        // If not a symlink or resolution failed, check if it's executable
        if fileManager.isExecutableFile(atPath: pythonPath) {
          // For /usr/bin/python3, we need to be careful as it might be the wrapper
          // But if it's the only option, we'll try it
          if pythonPath == "/usr/bin/python3" {
            // This might still fail with xcrun error, but it's our last resort
            return pythonPath
          } else {
            // For other paths, they should be safe to use
            return pythonPath
          }
        }
      }
    }
    
    return nil
  }
  
  /// Find project root directory (contains backend/python/config.py)
  private func findProjectRoot() -> String? {
    // Try multiple approaches to find project root
    let fileManager = FileManager.default
    
    // 1. Try relative to script location
    if let scriptPath = Bundle.main.executablePath {
      var currentPath = (scriptPath as NSString).deletingLastPathComponent
      // Go up a few levels to find project root
      for _ in 0..<5 {
        let configPath = (currentPath as NSString).appendingPathComponent("backend/python/config.py")
        if fileManager.fileExists(atPath: configPath) {
          return currentPath
        }
        currentPath = (currentPath as NSString).deletingLastPathComponent
        if currentPath == "/" { break }
      }
    }
    
    // 2. Try from home directory
    let homeDir = NSHomeDirectory()
    let projectPath = (homeDir as NSString).appendingPathComponent("Downloads/Projects/Work/tts_flutter_test")
    let configPath = (projectPath as NSString).appendingPathComponent("backend/python/config.py")
    if fileManager.fileExists(atPath: configPath) {
      return projectPath
    }
    
    return nil
  }
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

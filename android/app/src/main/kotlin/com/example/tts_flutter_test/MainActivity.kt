package com.example.tts_flutter_test

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // [LEGACY] Old TTS platform channel - commented out for rollback
    // This channel handler was used for Python script execution via platform channels.
    // The app now uses pure Dart TTS services that make direct HTTP calls to TTS APIs.
    // To rollback: uncomment the code below
    /*
    private val CHANNEL = "com.tts_flutter_test/tts_script"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            println("TTS Channel: Received method call: ${call.method}")
            when (call.method) {
                "synthesizeSpeech" -> {
                    // Android cannot execute Python scripts directly
                    // Return an error indicating this limitation
                    result.error(
                        "PLATFORM_NOT_SUPPORTED",
                        "Python script execution is not supported on Android. Please use the remote API service instead.",
                        null
                    )
                }
                else -> {
                    println("TTS Channel: Unknown method: ${call.method}")
                    result.notImplemented()
                }
            }
        }
        
        println("Method channels set up successfully for Android")
        println("TTS Channel name: $CHANNEL")
    }
    */
    
    // [NEW] No platform-specific TTS code needed
    // The app now uses pure Dart TTS services that work on all platforms
    // All TTS operations are handled in Dart code via direct HTTP calls to TTS APIs
}

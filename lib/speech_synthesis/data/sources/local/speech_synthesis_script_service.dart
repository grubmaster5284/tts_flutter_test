import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Service for executing Python TTS scripts via platform channels
/// 
/// ## What is a Platform Channel?
/// Platform channels are Flutter's mechanism for communication between Dart code
/// and native platform code (Android/iOS/macOS/etc.). They allow Flutter apps to:
/// - Call native methods from Dart
/// - Receive data from native code
/// - Execute platform-specific code (like running Python scripts)
/// 
/// ## MethodChannel:
/// The `MethodChannel` class provides bidirectional communication:
/// - **Dart → Native**: `invokeMethod()` sends method calls with arguments
/// - **Native → Dart**: Native code can return results or call back to Dart
/// 
/// ## How This Service Works:
/// 1. **Request**: Converts DTO to platform channel arguments (Map)
/// 2. **Invocation**: Calls native method via MethodChannel
/// 3. **Native Execution**: Platform code executes Python script to call TTS APIs
/// 4. **Response**: Receives result from native code and converts to DTO
/// 5. **Error Handling**: Maps platform errors to domain errors
/// 
/// ## Why Use Platform Channels for Python Scripts?
/// - **Security**: Python scripts run in a sandboxed environment
/// - **Performance**: Native code can execute scripts more efficiently
/// - **Flexibility**: Can use platform-specific Python installations
/// - **Isolation**: Script execution doesn't block Flutter's UI thread
/// 
/// ## TTS Providers Supported:
/// - **Google Gemini**: Google Cloud Text-to-Speech API
/// - **OpenAI**: OpenAI TTS API
/// - **AWS Polly**: Amazon Polly TTS service
/// 
/// This is part of the Data layer and abstracts the platform-specific implementation
/// details from the rest of the application.
class SpeechSynthesisScriptService {
  /// MethodChannel for communicating with native platform code
  /// 
  /// **Channel Name**: `'com.tts_flutter_test/tts_script'`
  /// - Must match the channel name registered in native code (MainActivity.kt, AppDelegate.swift)
  /// - Channel names are typically in reverse domain notation
  /// 
  /// **Static Const**: The channel is static and const because:
  /// - It doesn't change during runtime
  /// - It can be shared across multiple instances (though this service is typically singleton)
  /// - MethodChannel instances are lightweight and can be reused
  /// 
  /// **MethodChannel Package:**
  /// Part of `package:flutter/services.dart`, which provides:
  /// - `MethodChannel`: For method calls (this service)
  /// - `EventChannel`: For event streams
  /// - `BasicMessageChannel`: For basic message passing
  static const MethodChannel _channel = MethodChannel('com.tts_flutter_test/tts_script');
  
  /// Synthesizes speech by executing a Python script via platform channel
  /// 
  /// **Process:**
  /// 1. Converts DTO to platform channel arguments (`Map<String, dynamic>`)
  /// 2. Invokes native method 'synthesizeSpeech' via MethodChannel
  /// 3. Native code executes Python script to call TTS API
  /// 4. Receives response from native code (Map with audio data)
  /// 5. Converts response Map to SpeechResponseDto
  /// 6. Returns Result with DTO or error
  /// 
  /// **Parameters:**
  /// - `request`: SpeechRequestDto containing text, service, voice, etc.
  /// 
  /// **Returns:**
  /// - `Result.success(SpeechResponseDto)`: On successful synthesis
  /// - `Result.failure(SpeechSynthesisError)`: On error (script error, API error, etc.)
  /// 
  /// **Platform Channel Communication:**
  /// The `invokeMethod` call is asynchronous and doesn't block the UI thread.
  /// Native code executes the Python script and returns the result when complete.
  /// 
  /// **Error Handling:**
  /// - PlatformException: Platform-specific errors (script not found, Python not found, etc.)
  /// - Null result: Script returned null (unexpected)
  /// - Error in result: Script returned an error message
  /// - Other exceptions: Unexpected errors during execution
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> synthesizeSpeech(
    SpeechRequestDto request,
  ) async {
    // Log the request for debugging
    AppLogger.info('Executing TTS Python script', tag: 'TTSScriptService', data: {
      'service': request.service,
      'textLength': request.text.length,
      'voice': request.voice,
      'language': request.language,
      'audioFormat': request.audioFormat,
    });
    
    try {
      // Step 1: Convert DTO to platform channel arguments
      // MethodChannel requires arguments as `Map<String, dynamic>`
      // The native code will read these arguments and pass them to the Python script
      final arguments = <String, dynamic>{
        'service': request.service, // TTS service identifier
        'text': request.text, // Text to synthesize
        'voice': request.voice, // Optional voice identifier
        'language': request.language, // Optional language code
        'audio_format': request.audioFormat, // Audio format (mp3, wav, etc.)
      };
      
      // Step 2: Add service-specific parameters if needed
      // Different TTS services may require different parameters
      // This is where service-specific configuration would be added
      if (request.service == 'gemini') {
        // Gemini-specific params can be added here if needed
        // Example: model selection, speaking rate, pitch, etc.
      } else if (request.service == 'openai') {
        // OpenAI-specific params can be added here if needed
        // Example: model selection, speed, etc.
      }
      
      // Step 3: Invoke native method via MethodChannel
      // This is an asynchronous call that:
      // - Sends the method name 'synthesizeSpeech' to native code
      // - Passes the arguments Map
      // - Waits for native code to execute Python script
      // - Receives the result as a `Map<Object?, Object?>`
      // 
      // The generic type `<Map<Object?, Object?>>` specifies the expected return type
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'synthesizeSpeech', // Method name (must match native code)
        arguments, // Arguments to pass to native method
      );
      
      // Step 4: Handle null result (unexpected)
      if (result == null) {
        AppLogger.error('Script returned null result', tag: 'TTSScriptService');
        return Failure(SpeechSynthesisError.unknown('Script execution returned no result'));
      }
      
      // Step 5: Check for error in result
      // Native code may return an error in the result Map instead of throwing an exception
      if (result.containsKey('error')) {
        final errorMsg = result['error'] as String? ?? 'Unknown error from script';
        AppLogger.error('Script returned error', tag: 'TTSScriptService', error: errorMsg);
        return Failure(SpeechSynthesisError.unknown(errorMsg));
      }
      
      // Step 6: Convert result Map to SpeechResponseDto
      // The native code returns a Map with keys matching the DTO fields
      // We extract each field and provide defaults if missing
      final responseDto = SpeechResponseDto(
        audioData: result['audio_data'] as String? ?? '', // Base64-encoded audio
        audioFormat: result['audio_format'] as String? ?? 'mp3', // Default to mp3
        durationMs: result['duration_ms'] as int? ?? 0, // Duration in milliseconds
        metadata: result['metadata'] as String?, // Optional metadata JSON string
      );
      
      AppLogger.info('TTS script execution successful', tag: 'TTSScriptService');
      
      // Step 7: Return success with DTO
      return Success(responseDto);
    } on PlatformException catch (e) {
      // PlatformException is thrown by Flutter when native code encounters an error
      // It contains a 'code' (error type) and 'message' (error details)
      AppLogger.error('Platform exception during script execution', 
          tag: 'TTSScriptService',
          error: e);
      
      // Step 7: Map platform-specific error codes to domain errors
      // Each error code represents a different type of failure that can occur
      
      if (e.code == 'SCRIPT_NOT_FOUND') {
        // Python script file is missing from the app bundle
        return Failure(SpeechSynthesisError.unknown(
          'Python script not found. Please ensure scripts are in the app bundle.'
        ));
      } else if (e.code == 'SANDBOX_ERROR') {
        // macOS App Sandbox is blocking Python execution
        // This happens when the app doesn't have permission to execute scripts
        return Failure(SpeechSynthesisError.unknown(
          e.message ?? 'App Sandbox is blocking Python execution. Please install Xcode Command Line Tools.'
        ));
      } else if (e.code == 'PYTHON_NOT_FOUND') {
        // Python 3 is not installed on the system
        // User needs to install Python or Xcode Command Line Tools
        return Failure(SpeechSynthesisError.unknown(
          e.message ?? 'Python 3 not found. Please install Xcode Command Line Tools: xcode-select --install'
        ));
      } else if (e.code == 'TTS_ERROR') {
        // TTS API returned an error (billing, authentication, rate limit, etc.)
        // Parse the error message to extract meaningful information
        final errorMessage = e.message ?? 'TTS service error';
        final parsedError = _parseTtsError(errorMessage);
        return Failure(parsedError);
      } else if (e.code == 'INVALID_ARGUMENTS') {
        // Invalid arguments were passed to the script
        // This is a validation error
        return Failure(SpeechSynthesisError.validation(e.message ?? 'Invalid arguments'));
      }
      
      // Unknown platform error - return generic error with code and message
      return Failure(SpeechSynthesisError.unknown(e.message ?? 'Platform error: ${e.code}'));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during script execution',
          tag: 'TTSScriptService',
          error: e,
          stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.unknown(e.toString()));
    }
  }
  
  /// Parses TTS error message to extract meaningful error information
  /// 
  /// **Purpose:**
  /// TTS APIs (Google Cloud, OpenAI, AWS Polly) return errors in various formats:
  /// - JSON error responses (structured)
  /// - Plain text error messages (unstructured)
  /// 
  /// This method attempts to parse structured errors and extract:
  /// - HTTP status codes (401, 403, 429, 503, etc.)
  /// - Error types (billing, authentication, rate limiting, etc.)
  /// - User-friendly error messages
  /// 
  /// **Process:**
  /// 1. Tries to extract JSON from the error message
  /// 2. Parses JSON to extract error code, status, and message
  /// 3. Maps HTTP codes to domain errors (unauthorized, forbidden, etc.)
  /// 4. Special handling for billing errors (common issue)
  /// 5. Falls back to pattern matching in plain text if JSON parsing fails
  /// 
  /// **Parameters:**
  /// - `errorMessage`: Raw error message from TTS API or script
  /// 
  /// **Returns:**
  /// - `SpeechSynthesisError`: Appropriate domain error based on the error message
  /// 
  /// **Error Types Handled:**
  /// - **Billing Errors**: Detects when billing is not enabled (common Google Cloud issue)
  /// - **Authentication Errors**: 401 Unauthorized
  /// - **Permission Errors**: 403 Forbidden
  /// - **Rate Limiting**: 429 Too Many Requests
  /// - **Service Unavailable**: 503 Service Unavailable
  /// - **Generic Service Errors**: Other API errors
  SpeechSynthesisError _parseTtsError(String errorMessage) {
    try {
      // Step 1: Try to extract JSON from error message
      // Many APIs return JSON error responses embedded in error messages
      // Example: "Error: {\"error\": {\"code\": 403, \"message\": \"Billing disabled\"}}"
      final jsonStr = _extractJsonString(errorMessage);
      if (jsonStr != null) {
          // Step 2: Parse JSON string to Map
          final errorJson = json.decode(jsonStr) as Map<String, dynamic>;
          
          // Step 3: Check for nested error structure (Google Cloud API format)
          // Google Cloud APIs wrap errors in an "error" object
          if (errorJson.containsKey('error')) {
            final error = errorJson['error'] as Map<String, dynamic>;
            final code = error['code'] as int?; // HTTP status code
            final status = error['status'] as String?; // Error status string
            final message = error['message'] as String?; // Error message
            
            // Step 4: Special handling for billing errors (403 + PERMISSION_DENIED)
            // This is a common issue with Google Cloud APIs
            if (code == 403 && status == 'PERMISSION_DENIED') {
              final details = error['details'] as List<dynamic>?;
              if (details != null) {
                // Check details array for billing-specific errors
                for (final detail in details) {
                  if (detail is Map<String, dynamic>) {
                    final reason = detail['reason'] as String?;
                    if (reason == 'BILLING_DISABLED') {
                      // Extract project ID from metadata if available
                      final metadata = detail['metadata'] as Map<String, dynamic>?;
                      final projectId = metadata?['consumer'] as String?;
                      
                      // Create user-friendly billing error message
                      String billingMessage = 'Billing is not enabled for your Google Cloud project.';
                      if (message != null && message.contains('billing')) {
                        // Use the API's message if it mentions billing
                        billingMessage = message;
                      } else if (projectId != null) {
                        // Include project ID if available
                        billingMessage = 'Billing is not enabled for project $projectId. Please enable billing in the Google Cloud Console.';
                      }
                      
                      return SpeechSynthesisError.serviceError(billingMessage);
                    }
                  }
                }
              }
              
              // Generic permission denied (403 but not billing-related)
              return SpeechSynthesisError.forbidden();
            }
            
            // Step 5: Map other HTTP error codes to domain errors
            if (code == 401) {
              return const SpeechSynthesisError.unauthorized();
            } else if (code == 403) {
              return const SpeechSynthesisError.forbidden();
            } else if (code == 429) {
              return const SpeechSynthesisError.tooManyRequests();
            } else if (code == 503) {
              return const SpeechSynthesisError.serviceUnavailable();
            }
            
            // Step 6: Use the API's error message if available
            if (message != null) {
              return SpeechSynthesisError.serviceError(message);
            }
          }
        }
      
      // Step 7: Fall back to pattern matching in plain text
      // If JSON parsing failed, try to detect error types from keywords
      
      if (errorMessage.toLowerCase().contains('billing')) {
        return SpeechSynthesisError.serviceError(
          'Billing is required for this service. Please enable billing in your Google Cloud Console.'
        );
      }
      
      if (errorMessage.toLowerCase().contains('permission denied') ||
          errorMessage.toLowerCase().contains('forbidden')) {
        return const SpeechSynthesisError.forbidden();
      }
      
      if (errorMessage.toLowerCase().contains('unauthorized') ||
          errorMessage.toLowerCase().contains('authentication')) {
        return const SpeechSynthesisError.unauthorized();
      }
      
      // Step 8: Default to service error with original message
      // If we can't parse the error, return it as a generic service error
      return SpeechSynthesisError.serviceError(errorMessage);
    } catch (e) {
      // If parsing fails completely, return the original error message
      // This ensures we always return a valid error, even if parsing fails
      AppLogger.warning('Failed to parse TTS error message', tag: 'TTSScriptService', data: e);
      return SpeechSynthesisError.serviceError(errorMessage);
    }
  }
  
  /// Extracts a JSON string from an error message
  /// 
  /// **Purpose:**
  /// Error messages from APIs often contain JSON embedded in plain text.
  /// This method extracts the JSON portion for parsing.
  /// 
  /// **Process:**
  /// 1. Finds the first `{` character (start of JSON)
  /// 2. Finds the last `}` character (end of JSON)
  /// 3. Extracts the substring between them
  /// 
  /// **Parameters:**
  /// - `message`: Error message that may contain JSON
  /// 
  /// **Returns:**
  /// - `String?`: Extracted JSON string, or `null` if no JSON found
  /// 
  /// **Example:**
  /// Input: `"Error: {\"code\": 403, \"message\": \"Billing disabled\"}"`
  /// Output: `"{\"code\": 403, \"message\": \"Billing disabled\"}"`
  String? _extractJsonString(String message) {
    // Find the first opening brace
    final firstBrace = message.indexOf('{');
    if (firstBrace == -1) return null; // No JSON found
    
    // Find the last closing brace after the first opening brace
    // This handles nested JSON structures
    var lastBrace = message.lastIndexOf('}');
    if (lastBrace == -1 || lastBrace <= firstBrace) return null; // Invalid JSON
    
    // Extract the JSON substring
    return message.substring(firstBrace, lastBrace + 1);
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/constants/speech_synthesis_api_keys.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Remote service for speech synthesis API calls
/// 
/// ## What is a Remote Service?
/// A remote service handles communication with external APIs over HTTP. This service
/// makes HTTP requests to a backend server (Python FastAPI) that performs TTS synthesis.
/// 
/// ## Architecture:
/// Instead of calling TTS APIs directly from Flutter, this app uses a Python backend:
/// - **Flutter App** → **Python Backend** → **TTS APIs** (Google, OpenAI, AWS)
/// 
/// **Why use a backend?**
/// - **Security**: API keys are stored server-side, not in the app
/// - **Flexibility**: Can switch TTS providers without app updates
/// - **Rate Limiting**: Backend can implement rate limiting and caching
/// - **Python Libraries**: Easier to use Python TTS libraries
/// 
/// ## HTTP Package:
/// The `http` package provides:
/// - `http.Client`: HTTP client for making requests
/// - `http.post()`, `http.get()`, etc.: Convenience methods for HTTP methods
/// - `Response`: Contains status code, headers, and body
/// - `ClientException`: Network-related errors
/// 
/// ## Retry Strategy:
/// The service implements retry logic with exponential backoff:
/// - **Max Retries**: 3 attempts
/// - **Retry Delay**: 2 seconds (multiplied by attempt number)
/// - **Retryable Errors**: Network errors, timeouts, 5xx server errors
/// 
/// ## Error Handling:
/// - Maps HTTP status codes to domain errors (401 → unauthorized, 403 → forbidden, etc.)
/// - Handles network errors (connection refused, timeout, etc.)
/// - Provides user-friendly error messages
/// 
/// This is part of the Data layer in clean architecture.
class SpeechSynthesisRemoteService {
  /// HTTP client for making API requests
  /// 
  /// **Dependency Injection**: The client is injected via constructor, allowing:
  /// - **Testing**: Can inject a mock client for unit tests
  /// - **Configuration**: Can use different clients (with interceptors, etc.)
  /// - **Reusability**: Client can be shared across multiple services
  /// 
  /// **http.Client Package:**
  /// Part of `package:http/http.dart`, provides:
  /// - `post()`, `get()`, `put()`, `delete()` methods
  /// - Request/response handling
  /// - Connection pooling
  final http.Client _client;
  
  /// Request timeout duration (30 seconds)
  /// 
  /// If a request takes longer than this, it will be cancelled and a timeout
  /// error will be returned. This prevents requests from hanging indefinitely.
  static const Duration _timeout = Duration(seconds: 30);
  
  /// Maximum number of retry attempts (3)
  /// 
  /// If a request fails with a retryable error, it will be retried up to this
  /// many times before giving up.
  static const int _maxRetries = 3;
  
  /// Delay between retry attempts (2 seconds)
  /// 
  /// This is multiplied by the attempt number for exponential backoff:
  /// - Attempt 1: 2 seconds
  /// - Attempt 2: 4 seconds
  /// - Attempt 3: 6 seconds
  static const Duration _retryDelay = Duration(seconds: 2);
  
  /// Constructor that initializes the service with an HTTP client
  /// 
  /// **Dependency Injection**: HTTP client is injected via constructor,
  /// making the service testable (can inject mock client).
  /// 
  /// **Parameters:**
  /// - `_client`: HTTP client instance for making API requests
  SpeechSynthesisRemoteService(this._client);
  
  /// Synthesizes speech from text by calling the backend API
  /// 
  /// **Public Method**: This is the main entry point for TTS synthesis.
  /// It wraps the internal method with retry logic.
  /// 
  /// **Parameters:**
  /// - `request`: SpeechRequestDto containing text, service, voice, etc.
  /// 
  /// **Returns:**
  /// - `Result.success(SpeechResponseDto)`: On successful synthesis
  /// - `Result.failure(SpeechSynthesisError)`: On error
  /// 
  /// **Retry Logic:**
  /// Automatically retries failed requests up to `_maxRetries` times for retryable errors.
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> synthesizeSpeech(
    SpeechRequestDto request,
  ) async {
    // Wrap the internal method with retry logic
    // The retry operation will automatically retry on retryable errors
    return _retryOperation(
      () => _synthesizeSpeechInternal(request),
      maxRetries: _maxRetries,
    );
  }
  
  /// Internal method that performs the actual HTTP request
  /// 
  /// **Process:**
  /// 1. Converts DTO to JSON request body
  /// 2. Makes HTTP POST request to backend API
  /// 3. Parses response JSON to DTO
  /// 4. Handles errors (network, timeout, HTTP status codes)
  /// 
  /// **Parameters:**
  /// - `request`: SpeechRequestDto to send to the backend
  /// 
  /// **Returns:**
  /// - `Result.success(SpeechResponseDto)`: On successful response (200 OK)
  /// - `Result.failure(SpeechSynthesisError)`: On error
  /// 
  /// **Error Types:**
  /// - **Network Errors**: Connection refused, network unavailable
  /// - **Timeout Errors**: Request took longer than timeout duration
  /// - **HTTP Errors**: 400, 401, 403, 429, 500, etc.
  /// - **Format Errors**: Invalid JSON response
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> _synthesizeSpeechInternal(
    SpeechRequestDto request,
  ) async {
    // Get the API endpoint URL from constants
    final url = SpeechSynthesisApiKeys.synthesizeUrl;
    
    // Convert DTO to JSON string for request body
    // The toJson() method is generated by json_serializable
    final requestBody = jsonEncode(request.toJson());
    
    // Log the request for debugging
    AppLogger.debug('Sending TTS request to backend', tag: 'TTSRemoteService', data: {
      'url': url,
      'service': request.service,
      'textLength': request.text.length,
      'voice': request.voice,
      'language': request.language,
      'audioFormat': request.audioFormat,
    });
    
    try {
      // Step 1: Make HTTP POST request
      // The http.Client.post() method:
      // - Sends a POST request to the specified URL
      // - Includes headers (Content-Type: application/json)
      // - Sends the request body (JSON string)
      // - Returns a Response object
      // 
      // The .timeout() method cancels the request if it takes longer than _timeout
      final response = await _client
          .post(
            Uri.parse(url), // Parse URL string to Uri object
            headers: {
              'Content-Type': 'application/json', // Tell server we're sending JSON
            },
            body: requestBody, // JSON string request body
          )
          .timeout(_timeout); // Cancel if request takes too long
      
      // Log the response for debugging
      AppLogger.debug('Received response from backend', tag: 'TTSRemoteService', data: {
        'statusCode': response.statusCode, // HTTP status code (200, 400, 500, etc.)
        'bodyLength': response.body.length, // Response body size
      });
      
      // Step 2: Check if request was successful (200 OK)
      if (response.statusCode == 200) {
        // Step 3: Parse JSON response to DTO
        // jsonDecode() converts JSON string to Map<String, dynamic>
        // SpeechResponseDto.fromJson() converts Map to DTO
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final dto = SpeechResponseDto.fromJson(jsonData);
        
        AppLogger.info('TTS request successful', tag: 'TTSRemoteService', data: {
          'format': dto.audioFormat,
          'duration': dto.durationMs,
        });
        
        // Step 4: Return success with DTO
        return Success(dto);
      } else {
        // Step 5: Handle HTTP error status codes (400, 401, 403, 500, etc.)
        AppLogger.warning('TTS request failed with status code', tag: 'TTSRemoteService', data: {
          'statusCode': response.statusCode,
          'body': response.body.substring(0, response.body.length > 200 ? 200 : response.body.length),
        });
        
        // Map HTTP status code to domain error
        return Failure(
          _mapHttpErrorToDomainError(response.statusCode, response.body),
        );
      }
    } on http.ClientException catch (e) {
      // Step 6: Handle network errors (connection refused, DNS failure, etc.)
      // ClientException is thrown by the http package for network-related errors
      AppLogger.error('Network error during TTS request', tag: 'TTSRemoteService', error: e);
      
      final errorString = e.toString().toLowerCase();
      
      // Check if it's a connection refused error (backend not running)
      // This is a common issue during development
      if (errorString.contains('connection refused') || 
          errorString.contains('errno = 61')) {
        return Failure(SpeechSynthesisError.unknown(
          'Backend server is not running.\n\nPlease start the Python backend server:\n1. Open terminal\n2. cd backend/python\n3. python main.py\n\nOr see backend/README.md for details.'
        ));
      }
      
      // Check for "Failed to fetch" - common on web when backend is unreachable or CORS issue
      if (errorString.contains('failed to fetch')) {
        return Failure(SpeechSynthesisError.unknown(
          'Cannot connect to backend server.\n\nPossible causes:\n'
          '1. Backend server is not running (start it with: cd backend/python && python main.py)\n'
          '2. Backend is running on a different port\n'
          '3. CORS configuration issue\n\n'
          'Make sure the backend is running on http://localhost:8000'
        ));
      }
      
      // Generic network error
      return Failure(SpeechSynthesisError.networkError());
    } on FormatException catch (e) {
      // Step 7: Handle JSON parsing errors
      // FormatException is thrown when JSON is invalid or malformed
      AppLogger.error('Invalid response format', tag: 'TTSRemoteService', error: e);
      return Failure(SpeechSynthesisError.unknown('Invalid response format: ${e.message}'));
    } catch (e, stackTrace) {
      // Step 8: Handle timeout and other unexpected errors
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        // Request timed out (took longer than _timeout duration)
        AppLogger.error('Request timeout', tag: 'TTSRemoteService', error: e);
        return Failure(const SpeechSynthesisError.timeout());
      }
      
      // Unexpected error - log with stack trace for debugging
      AppLogger.error('Unexpected error during TTS request', 
          tag: 'TTSRemoteService',
          error: e,
          stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.unknown(e.toString()));
    }
  }
  
  /// Retries an operation with exponential backoff
  /// 
  /// **Purpose:**
  /// Network requests can fail due to transient issues (network hiccups, server
  /// overload, etc.). Retrying with exponential backoff increases the chance of
  /// success while avoiding overwhelming the server.
  /// 
  /// **Exponential Backoff:**
  /// Delay increases with each attempt:
  /// - Attempt 1: 2 seconds
  /// - Attempt 2: 4 seconds
  /// - Attempt 3: 6 seconds
  /// 
  /// This gives the server time to recover between attempts.
  /// 
  /// **Retryable Errors:**
  /// Only retries errors marked as retryable (network errors, timeouts, 5xx errors).
  /// Non-retryable errors (400, 401, 403) are returned immediately.
  /// 
  /// **Parameters:**
  /// - `operation`: Function that returns a Result (the operation to retry)
  /// - `maxRetries`: Maximum number of retry attempts (default: 3)
  /// 
  /// **Returns:**
  /// - `Result.success(T)`: If operation succeeds (on any attempt)
  /// - `Result.failure(SpeechSynthesisError)`: If all attempts fail or error is non-retryable
  /// 
  /// **Generic Type `<T>`:**
  /// This method is generic, meaning it can retry any operation that returns
  /// `Result<T, SpeechSynthesisError>`. This makes it reusable for different operations.
  Future<Result<T, SpeechSynthesisError>> _retryOperation<T>(
    Future<Result<T, SpeechSynthesisError>> Function() operation,
    {int maxRetries = 3}
  ) async {
    // Try up to maxRetries times
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      // Execute the operation
      final result = await operation();
      
      // If successful, return immediately
      if (result.isSuccess) {
        return result;
      }
      
      // If failed, check if error is retryable
      if (result.isFailure) {
        final error = result.failure;
        
        // Only retry if error is retryable and we haven't exceeded max retries
        if (error.isRetryable && attempt < maxRetries) {
          // Wait before retrying (exponential backoff)
          // Delay = base delay * attempt number
          await Future.delayed(_retryDelay * attempt);
          continue; // Try again
        }
      }
      
      // If error is not retryable or we've exceeded max retries, return failure
      return result;
    }
    
    // This should never be reached, but included for safety
    return Failure<T, SpeechSynthesisError>(const SpeechSynthesisError.timeout());
  }
  
  /// Maps HTTP status codes to domain errors
  /// 
  /// **Purpose:**
  /// HTTP status codes are data layer concepts. This method converts them to
  /// domain errors that the domain layer understands.
  /// 
  /// **HTTP Status Code Mapping:**
  /// - **400 Bad Request**: Validation error (invalid request parameters)
  /// - **401 Unauthorized**: Authentication error (missing/invalid credentials)
  /// - **403 Forbidden**: Permission error (credentials valid but no permission)
  /// - **429 Too Many Requests**: Rate limiting error (too many requests)
  /// - **500/502/504 Server Errors**: Service error (server-side issues)
  /// - **503 Service Unavailable**: Service temporarily unavailable
  /// - **Other**: Unknown error
  /// 
  /// **Parameters:**
  /// - `statusCode`: HTTP status code from the response
  /// - `body`: Response body (may contain error details)
  /// 
  /// **Returns:**
  /// - `SpeechSynthesisError`: Appropriate domain error for the status code
  SpeechSynthesisError _mapHttpErrorToDomainError(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        // Bad Request - invalid request parameters
        return SpeechSynthesisError.validation('Invalid request: $body');
      case 401:
        // Unauthorized - authentication required or failed
        return const SpeechSynthesisError.unauthorized();
      case 403:
        // Forbidden - authenticated but no permission
        // Try to extract helpful error message from Google Cloud API errors
        try {
          final jsonData = jsonDecode(body) as Map<String, dynamic>?;
          final detail = jsonData?['detail'] as String?;
          if (detail != null && detail.contains('texttospeech')) {
            // Google Cloud TTS API error
            if (detail.contains('Application Default Credentials')) {
              return SpeechSynthesisError.serviceError(
                'Google Cloud authentication issue. Please ensure:\n'
                '1. Text-to-Speech API is enabled in your Google Cloud project\n'
                '2. Your credentials have the "Cloud Text-to-Speech API User" role\n'
                '3. Use a service account key file: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json'
              );
            } else if (detail.contains('billing') || detail.contains('BILLING')) {
              return SpeechSynthesisError.serviceError(
                'Billing is not enabled for your Google Cloud project. Please enable billing in the Google Cloud Console.'
              );
            } else if (detail.contains('PERMISSION_DENIED')) {
              return SpeechSynthesisError.serviceError(
                'Permission denied. Your credentials do not have access to the Text-to-Speech API. '
                'Please ensure your service account has the "Cloud Text-to-Speech API User" role.'
              );
            }
            // Return the detail message if it's informative
            return SpeechSynthesisError.serviceError(
              detail.length > 300 ? '${detail.substring(0, 300)}...' : detail
            );
          }
        } catch (e) {
          // If parsing fails, fall through to default
        }
        return const SpeechSynthesisError.forbidden();
      case 429:
        // Too Many Requests - rate limit exceeded
        return const SpeechSynthesisError.tooManyRequests();
      case 503:
        // Service Unavailable - server temporarily unavailable
        return const SpeechSynthesisError.serviceUnavailable();
      case 500:
      case 502:
      case 504:
        // Server errors - internal server error, bad gateway, gateway timeout
        return SpeechSynthesisError.serviceError('Server error: $body');
      default:
        // Unknown status code - return generic error
        return SpeechSynthesisError.unknown('HTTP $statusCode: $body');
    }
  }
}


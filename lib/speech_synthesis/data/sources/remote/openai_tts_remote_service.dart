// [NEW] Pure Dart OpenAI TTS service - direct HTTP calls to OpenAI TTS API
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Pure Dart service for OpenAI Text-to-Speech API
/// 
/// This service makes direct HTTP calls to OpenAI TTS API without requiring
/// a Python backend. It uses API key authentication and matches the Python
/// implementation exactly.
/// 
/// ## Architecture:
/// - **Direct API Calls**: Makes HTTP POST requests to `https://api.openai.com/v1/audio/speech`
/// - **API Key Authentication**: Uses `OPENAI_API_KEY` from .env file or environment variable
/// - **Streaming Response**: Handles streaming audio response (same as Python)
/// - **Error Handling**: Maps OpenAI API errors to domain errors
/// 
/// ## Authentication:
/// The service requires the `OPENAI_API_KEY` to be set in:
/// 1. `.env` file: `OPENAI_API_KEY=your_key_here`
/// 2. Environment variable: `export OPENAI_API_KEY=your_key_here`
/// 
/// ## API Endpoint:
/// - URL: `https://api.openai.com/v1/audio/speech`
/// - Method: POST
/// - Authentication: Bearer token (API key)
/// 
/// ## Supported Voices:
/// - alloy, echo, fable, onyx, nova, shimmer
/// 
/// ## Supported Formats:
/// - mp3, opus, aac, flac, wav, pcm
/// 
/// ## Parameters:
/// - `speed`: Speech speed (0.25 to 4.0, default: 1.0)
/// - `instructions`: Optional instructions for how to speak the text
///   - **Note**: Instructions produce subtle tone/style adjustments only.
///     For stronger emotional expression, consider using different voices
///     or adjusting speed. The model has limited ability to convey dramatic
///     emotions through instructions alone.
/// 
/// This is part of the Data layer and follows data layer conventions:
/// - Returns `Result<SpeechResponseDto, SpeechSynthesisError>`
/// - Handles raw data access only, no business logic
/// - Maps API errors to domain errors
class OpenAITtsRemoteService {
  /// HTTP client for making API requests
  final http.Client _client;
  
  /// Request timeout duration (30 seconds)
  static const Duration _timeout = Duration(seconds: 30);
  
  /// OpenAI TTS API endpoint
  static const String _apiUrl = 'https://api.openai.com/v1/audio/speech';
  
  /// Valid OpenAI voices (same as Python)
  static const List<String> _validVoices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'];
  
  /// Valid audio formats (same as Python)
  static const List<String> _validFormats = ['mp3', 'opus', 'aac', 'flac', 'wav', 'pcm'];
  
  /// Constructor that initializes the service with an HTTP client
  /// 
  /// **Dependency Injection**: HTTP client is injected via constructor,
  /// making the service testable (can inject mock client).
  OpenAITtsRemoteService(this._client);
  
  /// Synthesizes speech from text using OpenAI TTS API
  /// 
  /// This method matches the Python implementation exactly:
  /// 1. Validates voice and format
  /// 2. Gets API key from .env or environment variable
  /// 3. Builds request parameters (model, voice, input, response_format, speed, instructions)
  /// 4. Makes HTTP POST request with streaming response
  /// 5. Collects all audio chunks into bytes
  /// 6. Converts binary audio to base64
  /// 7. Calculates duration (same formula as Python)
  /// 8. Returns response with metadata
  /// 
  /// **Parameters:**
  /// - `request`: SpeechRequestDto containing text, voice, format, speed, instructions, etc.
  /// 
  /// **Returns:**
  /// - `Result.success(SpeechResponseDto)`: On successful synthesis
  /// - `Result.failure(SpeechSynthesisError)`: On error
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> synthesizeSpeech(
    SpeechRequestDto request,
  ) async {
    AppLogger.info('Synthesizing speech with OpenAI TTS', tag: 'OpenAITtsService', data: {
      'textLength': request.text.length,
      'voice': request.voice,
      'audioFormat': request.audioFormat,
      'speed': request.speed,
      'hasInstructions': request.instructions != null,
    });
    
    try {
      // Step 1: Check API key (same as Python: if not OPENAI_API_KEY, raise HTTPException(503))
      final apiKey = dotenv.env['OPENAI_API_KEY'] ?? 
                     Platform.environment['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        return Failure(SpeechSynthesisError.serviceError(
          'OpenAI TTS not configured. Set OPENAI_API_KEY in .env'
        ));
      }
      
      // Step 2: Validate and cast voice (same as Python)
      final voice = request.voice ?? 'alloy';
      if (!_validVoices.contains(voice)) {
        return Failure(SpeechSynthesisError.validation(
          'Invalid voice. Must be one of: ${_validVoices.join(', ')}'
        ));
      }
      
      // Step 3: Validate and cast audio format (same as Python)
      if (!_validFormats.contains(request.audioFormat)) {
        return Failure(SpeechSynthesisError.validation(
          'Invalid audio format. Must be one of: ${_validFormats.join(', ')}'
        ));
      }
      
      // Step 4: Build request parameters (same as Python)
      final requestParams = <String, dynamic>{
        'model': 'gpt-4o-mini-tts',
        'voice': voice,
        'input': request.text,
        'response_format': request.audioFormat,
        'speed': request.speed,
      };
      
      // Add instructions if provided (same as Python)
      if (request.instructions != null && request.instructions!.isNotEmpty) {
        requestParams['instructions'] = request.instructions;
      }
      
      // Step 5: Make HTTP POST request (same as Python - streaming response)
      // In Dart, we read the full response body which is equivalent to collecting all chunks
      final response = await _client
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestParams),
          )
          .timeout(_timeout);
      
      // Step 6: Handle response
      if (response.statusCode == 200) {
        // Step 7: Collect all chunks into bytes (same as Python)
        // In Python: audio_bytes = b""; for chunk in response.iter_bytes(): audio_bytes += chunk
        // In Dart: response.bodyBytes already contains all the bytes
        final audioBytes = response.bodyBytes;
        
        // Step 8: Base64 encode (same as Python: base64.b64encode(audio_bytes).decode("utf-8"))
        final audioBase64 = base64Encode(audioBytes);
        
        // Step 9: Calculate duration (same formula as Python: int((word_count / 150) * 60 * 1000))
        final wordCount = request.text.split(' ').length;
        final durationMs = ((wordCount / 150) * 60 * 1000).round();
        
        // Step 10: Build response (same structure as Python)
        final dto = SpeechResponseDto(
          audioData: audioBase64,
          audioFormat: request.audioFormat,
          durationMs: durationMs,
          metadata: jsonEncode({
            'service': 'openai',
            'voice': voice,
            'instructions': request.instructions,
          }),
        );
        
        AppLogger.info('OpenAI TTS synthesis successful', tag: 'OpenAITtsService', data: {
          'format': dto.audioFormat,
          'duration': dto.durationMs,
          'voice': voice,
        });
        
        return Success(dto);
      } else {
        // Step 11: Handle HTTP errors
        return Failure(_mapHttpErrorToDomainError(response.statusCode, response.body));
      }
    } on http.ClientException catch (e) {
      AppLogger.error('Network error during OpenAI TTS request', tag: 'OpenAITtsService', error: e);
      return Failure(SpeechSynthesisError.networkError());
    } on FormatException catch (e) {
      AppLogger.error('Invalid response format', tag: 'OpenAITtsService', error: e);
      return Failure(SpeechSynthesisError.unknown('Invalid response format: ${e.message}'));
    } catch (e, stackTrace) {
      // Step 12: Handle other exceptions (same as Python: raise HTTPException(500, f"OpenAI API error: {str(e)}"))
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        AppLogger.error('Request timeout', tag: 'OpenAITtsService', error: e);
        return Failure(const SpeechSynthesisError.timeout());
      }
      
      AppLogger.error('OpenAI API error', tag: 'OpenAITtsService', error: e, stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.serviceError('OpenAI API error: ${e.toString()}'));
    }
  }
  
  /// Maps HTTP status codes to domain errors
  /// 
  /// Maps OpenAI API error types to domain errors, matching the Python implementation
  SpeechSynthesisError _mapHttpErrorToDomainError(int statusCode, String body) {
    try {
      final jsonData = jsonDecode(body) as Map<String, dynamic>?;
      final error = jsonData?['error'] as Map<String, dynamic>?;
      
      if (error != null) {
        final type = error['type'] as String?;
        final message = error['message'] as String?;
        
        // Map OpenAI error types (same as Python HTTPException mapping)
        if (type == 'invalid_request_error') {
          return SpeechSynthesisError.validation(message ?? 'Invalid request');
        } else if (type == 'authentication_error') {
          return const SpeechSynthesisError.unauthorized();
        } else if (type == 'permission_error') {
          return const SpeechSynthesisError.forbidden();
        } else if (type == 'rate_limit_error') {
          return const SpeechSynthesisError.tooManyRequests();
        } else if (type == 'server_error') {
          return const SpeechSynthesisError.serviceUnavailable();
        }
        
        // Return service error with message
        if (message != null) {
          return SpeechSynthesisError.serviceError(message);
        }
      }
    } catch (e) {
      // If parsing fails, fall through to default
    }
    
    // Default error mapping
    switch (statusCode) {
      case 400:
        return SpeechSynthesisError.validation('Invalid request: $body');
      case 401:
        return const SpeechSynthesisError.unauthorized();
      case 403:
        return const SpeechSynthesisError.forbidden();
      case 429:
        return const SpeechSynthesisError.tooManyRequests();
      case 500:
      case 502:
      case 503:
        return const SpeechSynthesisError.serviceUnavailable();
      default:
        return SpeechSynthesisError.unknown('HTTP $statusCode: $body');
    }
  }
}

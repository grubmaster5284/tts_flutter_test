import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/constants/speech_synthesis_api_keys.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Remote service for speech synthesis API calls
class SpeechSynthesisRemoteService {
  final http.Client _client;
  
  // Constants for configuration
  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  
  SpeechSynthesisRemoteService(this._client);
  
  /// Synthesize speech from text
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> synthesizeSpeech(
    SpeechRequestDto request,
  ) async {
    return _retryOperation(
      () => _synthesizeSpeechInternal(request),
      maxRetries: _maxRetries,
    );
  }
  
  /// Internal method with proper error handling
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> _synthesizeSpeechInternal(
    SpeechRequestDto request,
  ) async {
    final url = SpeechSynthesisApiKeys.synthesizeUrl;
    final requestBody = jsonEncode(request.toJson());
    
    AppLogger.debug('Sending TTS request to backend', tag: 'TTSRemoteService', data: {
      'url': url,
      'service': request.service,
      'textLength': request.text.length,
      'voice': request.voice,
      'language': request.language,
      'audioFormat': request.audioFormat,
    });
    
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBody,
          )
          .timeout(_timeout);
      
      AppLogger.debug('Received response from backend', tag: 'TTSRemoteService', data: {
        'statusCode': response.statusCode,
        'bodyLength': response.body.length,
      });
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final dto = SpeechResponseDto.fromJson(jsonData);
        
        AppLogger.info('TTS request successful', tag: 'TTSRemoteService', data: {
          'format': dto.audioFormat,
          'duration': dto.durationMs,
        });
        
        return Success(dto);
      } else {
        AppLogger.warning('TTS request failed with status code', tag: 'TTSRemoteService', data: {
          'statusCode': response.statusCode,
          'body': response.body.substring(0, response.body.length > 200 ? 200 : response.body.length),
        });
        
        return Failure(
          _mapHttpErrorToDomainError(response.statusCode, response.body),
        );
      }
    } on http.ClientException catch (e) {
      AppLogger.error('Network error during TTS request', tag: 'TTSRemoteService', error: e);
      
      // Check if it's a connection refused error (backend not running)
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('errno = 61')) {
        return Failure(SpeechSynthesisError.unknown(
          'Backend server is not running.\n\nPlease start the Python backend server:\n1. Open terminal\n2. cd backend/python\n3. ./run.sh\n\nOr see BACKEND_START_GUIDE.md for details.'
        ));
      }
      
      return Failure(SpeechSynthesisError.networkError());
    } on FormatException catch (e) {
      AppLogger.error('Invalid response format', tag: 'TTSRemoteService', error: e);
      return Failure(SpeechSynthesisError.unknown('Invalid response format: ${e.message}'));
    } catch (e, stackTrace) {
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        AppLogger.error('Request timeout', tag: 'TTSRemoteService', error: e);
        return Failure(const SpeechSynthesisError.timeout());
      }
      AppLogger.error('Unexpected error during TTS request', 
          tag: 'TTSRemoteService',
          error: e,
          stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.unknown(e.toString()));
    }
  }
  
  /// Retry operation with exponential backoff
  Future<Result<T, SpeechSynthesisError>> _retryOperation<T>(
    Future<Result<T, SpeechSynthesisError>> Function() operation,
    {int maxRetries = 3}
  ) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      final result = await operation();
      
      if (result.isSuccess) {
        return result;
      }
      
      // Only retry on retryable errors
      if (result.isFailure) {
        final error = result.failure;
        if (error.isRetryable && attempt < maxRetries) {
          await Future.delayed(_retryDelay * attempt);
          continue;
        }
      }
      
      return result;
    }
    
    return Failure<T, SpeechSynthesisError>(const SpeechSynthesisError.timeout());
  }
  
  /// Map HTTP errors to domain errors
  SpeechSynthesisError _mapHttpErrorToDomainError(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        return SpeechSynthesisError.validation('Invalid request: $body');
      case 401:
        return const SpeechSynthesisError.unauthorized();
      case 403:
        return const SpeechSynthesisError.forbidden();
      case 429:
        return const SpeechSynthesisError.tooManyRequests();
      case 503:
        return const SpeechSynthesisError.serviceUnavailable();
      case 500:
      case 502:
      case 504:
        return SpeechSynthesisError.serviceError('Server error: $body');
      default:
        return SpeechSynthesisError.unknown('HTTP $statusCode: $body');
    }
  }
}


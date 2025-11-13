import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/constants/speech_synthesis_api_keys.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

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
    try {
      final response = await _client
          .post(
            Uri.parse(SpeechSynthesisApiKeys.synthesizeUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final dto = SpeechResponseDto.fromJson(jsonData);
        return Success(dto);
      } else {
        return Failure(
          _mapHttpErrorToDomainError(response.statusCode, response.body),
        );
      }
    } on http.ClientException {
      return Failure(SpeechSynthesisError.networkError());
    } on FormatException catch (e) {
      return Failure(SpeechSynthesisError.unknown('Invalid response format: ${e.message}'));
    } catch (e, _) {
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        return Failure(const SpeechSynthesisError.timeout());
      }
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


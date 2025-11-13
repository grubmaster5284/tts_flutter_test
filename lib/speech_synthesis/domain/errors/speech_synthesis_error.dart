import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_synthesis_error.freezed.dart';

/// Sealed error class for speech synthesis operations
@freezed
sealed class SpeechSynthesisError with _$SpeechSynthesisError implements Exception {
  // Validation errors
  const factory SpeechSynthesisError.validation(String message) = ValidationError;
  
  // Network errors
  const factory SpeechSynthesisError.timeout() = TimeoutError;
  const factory SpeechSynthesisError.networkError() = NetworkError;
  const factory SpeechSynthesisError.tooManyRequests() = TooManyRequestsError;
  
  // Authentication errors
  const factory SpeechSynthesisError.unauthorized() = UnauthorizedError;
  const factory SpeechSynthesisError.forbidden() = ForbiddenError;
  
  // Service errors
  const factory SpeechSynthesisError.serviceUnavailable() = ServiceUnavailableError;
  const factory SpeechSynthesisError.serviceError(String message) = ServiceError;
  
  // Unknown errors
  const factory SpeechSynthesisError.unknown(String message) = UnknownError;
}

extension SpeechSynthesisErrorExtension on SpeechSynthesisError {
  bool get isNetworkError =>
      this is TimeoutError || this is NetworkError || this is TooManyRequestsError;
  
  bool get isAuthError => this is UnauthorizedError || this is ForbiddenError;
  
  bool get isRetryable =>
      this is TimeoutError ||
      this is NetworkError ||
      this is TooManyRequestsError ||
      this is ServiceUnavailableError;
  
  String get userMessage => switch (this) {
    ValidationError(message: final msg) => 'Validation error: $msg',
    TimeoutError() => 'Request timed out. Please try again.',
    NetworkError() => 'Network error. Please check your connection.',
    TooManyRequestsError() => 'Too many requests. Please try again later.',
    UnauthorizedError() => 'Authentication failed. Please check your API key.',
    ForbiddenError() => 'Access forbidden. Please check your permissions.',
    ServiceUnavailableError() => 'Service temporarily unavailable. Please try again later.',
    ServiceError(message: final msg) => 'Service error: $msg',
    UnknownError(message: final msg) => 'An unexpected error occurred: $msg',
  };
}


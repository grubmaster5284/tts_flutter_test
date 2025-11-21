import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_synthesis_error.freezed.dart';

/// Sealed error class for speech synthesis operations
/// 
/// This is a sealed class (using Freezed) that represents all possible errors that can
/// occur during speech synthesis operations. Sealed classes ensure exhaustive pattern
/// matching, making error handling type-safe and complete.
/// 
/// Error categories:
/// - Validation errors: Invalid input data
/// - Network errors: Connection issues, timeouts, rate limiting
/// - Authentication errors: API key issues, permissions
/// - Service errors: TTS service failures
/// - Unknown errors: Unexpected errors
/// 
/// The extension provides helper methods for:
/// - Checking error types (isNetworkError, isAuthError, isRetryable)
/// - Getting user-friendly error messages (userMessage)
/// 
/// This is part of the Domain layer and provides a clean way to handle errors without
/// using exceptions, following functional programming principles.
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
    ServiceError(message: final msg) => _formatServiceErrorMessage(msg),
    UnknownError(message: final msg) => 'An unexpected error occurred: $msg',
  };
}

/// Format service error messages to be more user-friendly
/// Specifically handles billing errors and other common API errors
String _formatServiceErrorMessage(String message) {
  // Check for billing errors
  if (message.toLowerCase().contains('billing') || 
      message.toLowerCase().contains('billing_disable')) {
    // Extract project ID if present (look for "project" followed by optional #/space and digits)
    final projectId = _extractProjectId(message);
    if (projectId != null) {
      return 'Billing is not enabled for your Google Cloud project ($projectId).\n\n'
             'Please enable billing by visiting:\n'
             'https://console.developers.google.com/billing/enable?project=$projectId\n\n'
             'After enabling billing, wait a few minutes and try again.';
    }
    
    // Check if message contains a billing URL
    final url = _extractBillingUrl(message);
    if (url != null) {
      return 'Billing is not enabled for your Google Cloud project.\n\n'
             'Please enable billing by visiting:\n$url\n\n'
             'After enabling billing, wait a few minutes and try again.';
    }
    
    return 'Billing is not enabled for your Google Cloud project.\n\n'
           'Please enable billing in the Google Cloud Console and try again.';
  }
  
  // Return the original message if no special formatting is needed
  return message;
}

/// Extract project ID from error message
/// Looks for "project" followed by optional #/space and digits
String? _extractProjectId(String message) {
  final projectIndex = message.toLowerCase().indexOf('project');
  if (projectIndex == -1) return null;
  
  // Start searching after "project"
  var startIndex = projectIndex + 7; // "project" is 7 characters
  // Skip optional # and whitespace
  while (startIndex < message.length && 
         (message[startIndex] == '#' || message[startIndex] == ' ' || message[startIndex] == '\t')) {
    startIndex++;
  }
  
  // Extract digits
  if (startIndex >= message.length) return null;
  var endIndex = startIndex;
  while (endIndex < message.length && 
         message.codeUnitAt(endIndex) >= '0'.codeUnitAt(0) && 
         message.codeUnitAt(endIndex) <= '9'.codeUnitAt(0)) {
    endIndex++;
  }
  
  if (endIndex > startIndex) {
    return message.substring(startIndex, endIndex);
  }
  return null;
}

/// Extract billing URL from error message
String? _extractBillingUrl(String message) {
  const urlPrefix = 'https://console.developers.google.com/billing/enable';
  final urlIndex = message.indexOf(urlPrefix);
  if (urlIndex == -1) return null;
  
  // Find the end of the URL (stop at whitespace or end of string)
  var endIndex = urlIndex + urlPrefix.length;
  while (endIndex < message.length && 
         message.codeUnitAt(endIndex) != ' '.codeUnitAt(0) &&
         message.codeUnitAt(endIndex) != '\n'.codeUnitAt(0) &&
         message.codeUnitAt(endIndex) != '\t'.codeUnitAt(0) &&
         message.codeUnitAt(endIndex) != '\r'.codeUnitAt(0)) {
    endIndex++;
  }
  
  return message.substring(urlIndex, endIndex);
}


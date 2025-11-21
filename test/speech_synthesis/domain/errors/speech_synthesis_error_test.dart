import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

void main() {
  group('SpeechSynthesisError', () {
    group('validation errors', () {
      test('should create validation error with message', () {
        const error = SpeechSynthesisError.validation('Invalid input');
        
        expect(error, isA<ValidationError>());
        expect((error as ValidationError).message, 'Invalid input');
      });
    });

    group('network errors', () {
      test('should create timeout error', () {
        const error = SpeechSynthesisError.timeout();
        
        expect(error, isA<TimeoutError>());
      });

      test('should create network error', () {
        const error = SpeechSynthesisError.networkError();
        
        expect(error, isA<NetworkError>());
      });

      test('should create too many requests error', () {
        const error = SpeechSynthesisError.tooManyRequests();
        
        expect(error, isA<TooManyRequestsError>());
      });
    });

    group('authentication errors', () {
      test('should create unauthorized error', () {
        const error = SpeechSynthesisError.unauthorized();
        
        expect(error, isA<UnauthorizedError>());
      });

      test('should create forbidden error', () {
        const error = SpeechSynthesisError.forbidden();
        
        expect(error, isA<ForbiddenError>());
      });
    });

    group('service errors', () {
      test('should create service unavailable error', () {
        const error = SpeechSynthesisError.serviceUnavailable();
        
        expect(error, isA<ServiceUnavailableError>());
      });

      test('should create service error with message', () {
        const error = SpeechSynthesisError.serviceError('Service failure');
        
        expect(error, isA<ServiceError>());
        expect((error as ServiceError).message, 'Service failure');
      });
    });

    group('unknown errors', () {
      test('should create unknown error with message', () {
        const error = SpeechSynthesisError.unknown('Unexpected error');
        
        expect(error, isA<UnknownError>());
        expect((error as UnknownError).message, 'Unexpected error');
      });
    });

    group('extension methods', () {
      group('isNetworkError', () {
        test('should return true for network-related errors', () {
          expect(SpeechSynthesisError.timeout().isNetworkError, isTrue);
          expect(SpeechSynthesisError.networkError().isNetworkError, isTrue);
          expect(SpeechSynthesisError.tooManyRequests().isNetworkError, isTrue);
        });

        test('should return false for non-network errors', () {
          expect(SpeechSynthesisError.validation('test').isNetworkError, isFalse);
          expect(SpeechSynthesisError.unauthorized().isNetworkError, isFalse);
          expect(SpeechSynthesisError.serviceError('test').isNetworkError, isFalse);
        });
      });

      group('isAuthError', () {
        test('should return true for authentication errors', () {
          expect(SpeechSynthesisError.unauthorized().isAuthError, isTrue);
          expect(SpeechSynthesisError.forbidden().isAuthError, isTrue);
        });

        test('should return false for non-auth errors', () {
          expect(SpeechSynthesisError.validation('test').isAuthError, isFalse);
          expect(SpeechSynthesisError.networkError().isAuthError, isFalse);
        });
      });

      group('isRetryable', () {
        test('should return true for retryable errors', () {
          expect(SpeechSynthesisError.timeout().isRetryable, isTrue);
          expect(SpeechSynthesisError.networkError().isRetryable, isTrue);
          expect(SpeechSynthesisError.tooManyRequests().isRetryable, isTrue);
          expect(SpeechSynthesisError.serviceUnavailable().isRetryable, isTrue);
        });

        test('should return false for non-retryable errors', () {
          expect(SpeechSynthesisError.validation('test').isRetryable, isFalse);
          expect(SpeechSynthesisError.unauthorized().isRetryable, isFalse);
          expect(SpeechSynthesisError.forbidden().isRetryable, isFalse);
        });
      });

      group('userMessage', () {
        test('should return user-friendly message for validation error', () {
          const error = SpeechSynthesisError.validation('Invalid input');
          expect(error.userMessage, 'Validation error: Invalid input');
        });

        test('should return user-friendly message for timeout', () {
          const error = SpeechSynthesisError.timeout();
          expect(error.userMessage, 'Request timed out. Please try again.');
        });

        test('should return user-friendly message for network error', () {
          const error = SpeechSynthesisError.networkError();
          expect(error.userMessage, 'Network error. Please check your connection.');
        });

        test('should return user-friendly message for too many requests', () {
          const error = SpeechSynthesisError.tooManyRequests();
          expect(error.userMessage, 'Too many requests. Please try again later.');
        });

        test('should return user-friendly message for unauthorized', () {
          const error = SpeechSynthesisError.unauthorized();
          expect(error.userMessage, 'Authentication failed. Please check your API key.');
        });

        test('should return user-friendly message for forbidden', () {
          const error = SpeechSynthesisError.forbidden();
          expect(error.userMessage, 'Access forbidden. Please check your permissions.');
        });

        test('should return user-friendly message for service unavailable', () {
          const error = SpeechSynthesisError.serviceUnavailable();
          expect(error.userMessage, 'Service temporarily unavailable. Please try again later.');
        });

        test('should return user-friendly message for service error', () {
          const error = SpeechSynthesisError.serviceError('Service failure');
          expect(error.userMessage, 'Service error: Service failure');
        });

        test('should return user-friendly message for unknown error', () {
          const error = SpeechSynthesisError.unknown('Unexpected error');
          expect(error.userMessage, 'An unexpected error occurred: Unexpected error');
        });
      });
    });
  });
}


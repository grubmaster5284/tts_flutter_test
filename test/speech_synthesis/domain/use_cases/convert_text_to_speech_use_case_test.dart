import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result_type/result_type.dart' show Success, Failure, Result;
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/use_cases/convert_text_to_speech_use_case.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/text_vo.dart';

import 'convert_text_to_speech_use_case_test.mocks.dart';

// Provide dummy values for Mockito
@GenerateMocks([ISpeechSynthesisRepository])
void main() {
  // Provide dummy Result value for Mockito before any tests run
  setUpAll(() {
    provideDummy<Result<SpeechResponseModel, SpeechSynthesisError>>(
      Failure(const SpeechSynthesisError.unknown('dummy')),
    );
  });
  
  group('ConvertTextToSpeechUseCase', () {
    late MockISpeechSynthesisRepository mockRepository;
    late ConvertTextToSpeechUseCase useCase;
    late SpeechRequestModel request;
    late SpeechResponseModel response;

    setUp(() {
      mockRepository = MockISpeechSynthesisRepository();
      useCase = ConvertTextToSpeechUseCase(mockRepository);
      
      request = SpeechRequestModel(
        text: TextVO('Hello, world!'),
        service: TTSServiceModel.gemini,
      );
      
      response = SpeechResponseModel(
        audioData: 'base64audiodata',
        audioFormat: AudioFormatVO('mp3'),
        durationMs: 5000,
      );
    });

    group('execute', () {
      test('should return success when repository succeeds', () async {
        // Arrange
        when(mockRepository.convertTextToSpeech(request))
            .thenAnswer((_) async => Success(response));

        // Act
        final result = await useCase.execute(request);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.success, response);
        verify(mockRepository.convertTextToSpeech(request)).called(1);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        const error = SpeechSynthesisError.networkError();
        when(mockRepository.convertTextToSpeech(request))
            .thenAnswer((_) async => Failure(error));

        // Act
        final result = await useCase.execute(request);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, error);
        verify(mockRepository.convertTextToSpeech(request)).called(1);
      });

      test('should propagate validation error from repository', () async {
        // Arrange
        const error = SpeechSynthesisError.validation('Invalid input');
        when(mockRepository.convertTextToSpeech(request))
            .thenAnswer((_) async => Failure(error));

        // Act
        final result = await useCase.execute(request);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ValidationError>());
      });

      test('should propagate service error from repository', () async {
        // Arrange
        const error = SpeechSynthesisError.serviceError('Service unavailable');
        when(mockRepository.convertTextToSpeech(request))
            .thenAnswer((_) async => Failure(error));

        // Act
        final result = await useCase.execute(request);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ServiceError>());
      });
    });
  });
}


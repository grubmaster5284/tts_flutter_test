import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// Use case for converting text to speech
/// 
/// Use cases represent application-specific business rules and orchestrate domain operations.
/// They encapsulate a single business action and coordinate between domain entities and repositories.
/// This follows the Clean Architecture principle where use cases are part of the Domain layer
/// and define what the application can do, independent of UI or data source details.
/// 
/// In this case, the use case is simple and delegates to the repository, but it provides
/// a clear boundary for future business logic (e.g., validation, transformation, etc.).
class ConvertTextToSpeechUseCase {
  final ISpeechSynthesisRepository _repository;
  
  ConvertTextToSpeechUseCase(this._repository);
  
  /// Execute the text-to-speech conversion
  /// 
  /// This method orchestrates the TTS conversion by calling the repository.
  /// The use case pattern allows for easy extension with additional business logic
  /// (e.g., logging, analytics, validation) without changing the repository interface.
  /// 
  /// Returns [Result.success] with [SpeechResponseModel] on success.
  /// Returns [Result.failure] with [SpeechSynthesisError] on failure.
  Future<Result<SpeechResponseModel, SpeechSynthesisError>> execute(
    SpeechRequestModel request,
  ) async {
    return await _repository.convertTextToSpeech(request);
  }
}


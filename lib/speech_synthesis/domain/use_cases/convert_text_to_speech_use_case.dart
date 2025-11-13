import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// Use case for converting text to speech
class ConvertTextToSpeechUseCase {
  final ISpeechSynthesisRepository _repository;
  
  ConvertTextToSpeechUseCase(this._repository);
  
  /// Execute the text-to-speech conversion
  /// 
  /// Returns [Result.success] with [SpeechResponseModel] on success.
  /// Returns [Result.failure] with [SpeechSynthesisError] on failure.
  Future<Result<SpeechResponseModel, SpeechSynthesisError>> execute(
    SpeechRequestModel request,
  ) async {
    return await _repository.convertTextToSpeech(request);
  }
}


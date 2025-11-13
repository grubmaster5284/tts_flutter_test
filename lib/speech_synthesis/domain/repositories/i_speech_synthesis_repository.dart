import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Repository interface for speech synthesis operations
abstract class ISpeechSynthesisRepository {
  /// Convert text to speech using the specified service
  /// 
  /// Returns [Result.success] with [SpeechResponseModel] on success.
  /// Returns [Result.failure] with [SpeechSynthesisError] on failure.
  Future<Result<SpeechResponseModel, SpeechSynthesisError>> convertTextToSpeech(
    SpeechRequestModel request,
  );
}


import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Repository interface for speech synthesis operations
/// 
/// This is an abstract interface that defines the contract for speech synthesis operations.
/// It follows the Repository pattern from clean architecture, which abstracts data sources
/// and provides a clean API for the domain layer. Implementations of this interface handle
/// the actual data fetching (from APIs, local cache, etc.) without exposing those details
/// to the domain layer.
/// 
/// This interface is part of the Domain layer and defines what operations are available,
/// while the implementation (SpeechSynthesisRepositoryImpl) is in the Data layer.
abstract class ISpeechSynthesisRepository {
  /// Convert text to speech using the specified service
  /// 
  /// This method takes a SpeechRequestModel (domain entity) and returns a Result type
  /// that can be either success (with SpeechResponseModel) or failure (with SpeechSynthesisError).
  /// The Result type provides type-safe error handling without exceptions.
  /// 
  /// Returns [Result.success] with [SpeechResponseModel] on success.
  /// Returns [Result.failure] with [SpeechSynthesisError] on failure.
  Future<Result<SpeechResponseModel, SpeechSynthesisError>> convertTextToSpeech(
    SpeechRequestModel request,
  );
}


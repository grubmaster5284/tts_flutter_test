// [NEW] TTS Service Factory - creates appropriate TTS service instances
import 'package:http/http.dart' as http;
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/gemini_tts_remote_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/openai_tts_remote_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/polly_tts_remote_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';

/// Factory for creating TTS service instances
/// 
/// This factory creates the appropriate TTS service based on the service type.
/// It follows the Factory pattern to centralize service instantiation and make
/// it easy to add new services in the future.
/// 
/// ## Usage:
/// ```dart
/// final factory = TtsServiceFactory();
/// final service = factory.createService(TTSServiceModel.gemini);
/// final result = await service.synthesizeSpeech(request);
/// ```
/// 
/// ## Supported Services:
/// - **Gemini**: Google Cloud Text-to-Speech API
/// - **OpenAI**: OpenAI TTS API
/// - **Polly**: AWS Polly TTS (future implementation)
/// 
/// ## Benefits:
/// - **Centralized Creation**: All service instantiation in one place
/// - **Easy Extension**: Add new services by extending the factory
/// - **Dependency Injection**: HTTP client is created and injected
/// - **Type Safety**: Returns the correct service type based on enum
/// 
/// This is part of the Data layer and follows data layer conventions.
class TtsServiceFactory {
  /// HTTP client for TTS services
  /// 
  /// Shared across all services for connection pooling and efficiency.
  final http.Client _client;
  
  /// Constructor that initializes the factory with an HTTP client
  /// 
  /// **Dependency Injection**: HTTP client is injected via constructor,
  /// making the factory testable (can inject mock client).
  /// 
  /// **Parameters:**
  /// - `client`: HTTP client instance (defaults to new http.Client if not provided)
  TtsServiceFactory([http.Client? client]) : _client = client ?? http.Client();
  
  /// Creates the appropriate TTS service based on service type
  /// 
  /// **Parameters:**
  /// - `serviceType`: The TTS service type (gemini, openai, polly)
  /// 
  /// **Returns:**
  /// - `GeminiTtsRemoteService`: For Gemini service
  /// - `OpenAITtsRemoteService`: For OpenAI service
  /// - `PollyTtsRemoteService`: For Polly service
  /// 
  /// **Note**: All services implement the same interface (synthesizeSpeech method),
  /// so they can be used interchangeably via the factory pattern.
  dynamic createService(TTSServiceModel serviceType) {
    switch (serviceType) {
      case TTSServiceModel.gemini:
        return GeminiTtsRemoteService(_client);
      case TTSServiceModel.openai:
        return OpenAITtsRemoteService(_client);
      case TTSServiceModel.polly:
        return PollyTtsRemoteService(_client);
    }
  }
  
  /// Gets the service name for logging/debugging
  /// 
  /// **Parameters:**
  /// - `serviceType`: The TTS service type
  /// 
  /// **Returns:**
  /// - `String`: Human-readable service name
  String getServiceName(TTSServiceModel serviceType) {
    return serviceType.name;
  }
}


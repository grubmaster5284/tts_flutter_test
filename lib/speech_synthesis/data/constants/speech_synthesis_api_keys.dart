/// API endpoint constants for speech synthesis
/// 
/// ## What are Constants?
/// Constants are values that don't change during runtime. This class centralizes
/// all API endpoint URLs and configuration, making it easy to:
/// - Update URLs in one place
/// - Switch between environments (dev, staging, production)
/// - Maintain consistency across the codebase
/// 
/// ## Why Use an Abstract Class?
/// An abstract class with static members is a common Dart pattern for constants:
/// - **Cannot be instantiated**: Prevents creating instances (constants don't need instances)
/// - **Static members**: Can be accessed without creating an instance
/// - **Namespace**: Groups related constants together
/// 
/// ## Architecture:
/// [NEW] This app now uses pure Dart TTS services that make direct HTTP calls to TTS APIs:
/// - **Flutter App** → **Pure Dart TTS Services** → **TTS APIs** (Google Cloud, OpenAI, AWS)
/// 
/// The app makes direct API calls to:
/// - **Google Cloud TTS**: `https://texttospeech.googleapis.com/v1/text:synthesize`
/// - **OpenAI TTS**: `https://api.openai.com/v1/audio/speech`
/// - **AWS Polly**: (future implementation)
/// 
/// **Benefits of direct API calls:**
/// - **No Python dependency**: Pure Flutter/Dart codebase
/// - **Cross-platform**: Works on all Flutter platforms (iOS, Android, Web, Desktop)
/// - **Better performance**: Direct HTTP calls, no subprocess overhead
/// - **Easier maintenance**: Single codebase, no process spawning
/// 
/// [LEGACY] Old backend architecture (commented out):
/// - **Base URL**: `http://localhost:8000` (Python FastAPI backend - no longer used)
/// - **Endpoint**: `/api/v1/tts/synthesize` (REST API endpoint - no longer used)
/// 
/// **Note**: The old backend code has been moved to `_legacy/backend/python/` for rollback capability.
abstract class SpeechSynthesisApiKeys {
  // [LEGACY] Old backend constants - kept for reference but no longer used
  // The app now makes direct API calls to TTS providers (Google Cloud, OpenAI, AWS)
  
  /// [LEGACY] Base URL for the Python backend TTS API (no longer used)
  /// 
  /// **Status**: This constant is kept for reference but is no longer used.
  /// The app now makes direct HTTP calls to TTS APIs.
  /// 
  /// **Old Usage**: `http://localhost:8000` (Python FastAPI backend)
  /// **New Architecture**: Direct API calls to TTS providers
  @Deprecated('No longer used - app makes direct API calls to TTS providers')
  static const String baseUrl = 'http://localhost:8000';
  
  /// [LEGACY] API endpoint path for TTS synthesis (no longer used)
  /// 
  /// **Status**: This constant is kept for reference but is no longer used.
  /// The app now makes direct HTTP calls to TTS APIs.
  /// 
  /// **Old Usage**: `/api/v1/tts/synthesize` (Python backend endpoint)
  /// **New Architecture**: Direct API calls to TTS providers
  @Deprecated('No longer used - app makes direct API calls to TTS providers')
  static const String synthesizeEndpoint = '/api/v1/tts/synthesize';
  
  /// [LEGACY] Gets the full URL for the synthesize endpoint (no longer used)
  /// 
  /// **Status**: This getter is kept for reference but is no longer used.
  /// The app now makes direct HTTP calls to TTS APIs.
  /// 
  /// **Old Usage**: `http://localhost:8000/api/v1/tts/synthesize` (Python backend)
  /// **New Architecture**: Direct API calls to TTS providers
  @Deprecated('No longer used - app makes direct API calls to TTS providers')
  static String get synthesizeUrl => '$baseUrl$synthesizeEndpoint';
  
  // [NEW] Direct TTS API endpoints (used by pure Dart services)
  
  /// Google Cloud Text-to-Speech API endpoint
  /// 
  /// **URL**: `https://texttospeech.googleapis.com/v1/text:synthesize`
  /// **Used by**: `GeminiTtsRemoteService`
  static const String googleCloudTtsUrl = 'https://texttospeech.googleapis.com/v1/text:synthesize';
  
  /// OpenAI Text-to-Speech API endpoint
  /// 
  /// **URL**: `https://api.openai.com/v1/audio/speech`
  /// **Used by**: `OpenAITtsRemoteService`
  static const String openaiTtsUrl = 'https://api.openai.com/v1/audio/speech';
  
  /// AWS Polly Text-to-Speech API endpoint (future implementation)
  /// 
  /// **URL**: `https://polly.{region}.amazonaws.com/v1/speech`
  /// **Used by**: `PollyTtsRemoteService` (future)
  /// **Note**: Region will be configurable
  static String getPollyTtsUrl(String region) => 'https://polly.$region.amazonaws.com/v1/speech';
}


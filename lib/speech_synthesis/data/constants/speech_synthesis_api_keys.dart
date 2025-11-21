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
/// ## Backend Architecture:
/// This app uses a Python backend (FastAPI) that handles TTS API calls:
/// - **Flutter App** → **Python Backend** (localhost:8000) → **TTS APIs**
/// 
/// The backend provides a REST API that:
/// - Accepts TTS requests from the Flutter app
/// - Calls TTS APIs (Google Gemini, OpenAI, AWS Polly) server-side
/// - Returns audio data to the Flutter app
/// 
/// **Why use a backend?**
/// - **Security**: API keys are stored server-side, not in the app
/// - **Flexibility**: Can switch TTS providers without app updates
/// - **Rate Limiting**: Backend can implement rate limiting
/// - **Python Libraries**: Easier to use Python TTS libraries
/// 
/// ## URL Structure:
/// - **Base URL**: `http://localhost:8000` (local development server)
/// - **Endpoint**: `/api/v1/tts/synthesize` (REST API endpoint)
/// - **Full URL**: `http://localhost:8000/api/v1/tts/synthesize`
/// 
/// **Note**: For production, change `baseUrl` to the production server URL.
abstract class SpeechSynthesisApiKeys {
  /// Base URL for the Python backend TTS API
  /// 
  /// **Development**: `http://localhost:8000`
  /// - Points to local Python backend server
  /// - Used during development and testing
  /// 
  /// **Production**: Should be changed to production server URL
  /// - Example: `https://api.example.com`
  /// - Should use HTTPS for security
  /// 
  /// **Port 8000**: Default port for Python FastAPI development server
  /// - Can be changed in backend configuration
  /// - Must match the port the backend is running on
  static const String baseUrl = 'http://localhost:8000';
  
  /// API endpoint path for TTS synthesis
  /// 
  /// **REST API Convention:**
  /// - `/api`: API namespace
  /// - `/v1`: API version (allows for future API versions)
  /// - `/tts`: TTS service namespace
  /// - `/synthesize`: Action (synthesize text to speech)
  /// 
  /// **HTTP Method**: POST (sends request body with text, voice, etc.)
  /// 
  /// **Request Format**: JSON
  /// ```json
  /// {
  ///   "text": "Hello world",
  ///   "service": "gemini",
  ///   "voice": "en-US-Standard-A",
  ///   "language": "en",
  ///   "audio_format": "mp3"
  /// }
  /// ```
  /// 
  /// **Response Format**: JSON
  /// ```json
  /// {
  ///   "audio_data": "base64_encoded_audio",
  ///   "audio_format": "mp3",
  ///   "duration_ms": 5000,
  ///   "metadata": "{\"voice\": \"en-US-Standard-A\"}"
  /// }
  /// ```
  static const String synthesizeEndpoint = '/api/v1/tts/synthesize';
  
  /// Gets the full URL for the synthesize endpoint
  /// 
  /// **Getter**: This is a computed property that combines `baseUrl` and `synthesizeEndpoint`
  /// to create the complete URL for TTS synthesis requests.
  /// 
  /// **Returns:**
  /// - `String`: Full URL (e.g., `http://localhost:8000/api/v1/tts/synthesize`)
  /// 
  /// **Usage:**
  /// ```dart
  /// final url = SpeechSynthesisApiKeys.synthesizeUrl;
  /// // Use url in HTTP request
  /// ```
  static String get synthesizeUrl => '$baseUrl$synthesizeEndpoint';
}


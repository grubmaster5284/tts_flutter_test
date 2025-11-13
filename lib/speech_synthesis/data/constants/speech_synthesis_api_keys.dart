/// API endpoint constants for speech synthesis
abstract class SpeechSynthesisApiKeys {
  // Base URL for the Python backend TTS API
  static const String baseUrl = 'http://localhost:8000';
  
  // API endpoints
  static const String synthesizeEndpoint = '/api/v1/tts/synthesize';
  
  /// Get the full URL for the synthesize endpoint
  static String get synthesizeUrl => '$baseUrl$synthesizeEndpoint';
}


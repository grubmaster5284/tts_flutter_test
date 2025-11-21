/// Domain entity representing available TTS service providers
/// 
/// This enum represents the different text-to-speech service providers supported by the app.
/// Enums in Dart are a type-safe way to represent a fixed set of constants. This enum
/// is part of the Domain layer and represents a core business concept.
/// 
/// The extension provides:
/// - name: Human-readable name for UI display
/// - value: String identifier for API/service communication
/// - fromString: Factory method to convert string to enum
enum TTSServiceModel {
  gemini,
  openai,
  polly,
}

extension TTSServiceModelExtension on TTSServiceModel {
  String get name {
    switch (this) {
      case TTSServiceModel.gemini:
        return 'Gemini';
      case TTSServiceModel.openai:
        return 'OpenAI';
      case TTSServiceModel.polly:
        return 'Amazon Polly';
    }
  }
  
  String get value {
    switch (this) {
      case TTSServiceModel.gemini:
        return 'gemini';
      case TTSServiceModel.openai:
        return 'openai';
      case TTSServiceModel.polly:
        return 'polly';
    }
  }
  
  static TTSServiceModel? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'gemini':
        return TTSServiceModel.gemini;
      case 'openai':
        return TTSServiceModel.openai;
      case 'polly':
        return TTSServiceModel.polly;
      default:
        return null;
    }
  }
}


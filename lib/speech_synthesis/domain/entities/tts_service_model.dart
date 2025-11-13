/// Represents available TTS service providers
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


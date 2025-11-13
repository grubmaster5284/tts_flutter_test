import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for language code (ISO 639-1 format) with validation
class LanguageVO {
  final String value;
  
  static const int length = 2;
  static final RegExp _validPattern = RegExp(r'^[a-z]{2}$');
  
  LanguageVO(this.value) {
    if (value.isEmpty) {
      throw const SpeechSynthesisError.validation('Language code cannot be empty');
    }
    if (value.length != length) {
      throw SpeechSynthesisError.validation(
        'Language code must be exactly $length characters (ISO 639-1 format)',
      );
    }
    if (!_validPattern.hasMatch(value)) {
      throw const SpeechSynthesisError.validation(
        'Language code must be in ISO 639-1 format (e.g., "en", "es", "fr")',
      );
    }
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageVO &&
          runtimeType == other.runtimeType &&
          value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'LanguageVO($value)';
}


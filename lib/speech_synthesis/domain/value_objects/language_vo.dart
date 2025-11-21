import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for language code (ISO 639-1 format) with validation
/// 
/// Value objects are immutable objects that represent a descriptive aspect of the domain
/// with no conceptual identity. They are defined by their attributes rather than an ID.
/// 
/// This value object encapsulates a language code with validation rules:
/// - Must be exactly 2 characters (ISO 639-1 format, e.g., "en", "es", "fr")
/// - Must be lowercase letters only
/// - Cannot be empty
/// 
/// Value objects ensure data integrity at the domain level and prevent invalid data
/// from entering the system. They are part of the Domain layer in clean architecture.
class LanguageVO {
  final String value;
  
  static const int length = 2;
  
  LanguageVO(this.value) {
    if (value.isEmpty) {
      throw const SpeechSynthesisError.validation('Language code cannot be empty');
    }
    if (value.length != length) {
      throw SpeechSynthesisError.validation(
        'Language code must be exactly $length characters (ISO 639-1 format)',
      );
    }
    // Validate that all characters are lowercase letters (a-z)
    if (!value.runes.every((rune) => rune >= 'a'.codeUnitAt(0) && rune <= 'z'.codeUnitAt(0))) {
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


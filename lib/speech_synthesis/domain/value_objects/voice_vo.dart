import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for voice identifier with validation
/// 
/// Value objects are immutable objects that represent a descriptive aspect of the domain
/// with no conceptual identity. They are defined by their attributes rather than an ID.
/// 
/// This value object encapsulates a voice identifier with validation rules:
/// - Minimum length: 1 character
/// - Maximum length: 100 characters
/// - Must match pattern: alphanumeric characters, underscores, and hyphens only
/// - Cannot be empty
/// 
/// Value objects ensure data integrity at the domain level and prevent invalid data
/// from entering the system. They are part of the Domain layer in clean architecture.
class VoiceVO {
  final String value;
  
  static const int minLength = 1;
  static const int maxLength = 100;
  
  VoiceVO(this.value) {
    if (value.isEmpty) {
      throw const SpeechSynthesisError.validation('Voice identifier cannot be empty');
    }
    if (value.length < minLength || value.length > maxLength) {
      throw SpeechSynthesisError.validation(
        'Voice identifier must be between $minLength and $maxLength characters',
      );
    }
    // Validate that all characters are alphanumeric, underscore, or hyphen
    if (!value.runes.every((rune) {
      return (rune >= 'a'.codeUnitAt(0) && rune <= 'z'.codeUnitAt(0)) ||
          (rune >= 'A'.codeUnitAt(0) && rune <= 'Z'.codeUnitAt(0)) ||
          (rune >= '0'.codeUnitAt(0) && rune <= '9'.codeUnitAt(0)) ||
          rune == '_'.codeUnitAt(0) ||
          rune == '-'.codeUnitAt(0);
    })) {
      throw const SpeechSynthesisError.validation(
        'Voice identifier contains invalid characters',
      );
    }
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceVO &&
          runtimeType == other.runtimeType &&
          value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'VoiceVO($value)';
}


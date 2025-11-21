import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for text input with validation
/// 
/// Value objects are immutable objects that represent a descriptive aspect of the domain
/// with no conceptual identity. They are defined by their attributes rather than an ID.
/// 
/// This value object encapsulates text input with validation rules:
/// - Minimum length: 1 character
/// - Maximum length: 5000 characters
/// - Cannot be empty
/// 
/// Value objects ensure data integrity at the domain level and prevent invalid data
/// from entering the system. They are part of the Domain layer in clean architecture.
class TextVO {
  final String value;
  
  static const int minLength = 1;
  static const int maxLength = 5000;
  
  TextVO(this.value) {
    if (value.isEmpty) {
      throw const SpeechSynthesisError.validation('Text cannot be empty');
    }
    if (value.length < minLength) {
      throw SpeechSynthesisError.validation(
        'Text must be at least $minLength character(s)',
      );
    }
    if (value.length > maxLength) {
      throw SpeechSynthesisError.validation(
        'Text must not exceed $maxLength characters',
      );
    }
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextVO &&
          runtimeType == other.runtimeType &&
          value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'TextVO($value)';
}


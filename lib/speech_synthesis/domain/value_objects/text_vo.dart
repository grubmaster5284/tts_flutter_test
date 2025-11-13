import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for text input with validation
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


import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for voice identifier with validation
class VoiceVO {
  final String value;
  
  static const int minLength = 1;
  static const int maxLength = 100;
  static final RegExp _validPattern = RegExp(r'^[a-zA-Z0-9_-]+$');
  
  VoiceVO(this.value) {
    if (value.isEmpty) {
      throw const SpeechSynthesisError.validation('Voice identifier cannot be empty');
    }
    if (value.length < minLength || value.length > maxLength) {
      throw SpeechSynthesisError.validation(
        'Voice identifier must be between $minLength and $maxLength characters',
      );
    }
    if (!_validPattern.hasMatch(value)) {
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


import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for audio format with validation
/// 
/// Value objects are immutable objects that represent a descriptive aspect of the domain
/// with no conceptual identity. They are defined by their attributes rather than an ID.
/// 
/// This value object encapsulates an audio format with validation rules:
/// - Must be one of the supported formats: mp3, wav, ogg, aac, flac
/// - Format is case-insensitive (normalized to lowercase)
/// - Cannot be empty
/// 
/// Value objects ensure data integrity at the domain level and prevent invalid data
/// from entering the system. They are part of the Domain layer in clean architecture.
class AudioFormatVO {
  final String value;
  
  static const List<String> validFormats = ['mp3', 'wav', 'ogg', 'aac', 'flac'];
  
  AudioFormatVO(this.value) {
    if (value.isEmpty) {
      throw const SpeechSynthesisError.validation('Audio format cannot be empty');
    }
    if (!validFormats.contains(value.toLowerCase())) {
      throw SpeechSynthesisError.validation(
        'Audio format must be one of: ${validFormats.join(", ")}',
      );
    }
  }
  
  String get normalizedValue => value.toLowerCase();
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioFormatVO &&
          runtimeType == other.runtimeType &&
          normalizedValue == other.normalizedValue;
  
  @override
  int get hashCode => normalizedValue.hashCode;
  
  @override
  String toString() => 'AudioFormatVO($value)';
}


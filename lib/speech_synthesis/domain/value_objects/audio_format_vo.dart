import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';

/// Value object for audio format with validation
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


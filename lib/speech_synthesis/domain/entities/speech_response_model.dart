import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';

part 'speech_response_model.freezed.dart';

/// Domain entity for speech synthesis response
/// 
/// This is a domain entity that represents the result of a text-to-speech conversion.
/// Domain entities are part of the Domain layer in clean architecture and represent
/// core business concepts. They are independent of frameworks and data sources.
/// 
/// This entity contains:
/// - audioData: The audio file path (after being saved to disk) or base64 encoded data
/// - audioFormat: The format of the audio (mp3, wav, etc.) as a value object
/// - durationMs: The duration of the audio in milliseconds
/// - metadata: Optional metadata as a JSON string
/// 
/// It uses Freezed to generate immutable classes with copyWith methods.
@freezed
class SpeechResponseModel with _$SpeechResponseModel {
  const factory SpeechResponseModel({
    required String audioData, // Base64 encoded audio data
    required AudioFormatVO audioFormat,
    required int durationMs, // Duration in milliseconds
    String? metadata, // Optional metadata JSON string
  }) = _SpeechResponseModel;
}


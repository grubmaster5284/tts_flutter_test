import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';

part 'speech_response_model.freezed.dart';

/// Domain entity for speech synthesis response
@freezed
class SpeechResponseModel with _$SpeechResponseModel {
  const factory SpeechResponseModel({
    required String audioData, // Base64 encoded audio data
    required AudioFormatVO audioFormat,
    required int durationMs, // Duration in milliseconds
    String? metadata, // Optional metadata JSON string
  }) = _SpeechResponseModel;
}


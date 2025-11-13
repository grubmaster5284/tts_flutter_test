import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';

part 'speech_response_dto.freezed.dart';
part 'speech_response_dto.g.dart';

/// Data Transfer Object for speech synthesis response
@freezed
class SpeechResponseDto with _$SpeechResponseDto {
  const factory SpeechResponseDto({
    required String audioData, // Base64 encoded audio
    required String audioFormat,
    required int durationMs,
    String? metadata,
  }) = _SpeechResponseDto;
  
  factory SpeechResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SpeechResponseDtoFromJson(json);
}

/// Extension to convert DTO to domain model
extension SpeechResponseDtoExtension on SpeechResponseDto {
  SpeechResponseModel toDomain() {
    return SpeechResponseModel(
      audioData: audioData,
      audioFormat: AudioFormatVO(audioFormat),
      durationMs: durationMs,
      metadata: metadata,
    );
  }
}


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';

part 'speech_request_dto.freezed.dart';
part 'speech_request_dto.g.dart';

/// Data Transfer Object for speech synthesis request
@freezed
class SpeechRequestDto with _$SpeechRequestDto {
  const factory SpeechRequestDto({
    required String text,
    required String service, // 'gemini', 'openai', or 'polly'
    String? voice,
    String? language, // ISO 639-1 format
    @Default('mp3') String audioFormat,
  }) = _SpeechRequestDto;
  
  factory SpeechRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SpeechRequestDtoFromJson(json);
  
  factory SpeechRequestDto.fromDomain(SpeechRequestModel model) {
    // Access the value through the extension
    final serviceValue = model.service.value;
    return SpeechRequestDto(
      text: model.text.value,
      service: serviceValue,
      voice: model.voice?.value,
      language: model.language?.value,
      audioFormat: model.audioFormat?.value ?? 'mp3',
    );
  }
}


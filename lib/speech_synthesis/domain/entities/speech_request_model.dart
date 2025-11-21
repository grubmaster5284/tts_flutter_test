import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/language_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/text_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/voice_vo.dart';

part 'speech_request_model.freezed.dart';

/// Domain entity for speech synthesis request
/// 
/// This is a domain entity that represents a request to convert text to speech.
/// Domain entities are part of the Domain layer in clean architecture and represent
/// core business concepts. They are independent of frameworks and data sources.
/// 
/// This entity uses value objects (TextVO, VoiceVO, etc.) to ensure type safety and
/// validation at the domain level. It uses Freezed to generate immutable classes with
/// copyWith methods.
/// 
/// Entities are different from DTOs (Data Transfer Objects) - entities represent
/// business concepts, while DTOs represent data structures for communication.
@freezed
class SpeechRequestModel with _$SpeechRequestModel {
  const factory SpeechRequestModel({
    required TextVO text,
    required TTSServiceModel service,
    VoiceVO? voice,
    LanguageVO? language,
    AudioFormatVO? audioFormat,
  }) = _SpeechRequestModel;
  
  /// Factory constructor with default audio format
  factory SpeechRequestModel.withDefaults({
    required TextVO text,
    required TTSServiceModel service,
    VoiceVO? voice,
    LanguageVO? language,
    AudioFormatVO? audioFormat,
  }) {
    return SpeechRequestModel(
      text: text,
      service: service,
      voice: voice,
      language: language,
      audioFormat: audioFormat ?? AudioFormatVO('mp3'),
    );
  }
}


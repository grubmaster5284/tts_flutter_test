import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/language_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/text_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/voice_vo.dart';

part 'speech_request_model.freezed.dart';

/// Domain entity for speech synthesis request
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


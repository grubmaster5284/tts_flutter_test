// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeechRequestDtoImpl _$$SpeechRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SpeechRequestDtoImpl(
  text: json['text'] as String,
  service: json['service'] as String,
  voice: json['voice'] as String?,
  language: json['language'] as String?,
  audioFormat: json['audioFormat'] as String? ?? 'mp3',
  speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
  instructions: json['instructions'] as String?,
);

Map<String, dynamic> _$$SpeechRequestDtoImplToJson(
  _$SpeechRequestDtoImpl instance,
) => <String, dynamic>{
  'text': instance.text,
  'service': instance.service,
  'voice': instance.voice,
  'language': instance.language,
  'audioFormat': instance.audioFormat,
  'speed': instance.speed,
  'instructions': instance.instructions,
};

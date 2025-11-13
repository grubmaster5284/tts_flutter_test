// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeechResponseDtoImpl _$$SpeechResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SpeechResponseDtoImpl(
  audioData: json['audioData'] as String,
  audioFormat: json['audioFormat'] as String,
  durationMs: (json['durationMs'] as num).toInt(),
  metadata: json['metadata'] as String?,
);

Map<String, dynamic> _$$SpeechResponseDtoImplToJson(
  _$SpeechResponseDtoImpl instance,
) => <String, dynamic>{
  'audioData': instance.audioData,
  'audioFormat': instance.audioFormat,
  'durationMs': instance.durationMs,
  'metadata': instance.metadata,
};

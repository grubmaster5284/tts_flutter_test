// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpeechRequestDto _$SpeechRequestDtoFromJson(Map<String, dynamic> json) {
  return _SpeechRequestDto.fromJson(json);
}

/// @nodoc
mixin _$SpeechRequestDto {
  /// The text content to be converted to speech
  /// This is a plain String, unlike the domain model which uses TextVO (a value object)
  String get text => throw _privateConstructorUsedError;

  /// The TTS service to use: 'gemini', 'openai', or 'polly'
  /// This is a String identifier, unlike the domain model which uses TTSServiceModel
  String get service => throw _privateConstructorUsedError;

  /// Optional voice identifier for the TTS service
  /// Different services support different voices (e.g., 'en-US-Standard-A' for Google)
  String? get voice => throw _privateConstructorUsedError;

  /// Optional language code in ISO 639-1 format (e.g., 'en', 'es', 'fr')
  /// This determines the language/accent of the generated speech
  String? get language => throw _privateConstructorUsedError;

  /// Audio format for the output (default: 'mp3')
  /// Supported formats: 'mp3', 'wav', 'ogg', etc.
  /// Uses @Default annotation from Freezed to provide a default value
  String get audioFormat => throw _privateConstructorUsedError;

  /// Optional speed parameter for OpenAI TTS (default: 1.0)
  /// Speed range: 0.25 to 4.0
  /// Only used by OpenAI TTS service
  double get speed => throw _privateConstructorUsedError;

  /// Optional instructions parameter for OpenAI TTS
  /// Provides guidance on how to speak the text
  /// Only used by OpenAI TTS service
  String? get instructions => throw _privateConstructorUsedError;

  /// Serializes this SpeechRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeechRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechRequestDtoCopyWith<SpeechRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechRequestDtoCopyWith<$Res> {
  factory $SpeechRequestDtoCopyWith(
    SpeechRequestDto value,
    $Res Function(SpeechRequestDto) then,
  ) = _$SpeechRequestDtoCopyWithImpl<$Res, SpeechRequestDto>;
  @useResult
  $Res call({
    String text,
    String service,
    String? voice,
    String? language,
    String audioFormat,
    double speed,
    String? instructions,
  });
}

/// @nodoc
class _$SpeechRequestDtoCopyWithImpl<$Res, $Val extends SpeechRequestDto>
    implements $SpeechRequestDtoCopyWith<$Res> {
  _$SpeechRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? service = null,
    Object? voice = freezed,
    Object? language = freezed,
    Object? audioFormat = null,
    Object? speed = null,
    Object? instructions = freezed,
  }) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            service: null == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                      as String,
            voice: freezed == voice
                ? _value.voice
                : voice // ignore: cast_nullable_to_non_nullable
                      as String?,
            language: freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String?,
            audioFormat: null == audioFormat
                ? _value.audioFormat
                : audioFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            speed: null == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as double,
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpeechRequestDtoImplCopyWith<$Res>
    implements $SpeechRequestDtoCopyWith<$Res> {
  factory _$$SpeechRequestDtoImplCopyWith(
    _$SpeechRequestDtoImpl value,
    $Res Function(_$SpeechRequestDtoImpl) then,
  ) = __$$SpeechRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String text,
    String service,
    String? voice,
    String? language,
    String audioFormat,
    double speed,
    String? instructions,
  });
}

/// @nodoc
class __$$SpeechRequestDtoImplCopyWithImpl<$Res>
    extends _$SpeechRequestDtoCopyWithImpl<$Res, _$SpeechRequestDtoImpl>
    implements _$$SpeechRequestDtoImplCopyWith<$Res> {
  __$$SpeechRequestDtoImplCopyWithImpl(
    _$SpeechRequestDtoImpl _value,
    $Res Function(_$SpeechRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? service = null,
    Object? voice = freezed,
    Object? language = freezed,
    Object? audioFormat = null,
    Object? speed = null,
    Object? instructions = freezed,
  }) {
    return _then(
      _$SpeechRequestDtoImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        service: null == service
            ? _value.service
            : service // ignore: cast_nullable_to_non_nullable
                  as String,
        voice: freezed == voice
            ? _value.voice
            : voice // ignore: cast_nullable_to_non_nullable
                  as String?,
        language: freezed == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String?,
        audioFormat: null == audioFormat
            ? _value.audioFormat
            : audioFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        speed: null == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as double,
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeechRequestDtoImpl implements _SpeechRequestDto {
  const _$SpeechRequestDtoImpl({
    required this.text,
    required this.service,
    this.voice,
    this.language,
    this.audioFormat = 'mp3',
    this.speed = 1.0,
    this.instructions,
  });

  factory _$SpeechRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeechRequestDtoImplFromJson(json);

  /// The text content to be converted to speech
  /// This is a plain String, unlike the domain model which uses TextVO (a value object)
  @override
  final String text;

  /// The TTS service to use: 'gemini', 'openai', or 'polly'
  /// This is a String identifier, unlike the domain model which uses TTSServiceModel
  @override
  final String service;

  /// Optional voice identifier for the TTS service
  /// Different services support different voices (e.g., 'en-US-Standard-A' for Google)
  @override
  final String? voice;

  /// Optional language code in ISO 639-1 format (e.g., 'en', 'es', 'fr')
  /// This determines the language/accent of the generated speech
  @override
  final String? language;

  /// Audio format for the output (default: 'mp3')
  /// Supported formats: 'mp3', 'wav', 'ogg', etc.
  /// Uses @Default annotation from Freezed to provide a default value
  @override
  @JsonKey()
  final String audioFormat;

  /// Optional speed parameter for OpenAI TTS (default: 1.0)
  /// Speed range: 0.25 to 4.0
  /// Only used by OpenAI TTS service
  @override
  @JsonKey()
  final double speed;

  /// Optional instructions parameter for OpenAI TTS
  /// Provides guidance on how to speak the text
  /// Only used by OpenAI TTS service
  @override
  final String? instructions;

  @override
  String toString() {
    return 'SpeechRequestDto(text: $text, service: $service, voice: $voice, language: $language, audioFormat: $audioFormat, speed: $speed, instructions: $instructions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechRequestDtoImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.voice, voice) || other.voice == voice) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.audioFormat, audioFormat) ||
                other.audioFormat == audioFormat) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    text,
    service,
    voice,
    language,
    audioFormat,
    speed,
    instructions,
  );

  /// Create a copy of SpeechRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechRequestDtoImplCopyWith<_$SpeechRequestDtoImpl> get copyWith =>
      __$$SpeechRequestDtoImplCopyWithImpl<_$SpeechRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeechRequestDtoImplToJson(this);
  }
}

abstract class _SpeechRequestDto implements SpeechRequestDto {
  const factory _SpeechRequestDto({
    required final String text,
    required final String service,
    final String? voice,
    final String? language,
    final String audioFormat,
    final double speed,
    final String? instructions,
  }) = _$SpeechRequestDtoImpl;

  factory _SpeechRequestDto.fromJson(Map<String, dynamic> json) =
      _$SpeechRequestDtoImpl.fromJson;

  /// The text content to be converted to speech
  /// This is a plain String, unlike the domain model which uses TextVO (a value object)
  @override
  String get text;

  /// The TTS service to use: 'gemini', 'openai', or 'polly'
  /// This is a String identifier, unlike the domain model which uses TTSServiceModel
  @override
  String get service;

  /// Optional voice identifier for the TTS service
  /// Different services support different voices (e.g., 'en-US-Standard-A' for Google)
  @override
  String? get voice;

  /// Optional language code in ISO 639-1 format (e.g., 'en', 'es', 'fr')
  /// This determines the language/accent of the generated speech
  @override
  String? get language;

  /// Audio format for the output (default: 'mp3')
  /// Supported formats: 'mp3', 'wav', 'ogg', etc.
  /// Uses @Default annotation from Freezed to provide a default value
  @override
  String get audioFormat;

  /// Optional speed parameter for OpenAI TTS (default: 1.0)
  /// Speed range: 0.25 to 4.0
  /// Only used by OpenAI TTS service
  @override
  double get speed;

  /// Optional instructions parameter for OpenAI TTS
  /// Provides guidance on how to speak the text
  /// Only used by OpenAI TTS service
  @override
  String? get instructions;

  /// Create a copy of SpeechRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechRequestDtoImplCopyWith<_$SpeechRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

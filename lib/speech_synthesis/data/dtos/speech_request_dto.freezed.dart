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
  String get text => throw _privateConstructorUsedError;
  String get service =>
      throw _privateConstructorUsedError; // 'gemini', 'openai', or 'polly'
  String? get voice => throw _privateConstructorUsedError;
  String? get language =>
      throw _privateConstructorUsedError; // ISO 639-1 format
  String get audioFormat => throw _privateConstructorUsedError;

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
  });

  factory _$SpeechRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeechRequestDtoImplFromJson(json);

  @override
  final String text;
  @override
  final String service;
  // 'gemini', 'openai', or 'polly'
  @override
  final String? voice;
  @override
  final String? language;
  // ISO 639-1 format
  @override
  @JsonKey()
  final String audioFormat;

  @override
  String toString() {
    return 'SpeechRequestDto(text: $text, service: $service, voice: $voice, language: $language, audioFormat: $audioFormat)';
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
                other.audioFormat == audioFormat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, text, service, voice, language, audioFormat);

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
  }) = _$SpeechRequestDtoImpl;

  factory _SpeechRequestDto.fromJson(Map<String, dynamic> json) =
      _$SpeechRequestDtoImpl.fromJson;

  @override
  String get text;
  @override
  String get service; // 'gemini', 'openai', or 'polly'
  @override
  String? get voice;
  @override
  String? get language; // ISO 639-1 format
  @override
  String get audioFormat;

  /// Create a copy of SpeechRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechRequestDtoImplCopyWith<_$SpeechRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

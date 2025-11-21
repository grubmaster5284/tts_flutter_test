// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpeechResponseDto _$SpeechResponseDtoFromJson(Map<String, dynamic> json) {
  return _SpeechResponseDto.fromJson(json);
}

/// @nodoc
mixin _$SpeechResponseDto {
  /// Audio data as a String
  ///
  /// **Content can be:**
  /// - Base64-encoded audio data (when received from API/script)
  /// - File path (after audio is saved to disk by the repository)
  ///
  /// The repository saves base64 audio to a file and replaces this field with the file path
  /// for better performance (avoiding base64 encoding/decoding overhead).
  String get audioData => throw _privateConstructorUsedError;

  /// Audio format as a plain String (e.g., 'mp3', 'wav', 'ogg')
  ///
  /// Unlike the domain model which uses AudioFormatVO (a value object), this is a simple
  /// String for easy serialization. The extension method `toDomain()` converts this to
  /// AudioFormatVO when creating the domain model.
  String get audioFormat => throw _privateConstructorUsedError;

  /// Duration of the audio in milliseconds
  ///
  /// This represents how long the generated speech audio is. It's useful for:
  /// - Displaying progress during playback
  /// - Calculating playback position
  /// - UI feedback (showing audio length)
  int get durationMs => throw _privateConstructorUsedError;

  /// Optional metadata as a JSON string
  ///
  /// This can contain additional information about the synthesis:
  /// - Service-specific metadata (voice used, model version, etc.)
  /// - Quality metrics
  /// - Processing time
  /// - Any other service-provided information
  ///
  /// Stored as a JSON string to maintain flexibility across different services.
  String? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SpeechResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeechResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechResponseDtoCopyWith<SpeechResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechResponseDtoCopyWith<$Res> {
  factory $SpeechResponseDtoCopyWith(
    SpeechResponseDto value,
    $Res Function(SpeechResponseDto) then,
  ) = _$SpeechResponseDtoCopyWithImpl<$Res, SpeechResponseDto>;
  @useResult
  $Res call({
    String audioData,
    String audioFormat,
    int durationMs,
    String? metadata,
  });
}

/// @nodoc
class _$SpeechResponseDtoCopyWithImpl<$Res, $Val extends SpeechResponseDto>
    implements $SpeechResponseDtoCopyWith<$Res> {
  _$SpeechResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioData = null,
    Object? audioFormat = null,
    Object? durationMs = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            audioData: null == audioData
                ? _value.audioData
                : audioData // ignore: cast_nullable_to_non_nullable
                      as String,
            audioFormat: null == audioFormat
                ? _value.audioFormat
                : audioFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            durationMs: null == durationMs
                ? _value.durationMs
                : durationMs // ignore: cast_nullable_to_non_nullable
                      as int,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpeechResponseDtoImplCopyWith<$Res>
    implements $SpeechResponseDtoCopyWith<$Res> {
  factory _$$SpeechResponseDtoImplCopyWith(
    _$SpeechResponseDtoImpl value,
    $Res Function(_$SpeechResponseDtoImpl) then,
  ) = __$$SpeechResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String audioData,
    String audioFormat,
    int durationMs,
    String? metadata,
  });
}

/// @nodoc
class __$$SpeechResponseDtoImplCopyWithImpl<$Res>
    extends _$SpeechResponseDtoCopyWithImpl<$Res, _$SpeechResponseDtoImpl>
    implements _$$SpeechResponseDtoImplCopyWith<$Res> {
  __$$SpeechResponseDtoImplCopyWithImpl(
    _$SpeechResponseDtoImpl _value,
    $Res Function(_$SpeechResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioData = null,
    Object? audioFormat = null,
    Object? durationMs = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$SpeechResponseDtoImpl(
        audioData: null == audioData
            ? _value.audioData
            : audioData // ignore: cast_nullable_to_non_nullable
                  as String,
        audioFormat: null == audioFormat
            ? _value.audioFormat
            : audioFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        durationMs: null == durationMs
            ? _value.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int,
        metadata: freezed == metadata
            ? _value.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeechResponseDtoImpl implements _SpeechResponseDto {
  const _$SpeechResponseDtoImpl({
    required this.audioData,
    required this.audioFormat,
    required this.durationMs,
    this.metadata,
  });

  factory _$SpeechResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeechResponseDtoImplFromJson(json);

  /// Audio data as a String
  ///
  /// **Content can be:**
  /// - Base64-encoded audio data (when received from API/script)
  /// - File path (after audio is saved to disk by the repository)
  ///
  /// The repository saves base64 audio to a file and replaces this field with the file path
  /// for better performance (avoiding base64 encoding/decoding overhead).
  @override
  final String audioData;

  /// Audio format as a plain String (e.g., 'mp3', 'wav', 'ogg')
  ///
  /// Unlike the domain model which uses AudioFormatVO (a value object), this is a simple
  /// String for easy serialization. The extension method `toDomain()` converts this to
  /// AudioFormatVO when creating the domain model.
  @override
  final String audioFormat;

  /// Duration of the audio in milliseconds
  ///
  /// This represents how long the generated speech audio is. It's useful for:
  /// - Displaying progress during playback
  /// - Calculating playback position
  /// - UI feedback (showing audio length)
  @override
  final int durationMs;

  /// Optional metadata as a JSON string
  ///
  /// This can contain additional information about the synthesis:
  /// - Service-specific metadata (voice used, model version, etc.)
  /// - Quality metrics
  /// - Processing time
  /// - Any other service-provided information
  ///
  /// Stored as a JSON string to maintain flexibility across different services.
  @override
  final String? metadata;

  @override
  String toString() {
    return 'SpeechResponseDto(audioData: $audioData, audioFormat: $audioFormat, durationMs: $durationMs, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechResponseDtoImpl &&
            (identical(other.audioData, audioData) ||
                other.audioData == audioData) &&
            (identical(other.audioFormat, audioFormat) ||
                other.audioFormat == audioFormat) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, audioData, audioFormat, durationMs, metadata);

  /// Create a copy of SpeechResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechResponseDtoImplCopyWith<_$SpeechResponseDtoImpl> get copyWith =>
      __$$SpeechResponseDtoImplCopyWithImpl<_$SpeechResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeechResponseDtoImplToJson(this);
  }
}

abstract class _SpeechResponseDto implements SpeechResponseDto {
  const factory _SpeechResponseDto({
    required final String audioData,
    required final String audioFormat,
    required final int durationMs,
    final String? metadata,
  }) = _$SpeechResponseDtoImpl;

  factory _SpeechResponseDto.fromJson(Map<String, dynamic> json) =
      _$SpeechResponseDtoImpl.fromJson;

  /// Audio data as a String
  ///
  /// **Content can be:**
  /// - Base64-encoded audio data (when received from API/script)
  /// - File path (after audio is saved to disk by the repository)
  ///
  /// The repository saves base64 audio to a file and replaces this field with the file path
  /// for better performance (avoiding base64 encoding/decoding overhead).
  @override
  String get audioData;

  /// Audio format as a plain String (e.g., 'mp3', 'wav', 'ogg')
  ///
  /// Unlike the domain model which uses AudioFormatVO (a value object), this is a simple
  /// String for easy serialization. The extension method `toDomain()` converts this to
  /// AudioFormatVO when creating the domain model.
  @override
  String get audioFormat;

  /// Duration of the audio in milliseconds
  ///
  /// This represents how long the generated speech audio is. It's useful for:
  /// - Displaying progress during playback
  /// - Calculating playback position
  /// - UI feedback (showing audio length)
  @override
  int get durationMs;

  /// Optional metadata as a JSON string
  ///
  /// This can contain additional information about the synthesis:
  /// - Service-specific metadata (voice used, model version, etc.)
  /// - Quality metrics
  /// - Processing time
  /// - Any other service-provided information
  ///
  /// Stored as a JSON string to maintain flexibility across different services.
  @override
  String? get metadata;

  /// Create a copy of SpeechResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechResponseDtoImplCopyWith<_$SpeechResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

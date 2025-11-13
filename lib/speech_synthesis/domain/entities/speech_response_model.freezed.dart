// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpeechResponseModel {
  String get audioData =>
      throw _privateConstructorUsedError; // Base64 encoded audio data
  AudioFormatVO get audioFormat => throw _privateConstructorUsedError;
  int get durationMs =>
      throw _privateConstructorUsedError; // Duration in milliseconds
  String? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of SpeechResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechResponseModelCopyWith<SpeechResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechResponseModelCopyWith<$Res> {
  factory $SpeechResponseModelCopyWith(
    SpeechResponseModel value,
    $Res Function(SpeechResponseModel) then,
  ) = _$SpeechResponseModelCopyWithImpl<$Res, SpeechResponseModel>;
  @useResult
  $Res call({
    String audioData,
    AudioFormatVO audioFormat,
    int durationMs,
    String? metadata,
  });
}

/// @nodoc
class _$SpeechResponseModelCopyWithImpl<$Res, $Val extends SpeechResponseModel>
    implements $SpeechResponseModelCopyWith<$Res> {
  _$SpeechResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechResponseModel
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
                      as AudioFormatVO,
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
abstract class _$$SpeechResponseModelImplCopyWith<$Res>
    implements $SpeechResponseModelCopyWith<$Res> {
  factory _$$SpeechResponseModelImplCopyWith(
    _$SpeechResponseModelImpl value,
    $Res Function(_$SpeechResponseModelImpl) then,
  ) = __$$SpeechResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String audioData,
    AudioFormatVO audioFormat,
    int durationMs,
    String? metadata,
  });
}

/// @nodoc
class __$$SpeechResponseModelImplCopyWithImpl<$Res>
    extends _$SpeechResponseModelCopyWithImpl<$Res, _$SpeechResponseModelImpl>
    implements _$$SpeechResponseModelImplCopyWith<$Res> {
  __$$SpeechResponseModelImplCopyWithImpl(
    _$SpeechResponseModelImpl _value,
    $Res Function(_$SpeechResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechResponseModel
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
      _$SpeechResponseModelImpl(
        audioData: null == audioData
            ? _value.audioData
            : audioData // ignore: cast_nullable_to_non_nullable
                  as String,
        audioFormat: null == audioFormat
            ? _value.audioFormat
            : audioFormat // ignore: cast_nullable_to_non_nullable
                  as AudioFormatVO,
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

class _$SpeechResponseModelImpl implements _SpeechResponseModel {
  const _$SpeechResponseModelImpl({
    required this.audioData,
    required this.audioFormat,
    required this.durationMs,
    this.metadata,
  });

  @override
  final String audioData;
  // Base64 encoded audio data
  @override
  final AudioFormatVO audioFormat;
  @override
  final int durationMs;
  // Duration in milliseconds
  @override
  final String? metadata;

  @override
  String toString() {
    return 'SpeechResponseModel(audioData: $audioData, audioFormat: $audioFormat, durationMs: $durationMs, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechResponseModelImpl &&
            (identical(other.audioData, audioData) ||
                other.audioData == audioData) &&
            (identical(other.audioFormat, audioFormat) ||
                other.audioFormat == audioFormat) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, audioData, audioFormat, durationMs, metadata);

  /// Create a copy of SpeechResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechResponseModelImplCopyWith<_$SpeechResponseModelImpl> get copyWith =>
      __$$SpeechResponseModelImplCopyWithImpl<_$SpeechResponseModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SpeechResponseModel implements SpeechResponseModel {
  const factory _SpeechResponseModel({
    required final String audioData,
    required final AudioFormatVO audioFormat,
    required final int durationMs,
    final String? metadata,
  }) = _$SpeechResponseModelImpl;

  @override
  String get audioData; // Base64 encoded audio data
  @override
  AudioFormatVO get audioFormat;
  @override
  int get durationMs; // Duration in milliseconds
  @override
  String? get metadata;

  /// Create a copy of SpeechResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechResponseModelImplCopyWith<_$SpeechResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

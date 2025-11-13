// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_playback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AudioPlaybackState {
  /// Current playback status
  PlaybackStatus get status => throw _privateConstructorUsedError;

  /// Current audio source URL or path
  String? get audioSource => throw _privateConstructorUsedError;

  /// Current playback position in milliseconds
  int get position => throw _privateConstructorUsedError;

  /// Total duration in milliseconds
  int get duration => throw _privateConstructorUsedError;

  /// Volume level (0.0 to 1.0)
  double get volume => throw _privateConstructorUsedError;

  /// Playback speed (1.0 = normal speed)
  double get playbackSpeed => throw _privateConstructorUsedError;

  /// Error message if status is error
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioPlaybackStateCopyWith<AudioPlaybackState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioPlaybackStateCopyWith<$Res> {
  factory $AudioPlaybackStateCopyWith(
    AudioPlaybackState value,
    $Res Function(AudioPlaybackState) then,
  ) = _$AudioPlaybackStateCopyWithImpl<$Res, AudioPlaybackState>;
  @useResult
  $Res call({
    PlaybackStatus status,
    String? audioSource,
    int position,
    int duration,
    double volume,
    double playbackSpeed,
    String? errorMessage,
  });
}

/// @nodoc
class _$AudioPlaybackStateCopyWithImpl<$Res, $Val extends AudioPlaybackState>
    implements $AudioPlaybackStateCopyWith<$Res> {
  _$AudioPlaybackStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? audioSource = freezed,
    Object? position = null,
    Object? duration = null,
    Object? volume = null,
    Object? playbackSpeed = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PlaybackStatus,
            audioSource: freezed == audioSource
                ? _value.audioSource
                : audioSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            volume: null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                      as double,
            playbackSpeed: null == playbackSpeed
                ? _value.playbackSpeed
                : playbackSpeed // ignore: cast_nullable_to_non_nullable
                      as double,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioPlaybackStateImplCopyWith<$Res>
    implements $AudioPlaybackStateCopyWith<$Res> {
  factory _$$AudioPlaybackStateImplCopyWith(
    _$AudioPlaybackStateImpl value,
    $Res Function(_$AudioPlaybackStateImpl) then,
  ) = __$$AudioPlaybackStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PlaybackStatus status,
    String? audioSource,
    int position,
    int duration,
    double volume,
    double playbackSpeed,
    String? errorMessage,
  });
}

/// @nodoc
class __$$AudioPlaybackStateImplCopyWithImpl<$Res>
    extends _$AudioPlaybackStateCopyWithImpl<$Res, _$AudioPlaybackStateImpl>
    implements _$$AudioPlaybackStateImplCopyWith<$Res> {
  __$$AudioPlaybackStateImplCopyWithImpl(
    _$AudioPlaybackStateImpl _value,
    $Res Function(_$AudioPlaybackStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? audioSource = freezed,
    Object? position = null,
    Object? duration = null,
    Object? volume = null,
    Object? playbackSpeed = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$AudioPlaybackStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PlaybackStatus,
        audioSource: freezed == audioSource
            ? _value.audioSource
            : audioSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        volume: null == volume
            ? _value.volume
            : volume // ignore: cast_nullable_to_non_nullable
                  as double,
        playbackSpeed: null == playbackSpeed
            ? _value.playbackSpeed
            : playbackSpeed // ignore: cast_nullable_to_non_nullable
                  as double,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AudioPlaybackStateImpl extends _AudioPlaybackState {
  const _$AudioPlaybackStateImpl({
    this.status = PlaybackStatus.idle,
    this.audioSource,
    this.position = 0,
    this.duration = 0,
    this.volume = 1.0,
    this.playbackSpeed = 1.0,
    this.errorMessage,
  }) : super._();

  /// Current playback status
  @override
  @JsonKey()
  final PlaybackStatus status;

  /// Current audio source URL or path
  @override
  final String? audioSource;

  /// Current playback position in milliseconds
  @override
  @JsonKey()
  final int position;

  /// Total duration in milliseconds
  @override
  @JsonKey()
  final int duration;

  /// Volume level (0.0 to 1.0)
  @override
  @JsonKey()
  final double volume;

  /// Playback speed (1.0 = normal speed)
  @override
  @JsonKey()
  final double playbackSpeed;

  /// Error message if status is error
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AudioPlaybackState(status: $status, audioSource: $audioSource, position: $position, duration: $duration, volume: $volume, playbackSpeed: $playbackSpeed, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioPlaybackStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.audioSource, audioSource) ||
                other.audioSource == audioSource) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.playbackSpeed, playbackSpeed) ||
                other.playbackSpeed == playbackSpeed) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    audioSource,
    position,
    duration,
    volume,
    playbackSpeed,
    errorMessage,
  );

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioPlaybackStateImplCopyWith<_$AudioPlaybackStateImpl> get copyWith =>
      __$$AudioPlaybackStateImplCopyWithImpl<_$AudioPlaybackStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AudioPlaybackState extends AudioPlaybackState {
  const factory _AudioPlaybackState({
    final PlaybackStatus status,
    final String? audioSource,
    final int position,
    final int duration,
    final double volume,
    final double playbackSpeed,
    final String? errorMessage,
  }) = _$AudioPlaybackStateImpl;
  const _AudioPlaybackState._() : super._();

  /// Current playback status
  @override
  PlaybackStatus get status;

  /// Current audio source URL or path
  @override
  String? get audioSource;

  /// Current playback position in milliseconds
  @override
  int get position;

  /// Total duration in milliseconds
  @override
  int get duration;

  /// Volume level (0.0 to 1.0)
  @override
  double get volume;

  /// Playback speed (1.0 = normal speed)
  @override
  double get playbackSpeed;

  /// Error message if status is error
  @override
  String? get errorMessage;

  /// Create a copy of AudioPlaybackState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioPlaybackStateImplCopyWith<_$AudioPlaybackStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

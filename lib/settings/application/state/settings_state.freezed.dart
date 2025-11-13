// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SettingsState {
  /// Default TTS service (e.g., 'gemini', 'openai', 'polly')
  String get defaultTtsService => throw _privateConstructorUsedError;

  /// Default voice identifier
  String? get defaultVoice => throw _privateConstructorUsedError;

  /// Default language code (ISO 639-1 format)
  String get defaultLanguage => throw _privateConstructorUsedError;

  /// Default audio format (e.g., 'mp3', 'wav', 'ogg')
  String get defaultAudioFormat => throw _privateConstructorUsedError;

  /// Default playback volume (0.0 to 1.0)
  double get defaultVolume => throw _privateConstructorUsedError;

  /// Default playback speed (0.5 to 2.0)
  double get defaultPlaybackSpeed => throw _privateConstructorUsedError;

  /// Theme preference ('light', 'dark', 'system')
  String get themePreference => throw _privateConstructorUsedError;

  /// Whether settings are currently being loaded
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether settings are currently being saved
  bool get isSaving => throw _privateConstructorUsedError;

  /// Error message if an error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
    SettingsState value,
    $Res Function(SettingsState) then,
  ) = _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({
    String defaultTtsService,
    String? defaultVoice,
    String defaultLanguage,
    String defaultAudioFormat,
    double defaultVolume,
    double defaultPlaybackSpeed,
    String themePreference,
    bool isLoading,
    bool isSaving,
    String? errorMessage,
  });
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultTtsService = null,
    Object? defaultVoice = freezed,
    Object? defaultLanguage = null,
    Object? defaultAudioFormat = null,
    Object? defaultVolume = null,
    Object? defaultPlaybackSpeed = null,
    Object? themePreference = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            defaultTtsService: null == defaultTtsService
                ? _value.defaultTtsService
                : defaultTtsService // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultVoice: freezed == defaultVoice
                ? _value.defaultVoice
                : defaultVoice // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultLanguage: null == defaultLanguage
                ? _value.defaultLanguage
                : defaultLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultAudioFormat: null == defaultAudioFormat
                ? _value.defaultAudioFormat
                : defaultAudioFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultVolume: null == defaultVolume
                ? _value.defaultVolume
                : defaultVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            defaultPlaybackSpeed: null == defaultPlaybackSpeed
                ? _value.defaultPlaybackSpeed
                : defaultPlaybackSpeed // ignore: cast_nullable_to_non_nullable
                      as double,
            themePreference: null == themePreference
                ? _value.themePreference
                : themePreference // ignore: cast_nullable_to_non_nullable
                      as String,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
    _$SettingsStateImpl value,
    $Res Function(_$SettingsStateImpl) then,
  ) = __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String defaultTtsService,
    String? defaultVoice,
    String defaultLanguage,
    String defaultAudioFormat,
    double defaultVolume,
    double defaultPlaybackSpeed,
    String themePreference,
    bool isLoading,
    bool isSaving,
    String? errorMessage,
  });
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
    _$SettingsStateImpl _value,
    $Res Function(_$SettingsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultTtsService = null,
    Object? defaultVoice = freezed,
    Object? defaultLanguage = null,
    Object? defaultAudioFormat = null,
    Object? defaultVolume = null,
    Object? defaultPlaybackSpeed = null,
    Object? themePreference = null,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$SettingsStateImpl(
        defaultTtsService: null == defaultTtsService
            ? _value.defaultTtsService
            : defaultTtsService // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultVoice: freezed == defaultVoice
            ? _value.defaultVoice
            : defaultVoice // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultLanguage: null == defaultLanguage
            ? _value.defaultLanguage
            : defaultLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultAudioFormat: null == defaultAudioFormat
            ? _value.defaultAudioFormat
            : defaultAudioFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultVolume: null == defaultVolume
            ? _value.defaultVolume
            : defaultVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        defaultPlaybackSpeed: null == defaultPlaybackSpeed
            ? _value.defaultPlaybackSpeed
            : defaultPlaybackSpeed // ignore: cast_nullable_to_non_nullable
                  as double,
        themePreference: null == themePreference
            ? _value.themePreference
            : themePreference // ignore: cast_nullable_to_non_nullable
                  as String,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$SettingsStateImpl extends _SettingsState {
  const _$SettingsStateImpl({
    this.defaultTtsService = 'gemini',
    this.defaultVoice,
    this.defaultLanguage = 'en',
    this.defaultAudioFormat = 'mp3',
    this.defaultVolume = 1.0,
    this.defaultPlaybackSpeed = 1.0,
    this.themePreference = 'system',
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  }) : super._();

  /// Default TTS service (e.g., 'gemini', 'openai', 'polly')
  @override
  @JsonKey()
  final String defaultTtsService;

  /// Default voice identifier
  @override
  final String? defaultVoice;

  /// Default language code (ISO 639-1 format)
  @override
  @JsonKey()
  final String defaultLanguage;

  /// Default audio format (e.g., 'mp3', 'wav', 'ogg')
  @override
  @JsonKey()
  final String defaultAudioFormat;

  /// Default playback volume (0.0 to 1.0)
  @override
  @JsonKey()
  final double defaultVolume;

  /// Default playback speed (0.5 to 2.0)
  @override
  @JsonKey()
  final double defaultPlaybackSpeed;

  /// Theme preference ('light', 'dark', 'system')
  @override
  @JsonKey()
  final String themePreference;

  /// Whether settings are currently being loaded
  @override
  @JsonKey()
  final bool isLoading;

  /// Whether settings are currently being saved
  @override
  @JsonKey()
  final bool isSaving;

  /// Error message if an error occurred
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SettingsState(defaultTtsService: $defaultTtsService, defaultVoice: $defaultVoice, defaultLanguage: $defaultLanguage, defaultAudioFormat: $defaultAudioFormat, defaultVolume: $defaultVolume, defaultPlaybackSpeed: $defaultPlaybackSpeed, themePreference: $themePreference, isLoading: $isLoading, isSaving: $isSaving, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.defaultTtsService, defaultTtsService) ||
                other.defaultTtsService == defaultTtsService) &&
            (identical(other.defaultVoice, defaultVoice) ||
                other.defaultVoice == defaultVoice) &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            (identical(other.defaultAudioFormat, defaultAudioFormat) ||
                other.defaultAudioFormat == defaultAudioFormat) &&
            (identical(other.defaultVolume, defaultVolume) ||
                other.defaultVolume == defaultVolume) &&
            (identical(other.defaultPlaybackSpeed, defaultPlaybackSpeed) ||
                other.defaultPlaybackSpeed == defaultPlaybackSpeed) &&
            (identical(other.themePreference, themePreference) ||
                other.themePreference == themePreference) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    defaultTtsService,
    defaultVoice,
    defaultLanguage,
    defaultAudioFormat,
    defaultVolume,
    defaultPlaybackSpeed,
    themePreference,
    isLoading,
    isSaving,
    errorMessage,
  );

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);
}

abstract class _SettingsState extends SettingsState {
  const factory _SettingsState({
    final String defaultTtsService,
    final String? defaultVoice,
    final String defaultLanguage,
    final String defaultAudioFormat,
    final double defaultVolume,
    final double defaultPlaybackSpeed,
    final String themePreference,
    final bool isLoading,
    final bool isSaving,
    final String? errorMessage,
  }) = _$SettingsStateImpl;
  const _SettingsState._() : super._();

  /// Default TTS service (e.g., 'gemini', 'openai', 'polly')
  @override
  String get defaultTtsService;

  /// Default voice identifier
  @override
  String? get defaultVoice;

  /// Default language code (ISO 639-1 format)
  @override
  String get defaultLanguage;

  /// Default audio format (e.g., 'mp3', 'wav', 'ogg')
  @override
  String get defaultAudioFormat;

  /// Default playback volume (0.0 to 1.0)
  @override
  double get defaultVolume;

  /// Default playback speed (0.5 to 2.0)
  @override
  double get defaultPlaybackSpeed;

  /// Theme preference ('light', 'dark', 'system')
  @override
  String get themePreference;

  /// Whether settings are currently being loaded
  @override
  bool get isLoading;

  /// Whether settings are currently being saved
  @override
  bool get isSaving;

  /// Error message if an error occurred
  @override
  String? get errorMessage;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

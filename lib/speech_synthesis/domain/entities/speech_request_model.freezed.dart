// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpeechRequestModel {
  TextVO get text => throw _privateConstructorUsedError;
  TTSServiceModel get service => throw _privateConstructorUsedError;
  VoiceVO? get voice => throw _privateConstructorUsedError;
  LanguageVO? get language => throw _privateConstructorUsedError;
  AudioFormatVO? get audioFormat => throw _privateConstructorUsedError;

  /// Create a copy of SpeechRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechRequestModelCopyWith<SpeechRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechRequestModelCopyWith<$Res> {
  factory $SpeechRequestModelCopyWith(
    SpeechRequestModel value,
    $Res Function(SpeechRequestModel) then,
  ) = _$SpeechRequestModelCopyWithImpl<$Res, SpeechRequestModel>;
  @useResult
  $Res call({
    TextVO text,
    TTSServiceModel service,
    VoiceVO? voice,
    LanguageVO? language,
    AudioFormatVO? audioFormat,
  });
}

/// @nodoc
class _$SpeechRequestModelCopyWithImpl<$Res, $Val extends SpeechRequestModel>
    implements $SpeechRequestModelCopyWith<$Res> {
  _$SpeechRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? service = null,
    Object? voice = freezed,
    Object? language = freezed,
    Object? audioFormat = freezed,
  }) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as TextVO,
            service: null == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                      as TTSServiceModel,
            voice: freezed == voice
                ? _value.voice
                : voice // ignore: cast_nullable_to_non_nullable
                      as VoiceVO?,
            language: freezed == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as LanguageVO?,
            audioFormat: freezed == audioFormat
                ? _value.audioFormat
                : audioFormat // ignore: cast_nullable_to_non_nullable
                      as AudioFormatVO?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpeechRequestModelImplCopyWith<$Res>
    implements $SpeechRequestModelCopyWith<$Res> {
  factory _$$SpeechRequestModelImplCopyWith(
    _$SpeechRequestModelImpl value,
    $Res Function(_$SpeechRequestModelImpl) then,
  ) = __$$SpeechRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TextVO text,
    TTSServiceModel service,
    VoiceVO? voice,
    LanguageVO? language,
    AudioFormatVO? audioFormat,
  });
}

/// @nodoc
class __$$SpeechRequestModelImplCopyWithImpl<$Res>
    extends _$SpeechRequestModelCopyWithImpl<$Res, _$SpeechRequestModelImpl>
    implements _$$SpeechRequestModelImplCopyWith<$Res> {
  __$$SpeechRequestModelImplCopyWithImpl(
    _$SpeechRequestModelImpl _value,
    $Res Function(_$SpeechRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? service = null,
    Object? voice = freezed,
    Object? language = freezed,
    Object? audioFormat = freezed,
  }) {
    return _then(
      _$SpeechRequestModelImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as TextVO,
        service: null == service
            ? _value.service
            : service // ignore: cast_nullable_to_non_nullable
                  as TTSServiceModel,
        voice: freezed == voice
            ? _value.voice
            : voice // ignore: cast_nullable_to_non_nullable
                  as VoiceVO?,
        language: freezed == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as LanguageVO?,
        audioFormat: freezed == audioFormat
            ? _value.audioFormat
            : audioFormat // ignore: cast_nullable_to_non_nullable
                  as AudioFormatVO?,
      ),
    );
  }
}

/// @nodoc

class _$SpeechRequestModelImpl implements _SpeechRequestModel {
  const _$SpeechRequestModelImpl({
    required this.text,
    required this.service,
    this.voice,
    this.language,
    this.audioFormat,
  });

  @override
  final TextVO text;
  @override
  final TTSServiceModel service;
  @override
  final VoiceVO? voice;
  @override
  final LanguageVO? language;
  @override
  final AudioFormatVO? audioFormat;

  @override
  String toString() {
    return 'SpeechRequestModel(text: $text, service: $service, voice: $voice, language: $language, audioFormat: $audioFormat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechRequestModelImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.voice, voice) || other.voice == voice) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.audioFormat, audioFormat) ||
                other.audioFormat == audioFormat));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, text, service, voice, language, audioFormat);

  /// Create a copy of SpeechRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechRequestModelImplCopyWith<_$SpeechRequestModelImpl> get copyWith =>
      __$$SpeechRequestModelImplCopyWithImpl<_$SpeechRequestModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SpeechRequestModel implements SpeechRequestModel {
  const factory _SpeechRequestModel({
    required final TextVO text,
    required final TTSServiceModel service,
    final VoiceVO? voice,
    final LanguageVO? language,
    final AudioFormatVO? audioFormat,
  }) = _$SpeechRequestModelImpl;

  @override
  TextVO get text;
  @override
  TTSServiceModel get service;
  @override
  VoiceVO? get voice;
  @override
  LanguageVO? get language;
  @override
  AudioFormatVO? get audioFormat;

  /// Create a copy of SpeechRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechRequestModelImplCopyWith<_$SpeechRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

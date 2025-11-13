// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_synthesis_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpeechSynthesisState {
  DataState<SpeechResponseModel> get dataState =>
      throw _privateConstructorUsedError;
  TTSServiceModel get selectedService => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;

  /// Create a copy of SpeechSynthesisState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechSynthesisStateCopyWith<SpeechSynthesisState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechSynthesisStateCopyWith<$Res> {
  factory $SpeechSynthesisStateCopyWith(
    SpeechSynthesisState value,
    $Res Function(SpeechSynthesisState) then,
  ) = _$SpeechSynthesisStateCopyWithImpl<$Res, SpeechSynthesisState>;
  @useResult
  $Res call({
    DataState<SpeechResponseModel> dataState,
    TTSServiceModel selectedService,
    bool isRefreshing,
  });

  $DataStateCopyWith<SpeechResponseModel, $Res> get dataState;
}

/// @nodoc
class _$SpeechSynthesisStateCopyWithImpl<
  $Res,
  $Val extends SpeechSynthesisState
>
    implements $SpeechSynthesisStateCopyWith<$Res> {
  _$SpeechSynthesisStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechSynthesisState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataState = null,
    Object? selectedService = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _value.copyWith(
            dataState: null == dataState
                ? _value.dataState
                : dataState // ignore: cast_nullable_to_non_nullable
                      as DataState<SpeechResponseModel>,
            selectedService: null == selectedService
                ? _value.selectedService
                : selectedService // ignore: cast_nullable_to_non_nullable
                      as TTSServiceModel,
            isRefreshing: null == isRefreshing
                ? _value.isRefreshing
                : isRefreshing // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SpeechSynthesisState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataStateCopyWith<SpeechResponseModel, $Res> get dataState {
    return $DataStateCopyWith<SpeechResponseModel, $Res>(_value.dataState, (
      value,
    ) {
      return _then(_value.copyWith(dataState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpeechSynthesisStateImplCopyWith<$Res>
    implements $SpeechSynthesisStateCopyWith<$Res> {
  factory _$$SpeechSynthesisStateImplCopyWith(
    _$SpeechSynthesisStateImpl value,
    $Res Function(_$SpeechSynthesisStateImpl) then,
  ) = __$$SpeechSynthesisStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DataState<SpeechResponseModel> dataState,
    TTSServiceModel selectedService,
    bool isRefreshing,
  });

  @override
  $DataStateCopyWith<SpeechResponseModel, $Res> get dataState;
}

/// @nodoc
class __$$SpeechSynthesisStateImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisStateCopyWithImpl<$Res, _$SpeechSynthesisStateImpl>
    implements _$$SpeechSynthesisStateImplCopyWith<$Res> {
  __$$SpeechSynthesisStateImplCopyWithImpl(
    _$SpeechSynthesisStateImpl _value,
    $Res Function(_$SpeechSynthesisStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataState = null,
    Object? selectedService = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _$SpeechSynthesisStateImpl(
        dataState: null == dataState
            ? _value.dataState
            : dataState // ignore: cast_nullable_to_non_nullable
                  as DataState<SpeechResponseModel>,
        selectedService: null == selectedService
            ? _value.selectedService
            : selectedService // ignore: cast_nullable_to_non_nullable
                  as TTSServiceModel,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SpeechSynthesisStateImpl extends _SpeechSynthesisState {
  const _$SpeechSynthesisStateImpl({
    this.dataState = const DataState<SpeechResponseModel>.initial(),
    this.selectedService = TTSServiceModel.gemini,
    this.isRefreshing = false,
  }) : super._();

  @override
  @JsonKey()
  final DataState<SpeechResponseModel> dataState;
  @override
  @JsonKey()
  final TTSServiceModel selectedService;
  @override
  @JsonKey()
  final bool isRefreshing;

  @override
  String toString() {
    return 'SpeechSynthesisState(dataState: $dataState, selectedService: $selectedService, isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechSynthesisStateImpl &&
            (identical(other.dataState, dataState) ||
                other.dataState == dataState) &&
            (identical(other.selectedService, selectedService) ||
                other.selectedService == selectedService) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, dataState, selectedService, isRefreshing);

  /// Create a copy of SpeechSynthesisState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechSynthesisStateImplCopyWith<_$SpeechSynthesisStateImpl>
  get copyWith =>
      __$$SpeechSynthesisStateImplCopyWithImpl<_$SpeechSynthesisStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SpeechSynthesisState extends SpeechSynthesisState {
  const factory _SpeechSynthesisState({
    final DataState<SpeechResponseModel> dataState,
    final TTSServiceModel selectedService,
    final bool isRefreshing,
  }) = _$SpeechSynthesisStateImpl;
  const _SpeechSynthesisState._() : super._();

  @override
  DataState<SpeechResponseModel> get dataState;
  @override
  TTSServiceModel get selectedService;
  @override
  bool get isRefreshing;

  /// Create a copy of SpeechSynthesisState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechSynthesisStateImplCopyWith<_$SpeechSynthesisStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

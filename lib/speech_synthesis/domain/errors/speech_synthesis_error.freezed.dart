// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_synthesis_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpeechSynthesisError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechSynthesisErrorCopyWith<$Res> {
  factory $SpeechSynthesisErrorCopyWith(
    SpeechSynthesisError value,
    $Res Function(SpeechSynthesisError) then,
  ) = _$SpeechSynthesisErrorCopyWithImpl<$Res, SpeechSynthesisError>;
}

/// @nodoc
class _$SpeechSynthesisErrorCopyWithImpl<
  $Res,
  $Val extends SpeechSynthesisError
>
    implements $SpeechSynthesisErrorCopyWith<$Res> {
  _$SpeechSynthesisErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ValidationErrorImplCopyWith<$Res> {
  factory _$$ValidationErrorImplCopyWith(
    _$ValidationErrorImpl value,
    $Res Function(_$ValidationErrorImpl) then,
  ) = __$$ValidationErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ValidationErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$ValidationErrorImpl>
    implements _$$ValidationErrorImplCopyWith<$Res> {
  __$$ValidationErrorImplCopyWithImpl(
    _$ValidationErrorImpl _value,
    $Res Function(_$ValidationErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ValidationErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ValidationErrorImpl implements ValidationError {
  const _$ValidationErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SpeechSynthesisError.validation(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationErrorImplCopyWith<_$ValidationErrorImpl> get copyWith =>
      __$$ValidationErrorImplCopyWithImpl<_$ValidationErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return validation(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return validation?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationError implements SpeechSynthesisError {
  const factory ValidationError(final String message) = _$ValidationErrorImpl;

  String get message;

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationErrorImplCopyWith<_$ValidationErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimeoutErrorImplCopyWith<$Res> {
  factory _$$TimeoutErrorImplCopyWith(
    _$TimeoutErrorImpl value,
    $Res Function(_$TimeoutErrorImpl) then,
  ) = __$$TimeoutErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TimeoutErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$TimeoutErrorImpl>
    implements _$$TimeoutErrorImplCopyWith<$Res> {
  __$$TimeoutErrorImplCopyWithImpl(
    _$TimeoutErrorImpl _value,
    $Res Function(_$TimeoutErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TimeoutErrorImpl implements TimeoutError {
  const _$TimeoutErrorImpl();

  @override
  String toString() {
    return 'SpeechSynthesisError.timeout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimeoutErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return timeout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return timeout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return timeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return timeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(this);
    }
    return orElse();
  }
}

abstract class TimeoutError implements SpeechSynthesisError {
  const factory TimeoutError() = _$TimeoutErrorImpl;
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
    _$NetworkErrorImpl value,
    $Res Function(_$NetworkErrorImpl) then,
  ) = __$$NetworkErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
    _$NetworkErrorImpl _value,
    $Res Function(_$NetworkErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkErrorImpl implements NetworkError {
  const _$NetworkErrorImpl();

  @override
  String toString() {
    return 'SpeechSynthesisError.networkError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return networkError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return networkError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class NetworkError implements SpeechSynthesisError {
  const factory NetworkError() = _$NetworkErrorImpl;
}

/// @nodoc
abstract class _$$TooManyRequestsErrorImplCopyWith<$Res> {
  factory _$$TooManyRequestsErrorImplCopyWith(
    _$TooManyRequestsErrorImpl value,
    $Res Function(_$TooManyRequestsErrorImpl) then,
  ) = __$$TooManyRequestsErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TooManyRequestsErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$TooManyRequestsErrorImpl>
    implements _$$TooManyRequestsErrorImplCopyWith<$Res> {
  __$$TooManyRequestsErrorImplCopyWithImpl(
    _$TooManyRequestsErrorImpl _value,
    $Res Function(_$TooManyRequestsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TooManyRequestsErrorImpl implements TooManyRequestsError {
  const _$TooManyRequestsErrorImpl();

  @override
  String toString() {
    return 'SpeechSynthesisError.tooManyRequests()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TooManyRequestsErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return tooManyRequests();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return tooManyRequests?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (tooManyRequests != null) {
      return tooManyRequests();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return tooManyRequests(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return tooManyRequests?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (tooManyRequests != null) {
      return tooManyRequests(this);
    }
    return orElse();
  }
}

abstract class TooManyRequestsError implements SpeechSynthesisError {
  const factory TooManyRequestsError() = _$TooManyRequestsErrorImpl;
}

/// @nodoc
abstract class _$$UnauthorizedErrorImplCopyWith<$Res> {
  factory _$$UnauthorizedErrorImplCopyWith(
    _$UnauthorizedErrorImpl value,
    $Res Function(_$UnauthorizedErrorImpl) then,
  ) = __$$UnauthorizedErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthorizedErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$UnauthorizedErrorImpl>
    implements _$$UnauthorizedErrorImplCopyWith<$Res> {
  __$$UnauthorizedErrorImplCopyWithImpl(
    _$UnauthorizedErrorImpl _value,
    $Res Function(_$UnauthorizedErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnauthorizedErrorImpl implements UnauthorizedError {
  const _$UnauthorizedErrorImpl();

  @override
  String toString() {
    return 'SpeechSynthesisError.unauthorized()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnauthorizedErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return unauthorized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return unauthorized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedError implements SpeechSynthesisError {
  const factory UnauthorizedError() = _$UnauthorizedErrorImpl;
}

/// @nodoc
abstract class _$$ForbiddenErrorImplCopyWith<$Res> {
  factory _$$ForbiddenErrorImplCopyWith(
    _$ForbiddenErrorImpl value,
    $Res Function(_$ForbiddenErrorImpl) then,
  ) = __$$ForbiddenErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ForbiddenErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$ForbiddenErrorImpl>
    implements _$$ForbiddenErrorImplCopyWith<$Res> {
  __$$ForbiddenErrorImplCopyWithImpl(
    _$ForbiddenErrorImpl _value,
    $Res Function(_$ForbiddenErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ForbiddenErrorImpl implements ForbiddenError {
  const _$ForbiddenErrorImpl();

  @override
  String toString() {
    return 'SpeechSynthesisError.forbidden()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ForbiddenErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return forbidden();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return forbidden?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return forbidden(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return forbidden?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(this);
    }
    return orElse();
  }
}

abstract class ForbiddenError implements SpeechSynthesisError {
  const factory ForbiddenError() = _$ForbiddenErrorImpl;
}

/// @nodoc
abstract class _$$ServiceUnavailableErrorImplCopyWith<$Res> {
  factory _$$ServiceUnavailableErrorImplCopyWith(
    _$ServiceUnavailableErrorImpl value,
    $Res Function(_$ServiceUnavailableErrorImpl) then,
  ) = __$$ServiceUnavailableErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ServiceUnavailableErrorImplCopyWithImpl<$Res>
    extends
        _$SpeechSynthesisErrorCopyWithImpl<$Res, _$ServiceUnavailableErrorImpl>
    implements _$$ServiceUnavailableErrorImplCopyWith<$Res> {
  __$$ServiceUnavailableErrorImplCopyWithImpl(
    _$ServiceUnavailableErrorImpl _value,
    $Res Function(_$ServiceUnavailableErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ServiceUnavailableErrorImpl implements ServiceUnavailableError {
  const _$ServiceUnavailableErrorImpl();

  @override
  String toString() {
    return 'SpeechSynthesisError.serviceUnavailable()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceUnavailableErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return serviceUnavailable();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return serviceUnavailable?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (serviceUnavailable != null) {
      return serviceUnavailable();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return serviceUnavailable(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return serviceUnavailable?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (serviceUnavailable != null) {
      return serviceUnavailable(this);
    }
    return orElse();
  }
}

abstract class ServiceUnavailableError implements SpeechSynthesisError {
  const factory ServiceUnavailableError() = _$ServiceUnavailableErrorImpl;
}

/// @nodoc
abstract class _$$ServiceErrorImplCopyWith<$Res> {
  factory _$$ServiceErrorImplCopyWith(
    _$ServiceErrorImpl value,
    $Res Function(_$ServiceErrorImpl) then,
  ) = __$$ServiceErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ServiceErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$ServiceErrorImpl>
    implements _$$ServiceErrorImplCopyWith<$Res> {
  __$$ServiceErrorImplCopyWithImpl(
    _$ServiceErrorImpl _value,
    $Res Function(_$ServiceErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ServiceErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ServiceErrorImpl implements ServiceError {
  const _$ServiceErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SpeechSynthesisError.serviceError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceErrorImplCopyWith<_$ServiceErrorImpl> get copyWith =>
      __$$ServiceErrorImplCopyWithImpl<_$ServiceErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return serviceError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return serviceError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (serviceError != null) {
      return serviceError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return serviceError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return serviceError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (serviceError != null) {
      return serviceError(this);
    }
    return orElse();
  }
}

abstract class ServiceError implements SpeechSynthesisError {
  const factory ServiceError(final String message) = _$ServiceErrorImpl;

  String get message;

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceErrorImplCopyWith<_$ServiceErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownErrorImplCopyWith<$Res> {
  factory _$$UnknownErrorImplCopyWith(
    _$UnknownErrorImpl value,
    $Res Function(_$UnknownErrorImpl) then,
  ) = __$$UnknownErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownErrorImplCopyWithImpl<$Res>
    extends _$SpeechSynthesisErrorCopyWithImpl<$Res, _$UnknownErrorImpl>
    implements _$$UnknownErrorImplCopyWith<$Res> {
  __$$UnknownErrorImplCopyWithImpl(
    _$UnknownErrorImpl _value,
    $Res Function(_$UnknownErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnknownErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnknownErrorImpl implements UnknownError {
  const _$UnknownErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SpeechSynthesisError.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      __$$UnknownErrorImplCopyWithImpl<_$UnknownErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() timeout,
    required TResult Function() networkError,
    required TResult Function() tooManyRequests,
    required TResult Function() unauthorized,
    required TResult Function() forbidden,
    required TResult Function() serviceUnavailable,
    required TResult Function(String message) serviceError,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? timeout,
    TResult? Function()? networkError,
    TResult? Function()? tooManyRequests,
    TResult? Function()? unauthorized,
    TResult? Function()? forbidden,
    TResult? Function()? serviceUnavailable,
    TResult? Function(String message)? serviceError,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? timeout,
    TResult Function()? networkError,
    TResult Function()? tooManyRequests,
    TResult Function()? unauthorized,
    TResult Function()? forbidden,
    TResult Function()? serviceUnavailable,
    TResult Function(String message)? serviceError,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationError value) validation,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(NetworkError value) networkError,
    required TResult Function(TooManyRequestsError value) tooManyRequests,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(ForbiddenError value) forbidden,
    required TResult Function(ServiceUnavailableError value) serviceUnavailable,
    required TResult Function(ServiceError value) serviceError,
    required TResult Function(UnknownError value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationError value)? validation,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(NetworkError value)? networkError,
    TResult? Function(TooManyRequestsError value)? tooManyRequests,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(ForbiddenError value)? forbidden,
    TResult? Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult? Function(ServiceError value)? serviceError,
    TResult? Function(UnknownError value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationError value)? validation,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(NetworkError value)? networkError,
    TResult Function(TooManyRequestsError value)? tooManyRequests,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(ForbiddenError value)? forbidden,
    TResult Function(ServiceUnavailableError value)? serviceUnavailable,
    TResult Function(ServiceError value)? serviceError,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownError implements SpeechSynthesisError {
  const factory UnknownError(final String message) = _$UnknownErrorImpl;

  String get message;

  /// Create a copy of SpeechSynthesisError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

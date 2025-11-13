import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_state.freezed.dart';

/// Represents the state of async data operations
@freezed
sealed class DataState<T> with _$DataState<T> {
  const factory DataState.initial() = _Initial<T>;
  const factory DataState.loading() = _Loading<T>;
  const factory DataState.success({required T value}) = _Success<T>;
  const factory DataState.failure(Object error) = _Failure<T>;
}

extension DataStateExtension<T> on DataState<T> {
  bool get isLoading => this is _Loading<T>;
  bool get isSuccess => this is _Success<T>;
  bool get hasFailure => this is _Failure<T>;
  bool get isInitial => this is _Initial<T>;
  
  T? get value => switch (this) {
    _Success<T>(value: final v) => v,
    _ => null,
  };
  
  Object? get error => switch (this) {
    _Failure<T>(error: final e) => e,
    _ => null,
  };
}


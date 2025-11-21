import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_state.freezed.dart';

/// Sealed class representing the state of async data operations
/// 
/// This is a generic state machine for handling asynchronous operations in a type-safe way.
/// It uses Freezed to generate immutable classes and follows a sealed class pattern,
/// which ensures exhaustive pattern matching.
/// 
/// The state can be one of:
/// - initial: No operation has been started yet
/// - loading: An operation is currently in progress
/// - success: Operation completed successfully with a value of type T
/// - failure: Operation failed with an error
/// 
/// This pattern is commonly used in Flutter apps with Riverpod/Bloc for managing
/// async state without using FutureBuilder or StreamBuilder directly in widgets.
/// It provides better type safety and makes state transitions explicit.
/// 
/// This is part of the Core utilities layer and can be reused across different features.
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


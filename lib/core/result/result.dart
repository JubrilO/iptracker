import 'package:iptracker/core/errors/failure.dart';

class Result<T> {
  final T? _data;
  final Failure? _failure;
  
  // Private constructors to enforce using factory methods
  Result._({T? data, Failure? failure})
      : _data = data,
        _failure = failure;
  
  // Success result with data
  factory Result.success(T data) => Result._(data: data);
  
  // Failure result with error
  factory Result.failure(Failure failure) => Result._(failure: failure);
  
  // Check if result is success
  bool get isSuccess => _failure == null;
  
  // Check if result is failure
  bool get isFailure => _failure != null;
  
  // Get data (will be null if isFailure is true)
  T? get data => _data;
  
  // Get failure (will be null if isSuccess is true)
  Failure? get failure => _failure;
  
  // Fold method similar to Either to process both success and failure cases
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    if (isFailure) {
      return onFailure(_failure!);
    } else {
      return onSuccess(_data as T);
    }
  }
}
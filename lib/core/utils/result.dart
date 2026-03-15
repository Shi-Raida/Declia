import 'package:declia/core/errors/failures.dart';

sealed class Result<T, E extends Failure> {
  const Result();

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  R fold<R>({
    required R Function(T value) ok,
    required R Function(E error) err,
  });

  Result<U, E> map<U>(U Function(T value) transform);

  Result<T, F> mapError<F extends Failure>(F Function(E error) transform);

  T getOrElse(T Function(E error) orElse);
}

class Ok<T, E extends Failure> extends Result<T, E> {
  const Ok(this.value);
  final T value;

  @override
  R fold<R>({
    required R Function(T value) ok,
    required R Function(E error) err,
  }) => ok(value);

  @override
  Result<U, E> map<U>(U Function(T value) transform) => Ok(transform(value));

  @override
  Result<T, F> mapError<F extends Failure>(F Function(E error) transform) =>
      Ok(value);

  @override
  T getOrElse(T Function(E error) orElse) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ok<T, E> && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

class Err<T, E extends Failure> extends Result<T, E> {
  const Err(this.error);
  final E error;

  @override
  R fold<R>({
    required R Function(T value) ok,
    required R Function(E error) err,
  }) => err(error);

  @override
  Result<U, E> map<U>(U Function(T value) transform) => Err(error);

  @override
  Result<T, F> mapError<F extends Failure>(F Function(E error) transform) =>
      Err(transform(error));

  @override
  T getOrElse(T Function(E error) orElse) => orElse(error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Err<T, E> && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Err($error)';
}

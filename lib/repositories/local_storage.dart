// Package imports:
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/utils/failures.dart';

class LocalStorage<T> {
  T? _value;

  Future<Either<Failure, T>> getValueSafe() => _value != null
      ? Future.value(Right(_value!))
      : Future.value(Left(CacheFailure()));

  set value(T value) => _value = value;

  T get value => _value!;

  void clearStorage() => _value = null;

  bool get empty => _value == null;
}

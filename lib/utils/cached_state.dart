// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:either_dart/either.dart';

class CachedState<L, R> extends ChangeNotifier {
  Either<L, R?> _state;
  R? _cache;

  CachedState([R? initial]) : _state = Right(initial);

  CachedState<L, R> set(Either<L, R> x) {
    print('State set $x');
    _state = x;

    if (x.isRight) {
      _cache = x.right;
    }

    notifyListeners();

    return this;
  }

  CachedState<L, R> setRight(R right) {
    return set(Right(right));
  }

  T? foldRightOrNull<T>(
    T? Function(R right) right,
  ) {
    if (isRight) {
      return right(_state.right!);
    } else {
      return null;
    }
  }

  T fold<T>(
    T Function() empty,
    T Function(L left, [R? cache]) left,
    T Function(R right) right,
  ) {
    //print(
    //    'State Right = ${_state.isRight} - Cache Non null = ${_cache != null}');
    if (_cache == null && _state.isRight) {
      return empty();
    }
    if (_state.isLeft) {
      return left(_state.left, _cache);
    } else {
      return right(_state.right!);
    }
  }

  T biFold<T, RR>(
      CachedState<L, RR> other,
      T Function() empty,
      T Function(L left, [R? cache1, RR? cache2]) left,
      T Function(R right1, RR right2) right) {
    if (isEmpty || other.isEmpty) {
      return empty();
    }
    if (isLeft || other.isLeft) {
      return left(_state.then((_) => other._state).left, _cache, other._cache);
    }

    return right(_state.right!, other._state.right!);
  }

  Either<L, R> ifEmpty(
    Either<L, R> Function() empty,
  ) {
    if (_cache == null && _state.isRight) {
      return empty();
    } else {
      return _state.map((right) => right!);
    }
  }

  /// Returns a future containing the state if not empty,
  /// otherwise will get a state executing the function [empty]
  Future<Either<L, R>> ifEmptyAsync(
    Future<Either<L, R>> Function() empty,
  ) {
    if (_cache == null && _state.isRight) {
      return empty();
    } else {
      return Future.value(_state.map((right) => right!));
    }
  }

  bool get isEmpty => _cache == null && _state.isRight;

  bool get isLeft => _state.isLeft;

  bool get isRight => _cache != null && _state.isRight;

  R? get cache => _cache;

  Either<L, R?> get state => _state;

  void clearCache() {
    _cache = null;
    _state = Right(null);
  }
}

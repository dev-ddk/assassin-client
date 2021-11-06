// Dart imports:
import 'dart:async';

// Package imports:
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

/// A periodic task is a task that is executed periodically if there is any objects that activates it
///
/// PeriodicTask keeps a updated an use count: A number that should correspond on how many objects are interested in
/// the periodic task running.
class PeriodicTask {
  Timer? _updater;
  final Function task;
  final Duration period;
  int _useCount = 0;

  /// Instatiate [PeriodicTask] without starting it
  ///
  /// [task] is a possibly void (async) callback that will be executed once every [period] when the PeriodicTask is started
  PeriodicTask({required this.task, required this.period});

  /// Increases the use count of the periodic task. When the periodic task
  /// is used at least 1 time it will start executing the [task] every [period] seconds.
  ///
  /// If [zeroWait] named parameter is set to true then [task] is fired immediatly (fire and forget),
  /// otherwise a period will be waited to execute [task]
  ///
  /// Make sure that for each [start()] call there is a corresponding [stop()] call when the object is disposed or
  /// the periodic Task is no more needed by that object
  void start({bool zeroWait = false}) {
    // Fire and forget [task] if zeroWait flag is on
    if (zeroWait) {
      task();
    }

    if (_useCount == 0) {
      _updater = Timer.periodic(
        period,
        (timer) {
          task();
        },
      );
    }

    _useCount++;
  }

  /// Halts the autoupdater and sets refcount to 0
  ///
  /// This method clears the use count of the timer, so the
  /// timer will be stopped even if there were other resources
  /// using it
  void clear() {
    _useCount = 0;
    stop();
  }

  /// Decrements one use count from the timer
  ///
  /// If the use count reaches 0 the timer will be stopped
  /// The use count will never be under 0
  void stop() {
    if (_useCount > 0) {
      _useCount--;
    }

    if (_useCount == 0) {
      _updater?.cancel();
      _updater = null;
    }
  }

  bool get started => _updater != null;

  int get useCount => _useCount;
}

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

class PeriodicTask {
  Timer? _updater;
  final Function task;
  final Duration period;

  PeriodicTask({required this.task, required this.period});

  ///Starts the autoupdater
  void start({bool zeroWait = false, bool restartIfRunning = false}) {
    // Do nothing if already running is true and restartIfRunning = false
    if (_updater != null && !restartIfRunning) {
      if (zeroWait) {
        task();
      }
      return;
    }
    // Stop if already running and restartIfRunning = true
    if (_updater != null && restartIfRunning) {
      stop();
    }
    // In all cases execute task immediatly (fire and forget)
    if (zeroWait) {
      task();
    }
    _updater = Timer.periodic(
      period,
      (timer) {
        task();
      },
    );
  }

  ///Halts the autoupdater
  void stop() {
    _updater?.cancel();
    _updater = null;
  }

  bool get started => _updater != null;
}

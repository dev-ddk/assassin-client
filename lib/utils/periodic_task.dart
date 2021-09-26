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
  void start({bool zeroWait = false}) {
    if (zeroWait) {
      task();
    }
    // Stop if already running
    if (_updater != null) {
      stop();
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

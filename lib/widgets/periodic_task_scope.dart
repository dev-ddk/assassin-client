// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/utils/periodic_task.dart';

class PeriodicTaskScope extends ConsumerWidget {
  final List<Provider<PeriodicTask>> _ptasks;
  final Widget child;

  PeriodicTaskScope({
    Key? key,
    required Provider<PeriodicTask> provider,
    required this.child,
  })  : _ptasks = [provider],
        super(key: key);

  PeriodicTaskScope.multiple({
    Key? key,
    required List<Provider<PeriodicTask>> providers,
    required this.child,
  })  : _ptasks = List.from(providers),
        super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return _PeriodicTaskScopeManager(_ptasks, watch, child);
  }
}

class _PeriodicTaskScopeManager extends StatefulWidget {
  final List<Provider<PeriodicTask>> ptasks;
  final ScopedReader watch;
  final Widget child;

  _PeriodicTaskScopeManager(this.ptasks, this.watch, this.child);

  @override
  _PeriodicTaskScopeManagerState createState() =>
      _PeriodicTaskScopeManagerState();
}

class _PeriodicTaskScopeManagerState extends State<_PeriodicTaskScopeManager> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    for (var task in widget.ptasks) {
      widget.watch(task).start(zeroWait: true);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var task in widget.ptasks) {
      widget.watch(task).stop();
    }
    super.dispose();
  }
}

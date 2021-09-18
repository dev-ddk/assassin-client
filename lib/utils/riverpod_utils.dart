// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Watcher<T> = T Function(AlwaysAliveProviderBase<Object?, T> provider);

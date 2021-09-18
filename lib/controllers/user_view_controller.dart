// Package imports:
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/datasources/user_datasource.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/cached_state.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/periodic_task.dart';
import 'package:assassin_client/utils/riverpod_utils.dart';

final userState =
    StateProvider<CachedState<Failure, UserEntity>>((ref) => CachedState());

final userUpdater = StateProvider<PeriodicTask>(
  (ref) => PeriodicTask(
    task: () async => unawaited(ref.watch(userViewCntrl).updateState()),
    period: Duration(seconds: 10),
  ),
);

class UserViewController {
  final Watcher read;
  final UserDataSource userDS;

  UserViewController(this.read, this.userDS);

  Future<Either<Failure, UserEntity>> updateState() async {
    final newValue = await userDS.userInfo().mapRight(UserEntity.fromUserModel);

    read(userState).state = read(userState).state.set(newValue);

    return newValue;
  }
}

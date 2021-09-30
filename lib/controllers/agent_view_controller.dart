// Package imports:
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/controllers/game_view_controller.dart';
import 'package:assassin_client/datasources/agent_datasources.dart';
import 'package:assassin_client/datasources/codenames_datasources.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:assassin_client/models/agent_model.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/cached_state.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/periodic_task.dart';
import 'package:assassin_client/utils/riverpod_utils.dart';

final agentState = ChangeNotifierProvider<CachedState<Failure, AgentEntity>>(
    (ref) => CachedState());

final agentUpdater = StateProvider<PeriodicTask>(
  (ref) => PeriodicTask(
    task: () async => unawaited(ref.watch(agentViewCntrl).updateState()),
    period: Duration(seconds: 10),
  ),
);

var logger = Logger(printer: PrettyPrinter());

/*

Agent class definition

factory AgentEntity({
  required String agentName,
  String? target,
  @Default(true) bool alive,
  @Default(0) int kills,
}) = _AgentEntity;

*/

class AgentViewController {
  final Watcher read;
  final AgentDataSource agentDS;
  final CodenamesDataSource codenameDS;

  AgentViewController(this.read, this.agentDS, this.codenameDS);

  Future<Either<Failure, AgentEntity>> updateState() async {
    final gameCntrl = read(gameViewCntrl);

    final maybeGameCode = await read(gameState)
        .ifEmptyAsync(gameCntrl.updateState)
        .mapRight((game) => game.gameCode);

    if (maybeGameCode.isLeft) {
      // Update state
      read(gameState).set(Left(maybeGameCode.left));
      // Autoconvert the future to correct return type
      return Left(maybeGameCode.left);
    }

    final gameCode = maybeGameCode.right;

    final newValue =
        await agentDS.agentInfo(gameCode).mapRight(_convertFromModel);
    read(agentState).set(newValue);

    return newValue;
  }

  Future<Either<void, AgentEntity>> kill() async {
    final gameCntrl = read(gameViewCntrl);

    return await read(gameState)
        .ifEmptyAsync(gameCntrl.updateState)
        .mapRight((game) => game.gameCode)
        .thenRight((gameCode) => agentDS.kill(gameCode))
        .thenRight((_) => updateState());
  }

  AgentEntity _convertFromModel(AgentModel model) => AgentEntity(
        agentName: model.codename, //TODO: Find a way to get it from APIs
        target: model.target,
        alive: model.alive,
        kills: model.kills,
      );
}

// Package imports:
import 'package:assassin_client/controllers/agent_view_controller.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/datasources/end_game_datasources.dart';
import 'package:assassin_client/datasources/game_status_datasources.dart';
import 'package:assassin_client/datasources/lobby_datasources.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:assassin_client/models/game_status_model.dart';
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/cached_state.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/periodic_task.dart';
import 'package:assassin_client/utils/riverpod_utils.dart';

final gameState = ChangeNotifierProvider<CachedState<Failure, GameEntity>>(
    (ref) => CachedState());

var logger = Logger(printer: PrettyPrinter());

final gameUpdater = Provider<PeriodicTask>(
  (ref) => PeriodicTask(
    task: () async => unawaited(ref.watch(gameViewCntrl).updateState()),
    period: Duration(seconds: 10),
  ),
);

class GameViewController {
  final Watcher read;
  final LobbyDataSource gameDS;
  final GameStatusDataSource statusDS;
  final EndTimeDataSource endDS;

  GameViewController(this.read, this.gameDS, this.statusDS, this.endDS);

  Future<Either<Failure, GameEntity>> updateState() async {
    final userCntrl = read(userViewCntrl);

    /* TO SKIP UPDATE IF NOT EMPTY
    final newState = await read(userState)
        .state
        .ifEmptyAsync(() => userCntrl.updateState())...
    */

    final maybeNewCode = await userCntrl
        //Update user data to check if game code is changed
        .updateState()
        //Extract user current game code
        .mapRight((user) => user.currGameCode)
        // Fail if the game code is still null
        .thenRightSync(_failIfNull);

    if (maybeNewCode.isLeft) {
      read(gameState).set(Left(maybeNewCode.left));

      return Left(maybeNewCode.left);
    }

    final gameCode = maybeNewCode.right;

    // Call the endpoint with the info about the game
    final newValue =
        await gameDS.gameInfo(gameCode).thenRight((model) => statusDS
            // Call the endpoint to update the Status of the game
            .getGameStatus(gameCode)
            // Convert model to entity
            .mapRight((status) => _convertFromModel(gameCode, model, status)));

    read(gameState).set(newValue);

    return newValue;
  }

  Future<Either<Failure, void>> createGame(String gameName) async =>
      await gameDS.createGame(gameName).thenRight((_) => updateState());

  Future<Either<Failure, void>> joinGame(String gameCode) async =>
      await gameDS.joinGame(gameCode).thenRight((_) => updateState());

  Future<Either<Failure, void>> startGame() async => await updateState()
      .mapRight((game) => game.gameCode)
      .thenRight((gameCode) =>
          statusDS.startGame(gameCode).thenRight((_) => updateState()));

  Future<Either<Failure, void>> endGame() async => await updateState()
      .mapRight((game) => game.gameCode)
      .thenRight((gameCode) => statusDS.endGame(gameCode))
      .thenRight((right) => updateState());

  Either<Failure, String> _failIfNull(String? x) => x != null
      ? Right(x)
      : Left(
          StatusFailure.log(
            code: 'PLAYER_NOT_IN_LOBBY',
            message: 'Player is not joined in any lobby',
            logger: logger,
          ),
        );

  GameEntity _convertFromModel(
          String gameCode, LobbyModel model, GameStatus status) =>
      GameEntity(
        gameName: model.name,
        gameCode: gameCode,
        admin: model.admin!,
        gameStatus: status,
        users: model.players
            .map((e) => OtherUserEntity(username: e.username))
            .toList(),
      );
}

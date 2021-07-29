// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/models/game_status_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class GameStatusRepository {
  //final RemoteGameStatusStorage _remoteStorage;
  //final LocalStorage<GameStatus> _localStorage;
}

abstract class RemoteGameStatusStorage {
  Future<Either<Failure, GameStatus>> getGameStatus(String gameCode);

  Future<Either<Failure, void>> startGame(String gameCode);

  Future<Either<Failure, void>> endGame(String gameCode);
}

class RemoteGameStatusStorageImpl implements RemoteGameStatusStorage {
  @override
  Future<Either<Failure, void>> endGame(String gameCode) {
    // TODO: implement endGame
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GameStatus>> getGameStatus(String gameCode) async {
    final dio = Dio();
    return await authenticateRequest(dio)
        .thenRight((dio) => _getGameStatusRequest(dio, gameCode));
  }

  Future<Either<Failure, GameStatus>> _getGameStatusRequest(
      Dio dio, String gameCode) async {
    final response =
        await dio.get('game_status', queryParameters: {'game_id': gameCode});
    if (response.statusCode == 200) {
      final status = GameStatusGettersAndSetters.fromString(response.data);
      return status != null ? Right(status) : Left(RequestFailure());
    } else if (response.statusCode == 401) {
      return Left(AuthFailure());
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> startGame(String gameCode) {
    // TODO: implement startGame
    throw UnimplementedError();
  }
}

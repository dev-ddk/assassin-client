// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/models/game_status_model.dart';
import 'package:assassin_client/repositories/local_storage.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

class GameStatusRepository {
  final RemoteGameStatusStorage _remoteStorage;
  final LocalStorage<GameStatus> _localStorage;

  GameStatusRepository({required RemoteGameStatusStorage remoteStorage})
      : _remoteStorage = remoteStorage,
        _localStorage = LocalStorage();

  Future<Either<Failure, GameStatus>> getGameStatus(String gameCode,
      {bool forceRemote = false}) async {
    if (_localStorage.empty || forceRemote) {
      final status = await _remoteStorage.getGameStatus(gameCode);
      if (status.isRight) {
        _localStorage.value = status.right;
      }
      return status;
    } else {
      return _localStorage.getValueSafe();
    }
  }

  Future<Either<Failure, GameStatus>> startGame(String gameCode) =>
      _remoteStorage
          .startGame(gameCode)
          .thenRight((_) => getGameStatus(gameCode, forceRemote: true));

  Future<Either<Failure, GameStatus>> endGame(String gameCode) => _remoteStorage
      .endGame(gameCode)
      .thenRight((_) => getGameStatus(gameCode, forceRemote: true));
}

abstract class RemoteGameStatusStorage {
  Future<Either<Failure, GameStatus>> getGameStatus(String gameCode);

  Future<Either<Failure, void>> startGame(String gameCode);

  Future<Either<Failure, void>> endGame(String gameCode);
}

class RemoteGameStatusStorageImpl implements RemoteGameStatusStorage {
  @override
  Future<Either<Failure, void>> endGame(String gameCode) async {
    final dio = Dio();
    return await authenticateRequest(dio)
        .thenRight((dio) => _endGameRequest(dio, gameCode));
  }

  Future<Either<Failure, void>> _endGameRequest(
      Dio dio, String gameCode) async {
    try {
      await dio.post('end_game', queryParameters: {'game_id': gameCode});
      return Right(null);
    } on DioError catch (e) {
      final response = e.response;
      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/end_game (POST) request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/end_game network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, GameStatus>> getGameStatus(String gameCode) async {
    final dio = Dio();
    return await authenticateRequest(dio)
        .thenRight((dio) => _getGameStatusRequest(dio, gameCode));
  }

  Future<Either<Failure, GameStatus>> _getGameStatusRequest(
      Dio dio, String gameCode) async {
    try {
      final response =
          await dio.get('game_status', queryParameters: {'game_id': gameCode});
      final status = GameStatusGettersAndSetters.fromString(response.data);
      return status != null
          ? Right(status)
          : Left(
              PadrinconiaFailure(
                code: 'PAD-001',
                message: 'Invalid status received',
              ),
            );
    } on DioError catch (e) {
      final response = e.response;
      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/game_status request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/game_status network failure',
            errorType: e.type,
            logger: logger,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, void>> startGame(String gameCode) async {
    final dio = Dio();
    return await authenticateRequest(dio)
        .thenRight((dio) => _startGameRequest(dio, gameCode));
  }

  Future<Either<Failure, void>> _startGameRequest(
      Dio dio, String gameCode) async {
    try {
      await dio.post('start_game', queryParameters: {'game_id': gameCode});
      return Right(null);
    } on DioError catch (e) {
      final response = e.response;
      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/start_game request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/start_game network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

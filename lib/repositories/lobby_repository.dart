// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

class LobbyRepository {
  final RemoteLobbyStorage _remoteLobbyStorage;

  LobbyRepository(this._remoteLobbyStorage);

  Future<Either<Failure, LobbyModel>> createAndJoinLobby(
    String lobbyName,
  ) async {
    return await _remoteLobbyStorage
        .createGame(lobbyName)
        .thenRight((lobbyCode) => lobbyInfo(lobbyCode));
  }

  Future<Either<Failure, LobbyModel>> joinLobby(
    String lobbyCode,
  ) async {
    return await _remoteLobbyStorage
        .joinGame(lobbyCode)
        .thenRight((_) => lobbyInfo(lobbyCode));
  }

  Future<Either<Failure, LobbyModel>> lobbyInfo(
    String lobbyCode,
  ) async {
    return await _remoteLobbyStorage.gameInfo(lobbyCode);
  }
}

abstract class RemoteLobbyStorage {
  Future<Either<Failure, String>> createGame(String lobbyName);

  Future<Either<Failure, void>> joinGame(String lobbyCode);

  Future<Either<Failure, LobbyModel>> gameInfo(String lobbyCode);
}

class RemoteLobbyStorageImpl implements RemoteLobbyStorage {
  @override
  Future<Either<Failure, String>> createGame(
    String lobbyName,
  ) async {
    final dio = Dio(baseOptions());

    return authenticateRequest(dio)
        .thenRight((dio) => _createGameRequest(dio, lobbyName));
  }

  Future<Either<Failure, String>> _createGameRequest(
    Dio dio,
    String lobbyName,
  ) async {
    try {
      final response = await dio.post(
        'create_game',
        data: {'game_name': lobbyName},
      );

      logger.i('/create_game success\nResponse: ${response.data}');
      logger.d(response.data);

      return Right(response.data['gameCode']);
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        logger.i(response.requestOptions.uri);
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/create_game request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/create_game network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, void>> joinGame(
    String lobbyCode,
  ) async {
    final dio = Dio(baseOptions());

    return authenticateRequest(dio)
        .thenRight((dio) => _joinGameRequest(dio, lobbyCode));
  }

  Future<Either<Failure, void>> _joinGameRequest(
    Dio dio,
    String lobbyCode,
  ) async {
    try {
      final response = await dio.get(
        'join_game',
        queryParameters: {'gameCode': lobbyCode},
      );

      logger.i(response);
      logger.d(response.data);

      return Right(null);
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        if (response.statusCode == 404) {
          return Left(
            LobbyNotExistsFailure.log(
              code: 'REQ-002',
              message: '/join_game: Lobby does not exists',
              logger: logger,
            ),
          );
        } else {
          return Left(
            RequestFailure.log(
              code: 'REQ-001',
              message: '/join_game request failure',
              response: response,
              logger: logger,
            ),
          );
        }
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/join_game network_failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, LobbyModel>> gameInfo(
    String lobbyCode,
  ) async {
    final dio = Dio(baseOptions());

    return authenticateRequest(dio)
        .thenRight((dio) => _gameInfoRequest(dio, lobbyCode));
  }

  Future<Either<Failure, LobbyModel>> _gameInfoRequest(
    Dio dio,
    String lobbyCode,
  ) async {
    try {
      final response = await dio.get(
        'game_info',
        queryParameters: {'gameCode': lobbyCode},
      );

      logger.i('/game_info: response code ${response.statusCode}');
      logger.d(response.data);

      return Right(LobbyModel.fromJson(lobbyCode, response.data));
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        if (response.statusCode == 404) {
          return Left(
            LobbyNotExistsFailure.log(
              code: 'REQ-002',
              message: '/game_info: Lobby does not exists',
              logger: logger,
            ),
          );
        } else {
          return Left(
            RequestFailure.log(
              code: 'REQ-001',
              message: '/game_info request failure',
              response: response,
              logger: logger,
            ),
          );
        }
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/game_info network_failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

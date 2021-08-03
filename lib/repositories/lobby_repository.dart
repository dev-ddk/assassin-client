// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class LobbyRepository {
  final RemoteLobbyStorage _remoteLobbyStorage;

  LobbyRepository(this._remoteLobbyStorage);

  Future<Either<Failure, LobbyModel>> createAndJoinLobby(
      String lobbyName) async {
    return await _remoteLobbyStorage
        .createGame(lobbyName)
        .thenRight((lobbyCode) => joinLobby(lobbyCode));
  }

  Future<Either<Failure, LobbyModel>> joinLobby(String lobbyCode) async {
    return await _remoteLobbyStorage
        .joinGame(lobbyCode)
        .thenRight((_) => lobbyInfo(lobbyCode));
  }

  Future<Either<Failure, LobbyModel>> lobbyInfo(String lobbyCode) async {
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
  Future<Either<Failure, String>> createGame(String lobbyName) async {
    final dio = Dio(baseOptions());
    return authenticateRequest(dio)
        .thenRight((dio) => _createGameRequest(dio, lobbyName));
  }

  Future<Either<Failure, String>> _createGameRequest(
      Dio dio, String lobbyName) async {
    try {
      final response = await dio
          .get('create_game', queryParameters: {'game_name': lobbyName});
      return Right(response.data['game_id']);
    } on DioError catch (e) {
      final response = e.response;
      print(response?.requestOptions.path);
      if (response != null) {
        return Left(RequestFailure(statusCode: response.statusCode));
      } else {
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> joinGame(String lobbyCode) async {
    final dio = Dio(baseOptions());
    return authenticateRequest(dio)
        .thenRight((dio) => _joinGameRequest(dio, lobbyCode));
  }

  Future<Either<Failure, void>> _joinGameRequest(
      Dio dio, String lobbyCode) async {
    try {
      await dio.get('join_game', queryParameters: {'game_id': lobbyCode});
      return Right(null);
    } on DioError catch (e) {
      final response = e.response;
      print(response);
      if (response != null) {
        if (response.statusCode == 404) {
          return Left(LobbyNotExistsFailure());
        } else {
          return Left(RequestFailure(statusCode: response.statusCode));
        }
      } else {
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, LobbyModel>> gameInfo(String lobbyCode) async {
    final dio = Dio(baseOptions());
    return authenticateRequest(dio)
        .thenRight((dio) => _gameInfoRequest(dio, lobbyCode));
  }

  Future<Either<Failure, LobbyModel>> _gameInfoRequest(
      Dio dio, String lobbyName) async {
    try {
      final response =
          await dio.get('join_game', queryParameters: {'game_id': lobbyName});
      return Right(LobbyModel.fromJson(response.data));
    } on DioError catch (e) {
      final response = e.response;
      print(response);
      if (response != null) {
        if (response.statusCode == 404) {
          return Left(LobbyNotExistsFailure());
        } else {
          return Left(RequestFailure(statusCode: response.statusCode));
        }
      } else {
        return Left(NetworkFailure());
      }
    }
  }
}

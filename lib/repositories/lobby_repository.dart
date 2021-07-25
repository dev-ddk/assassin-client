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
    final response =
        await dio.get('create_game', queryParameters: {'game_name': lobbyName});
    if (response.statusCode == 201) {
      return Right(response.data['game_id']);
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
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
    final response =
        await dio.get('join_game', queryParameters: {'game_id': lobbyCode});
    if (response.statusCode == 201) {
      return Right(null);
    } else if (response.statusCode == 404) {
      return Left(LobbyNotExistsFailure());
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
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
    final response =
        await dio.get('game_info', queryParameters: {'game_id': lobbyName});
    if (response.statusCode == 201) {
      return Right(LobbyModel.fromJson(response.data));
    } else if (response.statusCode == 404) {
      return Left(LobbyNotExistsFailure());
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }
}

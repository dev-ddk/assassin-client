// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/models/game_stats_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';
import 'local_storage.dart';

var logger = Logger(printer: PrettyPrinter());

class GameStatsRepository {
  final GameStatsRemoteStorage _remoteStorage;
  final LocalStorage<GameStatsModel> _localStorage;

  GameStatsRepository(
    GameStatsRemoteStorage remoteStorage,
  )   : _remoteStorage = remoteStorage,
        _localStorage = LocalStorage<GameStatsModel>();

  Future<Either<Failure, GameStatsModel>> getEndTime(
    String lobbyCode, {
    bool forceRemote = false,
  }) async {
    if (_localStorage.empty || forceRemote) {
      final result = await _remoteStorage.getEndTime(lobbyCode);

      if (result.isRight) {
        _localStorage.value = result.right;
      }

      return result;
    } else {
      return _localStorage.getValueSafe();
    }
  }
}

abstract class GameStatsRemoteStorage {
  Future<Either<Failure, GameStatsModel>> getEndTime(String lobbyCode);
}

class EndTimeRemoteStorageImpl implements GameStatsRemoteStorage {
  @override
  Future<Either<Failure, GameStatsModel>> getEndTime(
    String lobbyCode,
  ) async {
    final dio = Dio();

    return await authenticateRequest(dio)
        .thenRight((dio) => _getEndTimeRequest(dio, lobbyCode));
  }

  Future<Either<Failure, GameStatsModel>> _getEndTimeRequest(
      Dio dio, String lobbyCode) async {
    try {
      final response = await dio.get(
        'game_stats',
        queryParameters: {'gameCode': lobbyCode},
      );

      return Right(GameStatsModel.fromJson(response.data));
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/game_stats request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/game_stats network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

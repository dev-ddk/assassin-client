// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/repositories/local_storage.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

class CodenamesRepository {
  final CodenamesRemoteStorage _remoteStorage;
  final LocalStorage<List<String>> _localStorage;

  CodenamesRepository({
    required remoteStorage,
  })  : _remoteStorage = remoteStorage,
        _localStorage = LocalStorage();

  Future<Either<Failure, List<String>>> getCodenames(
    String lobbyCode, {
    bool forceRemote = false,
  }) async {
    if (forceRemote || _localStorage.empty) {
      final result = await _remoteStorage.getCodenames(lobbyCode);

      if (result.isRight) {
        _localStorage.value = result.right;
      }

      return result;
    } else {
      return _localStorage.getValueSafe();
    }
  }
}

abstract class CodenamesRemoteStorage {
  Future<Either<Failure, List<String>>> getCodenames(String lobbyCode);
}

class CodenamesRemoteStorageImpl implements CodenamesRemoteStorage {
  @override
  Future<Either<Failure, List<String>>> getCodenames(
    String lobbyCode,
  ) {
    final dio = Dio();

    return authenticateRequest(dio)
        .thenRight((dio) => _getCodenamesRequest(dio, lobbyCode));
  }

  Future<Either<Failure, List<String>>> _getCodenamesRequest(
    Dio dio,
    String lobbyCode,
  ) async {
    try {
      final response = await dio.get(
        'codenames',
        queryParameters: {'gameCode': lobbyCode},
      );

      logger.i('/codenames: response code ${response.statusCode}');
      logger.d(response.data);

      return Right(response.data['codenames']);
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/codenames request failed\nResponse: ${response.data}',
            response: response,
            logger: logger,
          ),
        );
      } else {
        logger.e('/game_info: ${e.type.toString()} error');
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/game_info network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

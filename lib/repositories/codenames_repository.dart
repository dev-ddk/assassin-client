// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/repositories/local_storage.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class CodenamesRepository {
  final CodenamesRemoteStorage _remoteStorage;
  final LocalStorage<List<String>> _localStorage;

  CodenamesRepository({required remoteStorage})
      : _remoteStorage = remoteStorage,
        _localStorage = LocalStorage();

  Future<Either<Failure, List<String>>> getCodenames(String lobbyCode,
      {bool forceRemote = false}) async {
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
  Future<Either<Failure, List<String>>> getCodenames(String lobbyCode) {
    final dio = Dio();
    return authenticateRequest(dio)
        .thenRight((dio) => _getCodenamesRequest(dio, lobbyCode));
  }

  Future<Either<Failure, List<String>>> _getCodenamesRequest(
      Dio dio, String lobbyCode) async {
    final response =
        await dio.get('codenames', queryParameters: {'game_id': lobbyCode});
    if (response.statusCode == 200) {
      return Right(response.data['codenames']);
    } else if (response.statusCode == 401) {
      return Left(AuthFailure());
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }
}

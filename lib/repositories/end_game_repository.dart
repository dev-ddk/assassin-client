// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/repositories/local_storage.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class EndTimeRepository {
  final EndTimeRemoteStorage _remoteStorage;
  final LocalStorage<DateTime> _localStorage;

  EndTimeRepository(EndTimeRemoteStorage remoteStorage)
      : _remoteStorage = remoteStorage,
        _localStorage = LocalStorage();

  Future<Either<Failure, DateTime>> getEndTime(String lobbyCode,
      {bool forceRemote = false}) async {
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

abstract class EndTimeRemoteStorage {
  Future<Either<Failure, DateTime>> getEndTime(String lobbyCode);
}

class EndTimeRemoteStorageImpl implements EndTimeRemoteStorage {
  @override
  Future<Either<Failure, DateTime>> getEndTime(String lobbyCode) async {
    final dio = Dio();
    return await authenticateRequest(dio)
        .thenRight((dio) => _getEndTimeRequest(dio, lobbyCode));
  }

  Future<Either<Failure, DateTime>> _getEndTimeRequest(
      Dio dio, String lobbyCode) async {
    final response =
        await dio.get('end_game', queryParameters: {'game_id': lobbyCode});
    if (response.statusCode == 200) {
      return Right(
          DateTime.fromMillisecondsSinceEpoch(response.data['end_time']));
    } else if (response.statusCode == 401) {
      return Left(AuthFailure());
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }
}

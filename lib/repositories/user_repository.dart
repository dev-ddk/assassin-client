// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:assassin_client/models/user_model.dart';
import 'package:assassin_client/repositories/local_storage.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class UserRepository {
  final RemoteUserStorage _remoteStorage;
  final LocalStorage<UserModel> _localStorage;

  UserRepository({
    required remoteStorage,
  })  : _remoteStorage = remoteStorage,
        _localStorage = LocalStorage();

  Future<Either<Failure, UserModel>> userInfo({
    bool forceRemote = false,
  }) async {
    if (!_localStorage.empty && !forceRemote) {
      //Cached value
      return await _localStorage.getValueSafe();
    } else {
      //Request to endpoint
      final user = await _remoteStorage.userInfo();

      if (user.isRight) {
        _localStorage.value = user.right;
      }

      return user;
    }
  }

  Future<Either<Failure, Uri>> updatePropic(PlatformFile propic) async {
    final req = await _remoteStorage.updatePropic(propic);

    if (req.isRight) {
      _localStorage.value = _localStorage.value.withPropic(req.right);
    }

    return req;
  }
}

abstract class RemoteUserStorage {
  Future<Either<Failure, UserModel>> userInfo();

  Future<Either<Failure, Uri>> updatePropic(PlatformFile photo);
}

class RemoteUserStorageImpl implements RemoteUserStorage {
  @override
  Future<Either<Failure, UserModel>> userInfo() async {
    final dio = Dio(baseOptions());

    return authenticateRequest(dio).thenRight(_getUserRequest);
  }

  Future<Either<Failure, UserModel>> _getUserRequest(Dio dio) async {
    try {
      final response = await dio.get('ENDPOINT');

      if (response.statusCode == 200) {
        return Right(UserModel.fromJson(response.data));
      } else {
        return Left(RequestFailure());
      }
    } on DioError {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Uri>> updatePropic(PlatformFile photo) async {
    final dio = Dio(baseOptions(contentType: 'application/base64'));

    return authenticateRequest(dio)
        .thenRight((dio) => _updatePropicRequest(photo, dio));
  }

  Future<Either<Failure, Uri>> _updatePropicRequest(
    PlatformFile photo,
    Dio dio,
  ) async {
    final response = await dio.post('ENDPOINT');

    if (response.statusCode == 200) {
      return Right(response.data['link']);
    } else {
      return Left(NetworkFailure());
    }
  }
}

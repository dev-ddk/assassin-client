// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:assassin_client/models/user_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class UserRepository {
  final RemoteUserStorage remoteStorage;
  UserModel? _localUser;

  UserRepository(this.remoteStorage);

  Future<Either<Failure, UserModel>> getUser() async {
    if (_localUser != null) {
      //Cached value
      return Right(_localUser!);
    } else {
      //
      final user = await remoteStorage.getUser();
      _localUser = user.fold((left) => null, (right) => right);
      return user;
    }
  }

  Future<Either<Failure, Uri>> updatePropic(PlatformFile propic) async {
    final req = await remoteStorage.updatePropic(propic);
    if (req.isRight) {
      _localUser = _localUser?.withPropic(req.right);
    }
    return req;
  }

  void invalidateCache() {
    _localUser = null;
  }

  void fillCache(UserModel value) {
    _localUser = value;
  }
}

class RemoteUserStorage {
  Future<Either<Failure, UserModel>> getUser() async {
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

  Future<Either<Failure, Uri>> updatePropic(PlatformFile photo) async {
    final dio = Dio(baseOptions(contentType: 'application/base64'));
    return authenticateRequest(dio)
        .thenRight((dio) => _updatePropicRequest(photo, dio));
  }

  Future<Either<Failure, Uri>> _updatePropicRequest(
      PlatformFile photo, Dio dio) async {
    final response = await dio.post('ENDPOINT');
    if (response.statusCode == 200) {
      return Right(response.data['link']);
    } else {
      return Left(NetworkFailure());
    }
  }
}

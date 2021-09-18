// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/models/user_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

abstract class UserDataSource {
  Future<Either<Failure, UserModel>> userInfo();

  Future<Either<Failure, Uri>> updatePropic(PlatformFile photo);
}

class UserRemoteStorage implements UserDataSource {
  @override
  Future<Either<Failure, UserModel>> userInfo() async {
    final dio = Dio(baseOptions());

    return authenticateRequest(dio).thenRight(_getUserRequest);
  }

  Future<Either<Failure, UserModel>> _getUserRequest(
    Dio dio,
  ) async {
    try {
      final response = await dio.get('user_info');
      logger.i(response);

      return Right(UserModel.fromJson(response.data));
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/user_info request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/user_info network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, Uri>> updatePropic(PlatformFile photo) async {
    final dio = Dio(baseOptions(contentType: 'application/base64'));

    return authenticateRequest(dio)
        .thenRight((dio) => _updatePropicRequest(photo, dio));
  }

  Future<Either<Failure, Uri>> _updatePropicRequest(
      PlatformFile photo, Dio dio) async {
    try {
      final response = await dio.post('ENDPOINT');

      return Right(response.data['link']);
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/update_propic request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/update_propic network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

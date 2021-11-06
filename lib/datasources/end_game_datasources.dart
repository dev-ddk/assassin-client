// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

abstract class EndTimeDataSource {
  Future<Either<Failure, DateTime>> getEndTime(String lobbyCode);
}

class EndTimeRemoteStorage implements EndTimeDataSource {
  @override
  Future<Either<Failure, DateTime>> getEndTime(
    String lobbyCode,
  ) async {
    final dio = Dio(baseOptions());

    return await authenticateRequest(dio)
        .thenRight((dio) => _getEndTimeRequest(dio, lobbyCode));
  }

  Future<Either<Failure, DateTime>> _getEndTimeRequest(
      Dio dio, String lobbyCode) async {
    try {
      final response = await dio.get(
        'end_game',
        queryParameters: {'gameCode': lobbyCode},
      );

      return Right(
        DateTime.fromMillisecondsSinceEpoch(response.data['end_time']),
      );
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/end_game request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/end_game network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

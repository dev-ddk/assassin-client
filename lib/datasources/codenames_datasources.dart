// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

abstract class CodenamesDataSource {
  Future<Either<Failure, List<String>>> getCodenames(String lobbyCode);
}

class CodenamesRemoteStorage implements CodenamesDataSource {
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

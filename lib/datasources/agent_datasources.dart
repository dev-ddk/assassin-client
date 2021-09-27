// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:assassin_client/models/agent_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

var logger = Logger(printer: PrettyPrinter());

abstract class AgentDataSource {
  Future<Either<Failure, AgentModel>> agentInfo(String lobbyCode);

  Future<Either<Failure, void>> kill(String lobbyCode);
}

class AgentRemoteStorage implements AgentDataSource {
  @override
  Future<Either<Failure, AgentModel>> agentInfo(
    String lobbyCode,
  ) async {
    final dio = Dio(baseOptions());

    return await authenticateRequest(dio)
        .thenRight((dio) => _agentInfoRequest(dio, lobbyCode));
  }

  Future<Either<Failure, AgentModel>> _agentInfoRequest(
      Dio dio, String lobbyCode) async {
    try {
      final response = await dio.get('agent_info');

      return Right(AgentModel.fromJson(response.data));
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/agent_info request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/kill network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, AgentModel>> kill(String lobbyCode) async {
    final dio = Dio(baseOptions());

    return await authenticateRequest(dio).thenRight(_killRequest);
  }

  Future<Either<Failure, AgentModel>> _killRequest(Dio dio) async {
    try {
      final response = await dio.post('agent_info', data: {'api'});

      return Right(AgentModel.fromJson(response.data));
    } on DioError catch (e) {
      final response = e.response;

      if (response != null) {
        return Left(
          RequestFailure.log(
            code: 'REQ-001',
            message: '/kill request failure',
            response: response,
            logger: logger,
          ),
        );
      } else {
        return Left(
          DioNetworkFailure.log(
            code: 'NET-000',
            message: '/kill network failure',
            errorType: e.type,
            logger: logger,
            level: Level.error,
          ),
        );
      }
    }
  }
}

// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/models/agent_model.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class AgentRepository {
  final RemoteAgentStorage _remoteStorage;
  final LocalAgentStorage _localStorage;

  AgentRepository({required remoteStorage, required localStorage})
      : _remoteStorage = remoteStorage,
        _localStorage = localStorage;

  Future<Either<Failure, AgentModel>> agentInfo() async {
    if (_localStorage.empty) {
      final result = await _remoteStorage.agentInfo();
      if (result.isRight) {
        _localStorage.agent = result.right;
      }
      return result;
    } else {
      return _localStorage.agentInfo();
    }
  }

  Future<Either<Failure, AgentModel>> kill() async {
    _localStorage.clearStorage();
    return await _remoteStorage.agentInfo().thenRight((right) => agentInfo());
  }

  void clearStorage() {
    _localStorage.clearStorage();
  }
}

abstract class RemoteAgentStorage {
  Future<Either<Failure, AgentModel>> agentInfo();

  Future<Either<Failure, void>> kill();
}

class RemoteAgentStorageImpl implements RemoteAgentStorage {
  @override
  Future<Either<Failure, AgentModel>> agentInfo() async {
    final dio = Dio(baseOptions());
    return await authenticateRequest(dio).thenRight(_agentInfoRequest);
  }

  Future<Either<Failure, AgentModel>> _agentInfoRequest(Dio dio) async {
    final response = await dio.get('agent_info');
    if (response.statusCode == 200) {
      return Right(AgentModel.fromJson(response.data));
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AgentModel>> kill() async {
    final dio = Dio(baseOptions());
    return await authenticateRequest(dio).thenRight(_killRequest);
  }

  Future<Either<Failure, AgentModel>> _killRequest(Dio dio) async {
    final response = await dio.post('agent_info');
    if (response.statusCode == 200) {
      return Right(AgentModel.fromJson(response.data));
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }
}

class LocalAgentStorage {
  AgentModel? _agent;

  Future<Either<Failure, AgentModel>> agentInfo() => _agent != null
      ? Future.value(Right(_agent!))
      : Future.value(Left(CacheFailure()));

  set agent(AgentModel agent) => _agent = agent;

  void clearStorage() => _agent = null;

  bool get empty => _agent == null;
}

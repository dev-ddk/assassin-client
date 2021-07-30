// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

// Project imports:
import 'package:assassin_client/models/agent_model.dart';
import 'package:assassin_client/repositories/local_storage.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/login_utils.dart';

class AgentRepository {
  final RemoteAgentStorage _remoteStorage;
  final LocalStorage<AgentModel> _localStorage;

  AgentRepository({required remoteStorage, required localStorage})
      : _remoteStorage = remoteStorage,
        _localStorage = localStorage;

  Future<Either<Failure, AgentModel>> agentInfo(String lobbyCode,
      {bool forceRemote = false}) async {
    if (!_localStorage.empty && !forceRemote) {
      //Cached value
      return await _localStorage.getValueSafe();
    } else {
      //Request to endpoint
      final agent = await _remoteStorage.agentInfo(lobbyCode);
      if (agent.isRight) {
        _localStorage.value = agent.right;
      }
      return agent;
    }
  }

  Future<Either<Failure, AgentModel>> kill(String lobbyCode) async {
    _localStorage.clearStorage();
    return await _remoteStorage
        .agentInfo(lobbyCode)
        .thenRight((right) => agentInfo(lobbyCode));
  }

  void clearStorage() {
    _localStorage.clearStorage();
  }
}

abstract class RemoteAgentStorage {
  Future<Either<Failure, AgentModel>> agentInfo(String lobbyCode);

  Future<Either<Failure, void>> kill(String lobbyCode);
}

class RemoteAgentStorageImpl implements RemoteAgentStorage {
  @override
  Future<Either<Failure, AgentModel>> agentInfo(String lobbyCode) async {
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
  Future<Either<Failure, AgentModel>> kill(String lobbyCode) async {
    final dio = Dio(baseOptions());
    return await authenticateRequest(dio).thenRight(_killRequest);
  }

  Future<Either<Failure, AgentModel>> _killRequest(Dio dio) async {
    final response = await dio.post('agent_info', data: {'api'});
    if (response.statusCode == 200) {
      return Right(AgentModel.fromJson(response.data));
    } else if (response.statusCode != null) {
      return Left(RequestFailure());
    } else {
      return Left(NetworkFailure());
    }
  }
}

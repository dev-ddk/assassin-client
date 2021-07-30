// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:either_dart/either.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/models/agent_model.dart';
import 'package:assassin_client/models/user_model.dart';
import 'package:assassin_client/repositories/agent_repository.dart';
import 'package:assassin_client/repositories/user_repository.dart';
import 'package:assassin_client/utils/failures.dart';

class AgentUpdater extends ChangeNotifier {
  Timer? _updater;
  final AgentRepository _agent;
  final UserRepository _user;
  Either<Failure, AgentModel>? _lastAgent;
  final Duration updatePeriod;

  AgentUpdater({
    required AgentRepository agentRepository,
    required UserRepository userRepository,
    this.updatePeriod = const Duration(seconds: 10),
  })  : _agent = agentRepository,
        _user = userRepository;

  Future<Either<Failure, AgentModel>> get agent => _requestAgentIfLastIsEmpty();

  void start() {
    _updater = Timer.periodic(
      updatePeriod,
      (timer) {
        unawaited(
          _user
              .userInfo()
              .thenRightSync((user) => _getLobbyCodeOrFail(user))
              .thenRight((code) => _agent.agentInfo(code))
              .then((agent) {
            _lastAgent = agent;
            notifyListeners();
          }),
        );
      },
    );
  }

  void stop() {
    _updater?.cancel();
    _updater = null;
    _lastAgent = null;
  }

  Either<Failure, String> _getLobbyCodeOrFail(UserModel user) {
    final lobbyCode = user.currLobbyCode;
    if (lobbyCode != null) {
      return Right(lobbyCode);
    } else {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, AgentModel>> _requestAgentIfLastIsEmpty() async {
    if (_lastAgent == null) {
      return await _user
          //Get current lobby code (force the refresh of the data)
          .userInfo(forceRemote: true)
          //Fail if the lobby code is null
          .thenRightSync(_getLobbyCodeOrFail)
          //Retrieve agent information
          .thenRight((lobbyCode) => _agent.agentInfo(lobbyCode))
          .then((agentModel) => _lastAgent = agentModel);
    } else {
      return Future.value(_lastAgent);
    }
  }
}

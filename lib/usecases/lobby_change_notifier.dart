// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:either_dart/either.dart';
import 'package:either_dart/src/future_extension.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/models/user_model.dart';
import 'package:assassin_client/repositories/lobby_repository.dart';
import 'package:assassin_client/repositories/user_repository.dart';
import 'package:assassin_client/utils/failures.dart';

class LobbyUpdater extends ChangeNotifier {
  Timer? _updater;
  final LobbyRepository _lobby;
  final UserRepository _user;
  Either<Failure, LobbyModel> _lastLobby;

  LobbyUpdater(lobbyRepository, userRepository)
      : _lobby = lobbyRepository,
        _user = userRepository,
        _lastLobby = Left(CacheFailure());

  bool get started => _updater != null;

  Either<Failure, LobbyModel> get lobby => _lastLobby;

  void start() {
    _updater = Timer.periodic(Duration(seconds: 10), (timer) {
      unawaited(_user
          .userInfo()
          .thenRightSync(_forceGetLobbyCode)
          .thenRight((lobbyCode) => _lobby.lobbyInfo(lobbyCode))
          .then((lobbyModel) {
        _lastLobby = lobbyModel;
        notifyListeners();
      }));
    });
  }

  void stop() {
    _updater?.cancel();
    _updater = null;
  }

  Either<Failure, String> _forceGetLobbyCode(UserModel user) {
    final lobbyCode = user.currLobbyCode;
    if (lobbyCode != null) {
      return Right(lobbyCode);
    } else {
      return Left(CacheFailure());
    }
  }
}

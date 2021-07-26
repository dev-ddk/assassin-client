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
  Either<Failure, LobbyModel>? _lastLobby;

  LobbyUpdater(lobbyRepository, userRepository)
      : _lobby = lobbyRepository,
        _user = userRepository,
        _lastLobby = null;

  bool get started => _updater != null;

  Future<Either<Failure, LobbyModel>> get lobby async {
    if (_lastLobby == null) {
      //If it is the first time that the getter is called
      return await _user
          .userInfo(
              forceRemote:
                  true) //Get current lobby code (force the refresh of the data)
          .thenRightSync(
              _forceGetLobbyCode) //Throw a failure if the lobby code is null
          .thenRight((lobbyCode) =>
              _lobby.lobbyInfo(lobbyCode)) //Retrieve lobby information
          .then((lobbyModel) => _lastLobby = lobbyModel);
    } else {
      return Future.value(_lastLobby); //Return immediately the result
    }
  }

  void start() {
    _updater = Timer.periodic(
      Duration(seconds: 10),
      (timer) {
        unawaited(
          _user
              .userInfo() //Get user information (cached)
              .thenRightSync(_forceGetLobbyCode)
              .thenRight((lobbyCode) => _lobby.lobbyInfo(lobbyCode))
              .then((lobbyModel) {
            _lastLobby = lobbyModel; //Set the last lobby value
            notifyListeners(); //Notify the view that the lobby changed
          }),
        );
      },
    );
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

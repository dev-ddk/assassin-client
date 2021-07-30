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
  final Duration updatePeriod;

  LobbyUpdater(
    lobbyRepository,
    userRepository, {
    this.updatePeriod = const Duration(seconds: 10),
  })  : _lobby = lobbyRepository,
        _user = userRepository,
        _lastLobby = null;

  bool get started => _updater != null;

  ///Retrieves the lobby info
  Future<Either<Failure, bool>> get admin async {
    return await _requestLobbyIfLastIsEmpty()
        //Use the last lobby value for checking if the user is the admin of the lobby
        .thenRight((lobby) =>
            _user.userInfo().mapRight((user) => lobby.isAdmin(user.username)));
  }

  ///Retrieves the lobby info
  Future<Either<Failure, LobbyModel>> get lobby async =>
      await _requestLobbyIfLastIsEmpty();

  ///Starts the autoupdater
  void start() {
    _updater = Timer.periodic(
      updatePeriod,
      (timer) {
        unawaited(
          _user
              //Get user information (cached)
              .userInfo()
              .thenRightSync(_forceGetLobbyCode)
              //Request Lobby Info
              .thenRight((lobbyCode) => _lobby.lobbyInfo(lobbyCode))
              //When request completes notify the view
              .then(
            (lobbyModel) {
              //Set the last lobby value
              _lastLobby = lobbyModel;
              //Notify the view that the lobby changed
              notifyListeners();
            },
          ),
        );
      },
    );
  }

  ///Halts the autoupdater
  void stop() {
    _updater?.cancel();
    _updater = null;
    _lastLobby = null;
  }

  Future<Either<Failure, LobbyModel>> _requestLobbyIfLastIsEmpty() async {
    if (_lastLobby == null) {
      return await _user
          //Get current lobby code (force the refresh of the data)
          .userInfo(forceRemote: true)
          //Fail if the lobby code is null
          .thenRightSync(_forceGetLobbyCode)
          //Retrieve lobby information
          .thenRight((lobbyCode) => _lobby.lobbyInfo(lobbyCode))
          .then((lobbyModel) => _lastLobby = lobbyModel);
    } else {
      return Future.value(_lastLobby);
    }
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

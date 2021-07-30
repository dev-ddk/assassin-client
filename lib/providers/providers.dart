// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/controllers/lobby_change_notifier.dart';
import 'package:assassin_client/fakes/lobby_storage_mock.dart';
import 'package:assassin_client/repositories/lobby_repository.dart';
import 'package:assassin_client/repositories/user_repository.dart';

final userProvider =
    Provider((ref) => UserRepository(remoteStorage: RemoteUserStorageMock()));

final lobbyProvider =
    Provider((ref) => LobbyRepository(RemoteLobbyStorageMock()));

final lobbyUpdaterProvider = ChangeNotifierProvider((ref) =>
    LobbyUpdater(ref.watch(lobbyProvider), ref.watch(userProvider))..start());

// Package imports:
import 'package:either_dart/src/either.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/models/user_model.dart';
import 'package:assassin_client/repositories/lobby_repository.dart';
import 'package:assassin_client/repositories/user_repository.dart';
import 'package:assassin_client/utils/failures.dart';

class RemoteLobbyStorageMock implements RemoteLobbyStorage {
  int i = 0;

  @override
  Future<Either<Failure, LobbyModel>> gameInfo(String lobbyCode) async {
    i = (i + 1) % 2;
    await Future.delayed(Duration(seconds: 4));
    if (i == 0) {
      return Right(
        LobbyModel(
          code: 'AAAAAA',
          name: 'casa cesaroni',
          admin: 'luigi',
          players: [
            UserLobbyModel('mario', Uri.dataFromString('aaaa')),
            UserLobbyModel('luigi', Uri.dataFromString('aaaa'))
          ],
        ),
      );
    } else {
      return Right(
        LobbyModel(
          code: 'AAAAAA',
          name: 'casa cesaroni',
          admin: 'Dario',
          players: [
            UserLobbyModel('mario', Uri.dataFromString('wario')),
            UserLobbyModel('antonio', Uri.dataFromString('aaaa')),
            UserLobbyModel('a', Uri.dataFromString('aaaa')),
            UserLobbyModel('b', Uri.dataFromString('bbbb')),
            UserLobbyModel('c', Uri.dataFromString('cccc')),
            UserLobbyModel('d', Uri.dataFromString('dddd')),
            UserLobbyModel('e', Uri.dataFromString('eeee')),
            UserLobbyModel('f', Uri.dataFromString('ffff')),
            UserLobbyModel('g', Uri.dataFromString('gggg')),
          ],
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> createGame(String lobbyName) {
    // TODO: implement createGame
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> joinGame(String lobbyCode) {
    // TODO: implement joinGame
    throw UnimplementedError();
  }
}

class RemoteUserStorageMock implements RemoteUserStorage {
  @override
  Future<Either<Failure, UserModel>> userInfo() async {
    await Future.delayed(Duration(seconds: 2));
    return Right(
      UserModel(
        email: 'cci@aaa.it',
        username: 'Dario',
        propic: Uri.dataFromString('aaaaa'),
        active: true,
        currLobbyCode: 'AAAAAAA',
        totalKills: 0,
      ),
    );
  }

  @override
  Future<Either<Failure, Uri>> updatePropic(PlatformFile photo) {
    // TODO: implement updatePropic
    throw UnimplementedError();
  }
}

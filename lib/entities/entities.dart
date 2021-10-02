// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:assassin_client/models/game_status_model.dart';
import 'package:assassin_client/models/user_model.dart';

part 'entities.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  UserEntity._();

  factory UserEntity({
    required String email,
    required String username,
    Uri? propic,
    String? currGameCode,
    required int totalKills,
  }) = _UserEntity;

  static UserEntity fromUserModel(UserModel user) => UserEntity(
        email: user.email,
        username: user.username,
        propic: user.propic,
        currGameCode: user.currLobbyCode,
        totalKills: user.totalKills,
      );

  bool get active => currGameCode != null;
}

@freezed
class OtherUserEntity with _$OtherUserEntity {
  factory OtherUserEntity({
    required String username,
    Uri? propic,
  }) = _OtherUserEntity;
}

@freezed
class GameEntity with _$GameEntity {
  factory GameEntity({
    required String gameName,
    required String gameCode,
    @Default(<OtherUserEntity>[]) List<OtherUserEntity> users,
    @Default(GameStatus.WAITING) GameStatus gameStatus,
    required String admin,
  }) = _GameEntity;
}

@freezed
class AgentEntity with _$AgentEntity {
  AgentEntity._();

  factory AgentEntity({
    required String agentName,
    String? target,
    @Default(true) bool alive,
    @Default(0) int kills,
  }) = _AgentEntity;

  bool get hasActiveTarget => target != null && alive;
}

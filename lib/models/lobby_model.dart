// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'lobby_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LobbyModel {
  @JsonKey(name: 'game_name')
  final String name;
  @JsonKey(ignore: true)
  late final String lobbyCode;
  @JsonKey(name: 'admin_nickame')
  String? admin;
  final List<UserLobbyModel> players;

  LobbyModel({
    required this.name,
    this.admin,
    List<UserLobbyModel>? players,
  }) : players = players ?? [];

  factory LobbyModel.fromJson(String lobbyCode, Map<String, dynamic> json) {
    return _$LobbyModelFromJson(json)..lobbyCode = lobbyCode;
  }

  Map<String, dynamic> toJson() => _$LobbyModelToJson(this);

  bool isAdmin(String username) => admin != null && username == admin;
}

@JsonSerializable(explicitToJson: true)
class UserLobbyModel {
  @JsonKey(name: 'nickname')
  final String username;
  final Uri? propic;

  UserLobbyModel(this.username, this.propic);

  factory UserLobbyModel.fromJson(Map<String, dynamic> json) =>
      _$UserLobbyModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLobbyModelToJson(this);
}

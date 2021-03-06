// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'lobby_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LobbyModel {
  @JsonKey(name: 'game_name')
  final String name;
  @JsonKey(name: 'admin_nickname')
  String admin;
  @JsonKey(name: 'start_time')
  DateTime? startTime;
  final List<UserLobbyModel> players;

  LobbyModel({
    required this.name,
    required this.admin,
    List<UserLobbyModel>? players,
  }) : players = players ?? [];

  factory LobbyModel.fromJson(Map<String, dynamic> json) {
    return _$LobbyModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LobbyModelToJson(this);

  bool isAdmin(String username) => username == admin;
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

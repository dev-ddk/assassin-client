// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'lobby_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LobbyModel {
  @JsonKey(name: 'lobby_code')
  final String code;
  @JsonKey(name: 'lobby_name')
  final String name;
  @JsonKey(name: 'admin_name')
  String? admin;
  final List<UserLobbyModel> players;

  LobbyModel({required this.code, required this.name, this.admin, players})
      : players = players ?? [];

  factory LobbyModel.fromJson(Map<String, dynamic> json) =>
      _$LobbyModelFromJson(json);
  Map<String, dynamic> toJson() => _$LobbyModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserLobbyModel {
  final String username;
  final Uri propic;

  UserLobbyModel(this.username, this.propic);

  factory UserLobbyModel.fromJson(Map<String, dynamic> json) =>
      _$UserLobbyModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserLobbyModelToJson(this);
}
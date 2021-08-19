// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String email;
  @JsonKey(name: 'nickname')
  final String username;
  @JsonKey(name: 'picture')
  final Uri? propic;
  final bool active;
  @JsonKey(name: 'curr_lobby_code')
  final String? currLobbyCode;
  @JsonKey(name: 'total_kills')
  final int totalKills;

  UserModel({
    required this.email,
    required this.username,
    required this.propic,
    required this.active,
    this.currLobbyCode,
    required this.totalKills,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel withPropic(Uri newPropic) {
    return UserModel(
      email: email,
      username: username,
      propic: newPropic,
      active: active,
      totalKills: totalKills,
    );
  }
}

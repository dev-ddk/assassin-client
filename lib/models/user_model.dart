// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String email;
  final String username;
  final Uri propic;
  final bool active;
  final String? currLobbyCode;
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

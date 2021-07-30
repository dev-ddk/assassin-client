// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LobbyModel _$LobbyModelFromJson(Map<String, dynamic> json) {
  return LobbyModel(
    code: json['lobby_code'] as String,
    name: json['lobby_name'] as String,
    admin: json['admin_name'] as String?,
    players: (json['players'] as List<dynamic>?)
        ?.map((e) => UserLobbyModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LobbyModelToJson(LobbyModel instance) =>
    <String, dynamic>{
      'lobby_code': instance.code,
      'lobby_name': instance.name,
      'admin_name': instance.admin,
      'players': instance.players.map((e) => e.toJson()).toList(),
    };

UserLobbyModel _$UserLobbyModelFromJson(Map<String, dynamic> json) {
  return UserLobbyModel(
    json['username'] as String,
    Uri.parse(json['propic'] as String),
  );
}

Map<String, dynamic> _$UserLobbyModelToJson(UserLobbyModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'propic': instance.propic.toString(),
    };

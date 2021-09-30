// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LobbyModel _$LobbyModelFromJson(Map<String, dynamic> json) {
  return LobbyModel(
    name: json['game_name'] as String,
    admin: json['admin_nickame'] as String?,
    players: (json['players'] as List<dynamic>?)
        ?.map((e) => UserLobbyModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LobbyModelToJson(LobbyModel instance) =>
    <String, dynamic>{
      'game_name': instance.name,
      'admin_nickame': instance.admin,
      'players': instance.players.map((e) => e.toJson()).toList(),
    };

UserLobbyModel _$UserLobbyModelFromJson(Map<String, dynamic> json) {
  return UserLobbyModel(
    json['nickname'] as String,
    json['propic'] == null ? null : Uri.parse(json['propic'] as String),
  );
}

Map<String, dynamic> _$UserLobbyModelToJson(UserLobbyModel instance) =>
    <String, dynamic>{
      'nickname': instance.username,
      'propic': instance.propic?.toString(),
    };

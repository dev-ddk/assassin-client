// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LobbyModel _$LobbyModelFromJson(Map<String, dynamic> json) => LobbyModel(
      name: json['game_name'] as String,
      admin: json['admin_nickname'] as String,
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => UserLobbyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..startTime = json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String);

Map<String, dynamic> _$LobbyModelToJson(LobbyModel instance) =>
    <String, dynamic>{
      'game_name': instance.name,
      'admin_nickname': instance.admin,
      'start_time': instance.startTime?.toIso8601String(),
      'players': instance.players.map((e) => e.toJson()).toList(),
    };

UserLobbyModel _$UserLobbyModelFromJson(Map<String, dynamic> json) =>
    UserLobbyModel(
      json['nickname'] as String,
      json['propic'] == null ? null : Uri.parse(json['propic'] as String),
    );

Map<String, dynamic> _$UserLobbyModelToJson(UserLobbyModel instance) =>
    <String, dynamic>{
      'nickname': instance.username,
      'propic': instance.propic?.toString(),
    };

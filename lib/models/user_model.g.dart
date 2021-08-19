// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    email: json['email'] as String,
    username: json['nickname'] as String,
    propic:
        json['picture'] == null ? null : Uri.parse(json['picture'] as String),
    active: json['active'] as bool,
    currLobbyCode: json['curr_lobby_code'] as String?,
    totalKills: json['total_kills'] as int,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'nickname': instance.username,
      'picture': instance.propic?.toString(),
      'active': instance.active,
      'curr_lobby_code': instance.currLobbyCode,
      'total_kills': instance.totalKills,
    };
